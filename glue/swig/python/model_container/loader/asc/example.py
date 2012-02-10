"""!

This package is responsible for parsing acs files
into a python dict for use by external applications.

This is an expanded from an example from:

    http://www.evanfosmark.com/2009/02/sexy-lexing-with-python/
    
"""
import re






#************************* Begin  ********************************


#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------

class UnknownTokenError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, token, lineno):
        self.token = token
        self.lineno = lineno
 
    def __str__(self):
        return "Line #%s, Found token: %s" % (self.lineno, self.token)
 
 
class _InputScanner(object):
    """ This class manages the scanning of a specific input. An instance of it is
        returned when scan() is called. It is built to be great for iteration. This is
        mainly to be used by the Lexer and ideally not directly.
    """
 
    def __init__(self, lexer, input):
        """ Put the lexer into this instance so the callbacks can reference it 
            if needed.
        """
        self._position = 0
        self.lexer = lexer
        self.input = input
 
    def __iter__(self):
        """ All of the code for iteration is controlled by the class itself.
            This and next() (or __next__() in Python 3.0) are so syntax
            like `for token in Lexer(...):` is valid and works.
        """
        return self
 
    def next(self):
        """ Used for iteration. It returns token after token until there
            are no more tokens. (change this to __next__(self) if using Py3.0)
        """
        if not self.done_scanning():
            return self.scan_next()
        raise StopIteration
 
    def done_scanning(self):
        """ A simple boolean function that returns true if scanning is
            complete and false if it isn't.
        """
        return self._position >= len(self.input)
 
    def scan_next(self):
        """ Retreive the next token from the input. If the
            flag `omit_whitespace` is set to True, then it will
            skip over the whitespace characters present.
        """
        if self.done_scanning():
            return None
        if self.lexer.omit_whitespace:
            match = self.lexer.ws_regexc.match(self.input, self._position)
            if match:
                self._position = match.end()
        match = self.lexer.regexc.match(self.input, self._position)
        if match is None:
            lineno = self.input[:self._position].count("\n") + 1
            raise UnknownTokenError(self.input[self._position], lineno)
        self._position = match.end()
        value = match.group(match.lastgroup)
        if match.lastgroup in self.lexer._callbacks:
            value = self.lexer._callbacks[match.lastgroup](self, value)
        return match.lastgroup, value
 
 
class Lexer(object):
    """ A lexical scanner. It takes in an input and a set of rules based
        on reqular expressions. It then scans the input and returns the
        tokens one-by-one. It is meant to be used through iterating.
    """
 
    def __init__(self, rules, case_sensitive=True, omit_whitespace=True):
        """ Set up the lexical scanner. Build and compile the regular expression
            and prepare the whitespace searcher.
        """
        self._callbacks = {}
        self.omit_whitespace = omit_whitespace
        self.case_sensitive = case_sensitive
        parts = []
        for name, rule in rules:
            if not isinstance(rule, str):
                rule, callback = rule
                self._callbacks[name] = callback
            parts.append("(?P<%s>%s)" % (name, rule))
        if self.case_sensitive:
            flags = re.M
        else:
            flags = re.M|re.I
        self.regexc = re.compile("|".join(parts), flags)
        self.ws_regexc = re.compile("\s*", re.MULTILINE)
 
    def scan(self, input):
        """ Return a scanner built for matching through the `input` field. 
            The scanner that it returns is built well for iterating.
        """
        return _InputScanner(self, input)



def stmnt_callback(scanner, token):
    """ This is just an example of providing a function to run the
        token through.
    """
    return ""

if __name__ == '__main__':

    rules = [
        ("IDENTIFIER", r"[a-zA-Z_]\w*"),
        ("OPERATOR",   r"\+|\-|\\|\*|\="),
        ("DIGIT",      r"[0-9]+(\.[0-9]+)?"),
        ("END_STMNT",  (";", stmnt_callback)), 
        ]
 
    lex = Lexer(rules, case_sensitive=True)
    for token in lex.scan("foo = 5 * 30; bar = bar - 60;"):
        print token



"""
collect example

#!/usr/bin/env python
import sys, string
 
def collect(file):
    entries = {}
    for line in file.readlines():
        left, right = string.split(line)    
        try:                                
            entries[right].append(left)           # extend list
        except KeyError:
            entries[right] = [left]               # first time seen
    return entries
 
if _ _name_ _ == "_ _main_ _":                        # when run as a script
    if len(sys.argv) == 1:
        result = collect(sys.stdin)               # read from stdin stream
    else:
        result = collect(open(sys.argv[1], 'r'))  # read from passed filename
    for (right, lefts) in result.items():
        print "%04d '%s'\titems => %s" % (len(lefts), right, lefts)

"""

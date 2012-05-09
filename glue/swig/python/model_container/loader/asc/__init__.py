"""!

This is a recursive descent parser for parsing
acs files



"""
import os
import pdb
import re
import sys




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


class ParseError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, token, lineno):
        self.token = token
        self.lineno = lineno
 
    def __str__(self):
        return "Error on line #%s, at: %s" % (self.lineno, self.token)


_reserved_symbols = ['(', '\"', ')', ';', '|']

#************************* Begin ASCParser  ************************************
class ASCParser:
    """

    Comment -> ^; token...token \n
    Goal -> Morphology
    Comment -> ; chars \n
    Morphology -> Section Blocks 
    Section -> ( 'Section' )
    Blocks -> ( Block ) ... ( Block )
    Block -> Contour | Dendrite | Tree
    Contour -> ( Name Color ( 'CellBody' ) Values ) '; End of Contour'
    Color -> ( 'Color' string ) ; string
    Name -> \" string \" 
    Values -> Value Value ... Value
    Value -> ( double double double double ) ; ID
    ID -> string, string
    Dendrite -> ( Name Color ( 'Dendrite' ) Values|Splits )
    Splits -> ( Split ... Split )
    Split -> Values
    
    """
    def __init__(self, text=None, file=None, verbose=False, model_container=None):

        self.collection = {}
        self.verbose = verbose
        self.model_container = model_container

        self.num_chars = -1
        self.curr_position = -1 # This will get incremented by 1 right off the bat
        self.curr_char = ''
        self.curr_token = ""

        self.text = ""

        if not text is None:

            self.text = text
        
        elif not file is None:
           
            if os.path.isfile(file):
                
                f = open(file,'rb')

                self.text = f.read()

                f.close()
                
            else:

                raise Exception("File '%s' doesnt' exist" % file)

        else:

            raise Exception("Can't initialize ACS parser, no suitable text or file given.")


        self.num_chars = len(self.text)

        self.line_number = 1
        self.token_count = 0
        
#-------------------------------------------------------------------------------        

    def parse(self):

        token = None
        
        while True:

            token = self.next()

            if token is None:

                break

            elif token == ";":

                # We parse out a comment line

                self._comment()
                
                
            elif token == "(":
                
                # start of on or a set of blocks

                self._block()

#-------------------------------------------------------------------------------

    def get_line_number(self):

        return self.line_number

#-------------------------------------------------------------------------------

    def get_token_count(self):

        return self.token_count

#-------------------------------------------------------------------------------

    def next(self, return_newline=False):

        token_found = False

        token = ""

        ch = ''

        while not token_found:

            ch = self._next_char()

            if ch == '\n':

                self.line_number += 1
                
            if ch is None:

                return None

            elif ch in _reserved_symbols:

                token_found = True

                token = ch

                self.token_count += 1
            
            elif ch.isspace() or self._peek() in _reserved_symbols or self._peek() == '\n':

                if len(token) > 0:

                    if self._peek() in _reserved_symbols:

                        token += ch
                        
                    token_found = True

                    self.token_count += 1

                elif return_newline and ch == '\n':

                    token_found = True

                    token = ch
                    
                    self.token_count += 1
                
                # keep going if we have white space
                continue
                
            else:
                                    
                token += ch

        
        return token
    
#-------------------------------------------------------------------------------

    def _next_char(self):

        self.curr_position = self.curr_position + 1
        
        if self.curr_position < self.num_chars:

            return self.text[ self.curr_position ]

        else:

            # We're done
            return None


#-------------------------------------------------------------------------------

    def _comment(self):

        token = None

        if self.verbose:

            print "Parsing comment on line %d" % self.get_line_number()
            
        while token != '\n':

            token = self.next(return_newline=True)
        
#-------------------------------------------------------------------------------

    def _peek(self):
        """
        See the next character
        """
        if self.curr_position + 1 < self.num_chars:

            return self.text[ self.curr_position + 1 ]

        else:

            # We're done
            return None
        

#-------------------------------------------------------------------------------

    def _morphology(self):

        pass

#-------------------------------------------------------------------------------

    def _section(self):

        pass


#-------------------------------------------------------------------------------

    def _blocks(self):

        pass


#-------------------------------------------------------------------------------

    def _block(self):

        pass


#-------------------------------------------------------------------------------

    def _contour(self):

        pass


#-------------------------------------------------------------------------------

    def _color(self):

        pass


#-------------------------------------------------------------------------------

    def _name(self):

        pass


#-------------------------------------------------------------------------------

    def _values(self):

        pass


#-------------------------------------------------------------------------------

    def _value(self):

        pass


#-------------------------------------------------------------------------------

    def _id(self):

        pass


#-------------------------------------------------------------------------------

    def _dendrite(self):

        pass


#-------------------------------------------------------------------------------

    def _splits(self):

        pass


#-------------------------------------------------------------------------------

    def _split(self):

        pass


        
        




#-------------------------------------------------------------------------------




 
 

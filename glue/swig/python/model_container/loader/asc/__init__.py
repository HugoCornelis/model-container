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
        encountered in the token stream. It holds the line number and the
        offending token.
    """
    def __init__(self, token, lineno):
        self.token = token
        self.lineno = lineno
 
    def __str__(self):
        return "Unknown Token, line #%s, Found token: '%s'" % (self.lineno, self.token)


class UnknownTokenError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, expected, token, lineno):
        self.token = token
        self.lineno = lineno
        self.expected = expected
 
    def __str__(self):
        return "Unknown Token, line #%s, Found token: '%s', expected '%s'" % (self.lineno,self.token,self.expected)

class ParseError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, token, lineno):
        self.token = token
        self.lineno = lineno
 
    def __str__(self):
        return "Parse error on line #%s, at: '%s'" % (self.lineno, self.token)



class ParseError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, error_msg, token, lineno):
        self.token = token
        self.lineno = lineno
        self.error_msg = error_msg
 
    def __str__(self):
        return "Parse error on line #%s, at '%s': %s" % (self.lineno, self.token, self.error_msg)


class ParseFinished(Exception):
    pass


_reserved_symbols = ['(', '\"', ')', ';', '|']

#************************* Begin ASCParser  ************************************
class ASCParser:
    """

    Comment -> ^; token...token \n
    Goal -> Morphology
    Comment -> ; chars \n
    Morphology -> Blocks 
    Sections -> ( 'Sections' ) 
    Blocks -> ( Block ) ... ( Block )
    Block -> Sections | Contour | Dendrite | Tree | ImageCoords
    CellBody -> ( Name Color ( 'CellBody' ) Values ) '; End of Contour'    
    Color -> ( 'Color' string ) ; string
    Name -> \" string \" 
    Values -> Value Value ... Value
    Value -> ( double double double double ) ; ID
    ID -> string, string
    Dendrite -> ( Name Color ( 'Dendrite' ) Values|Splits )
    Splits -> ( Split ... Split )
    Split -> Values
    
    """
    def __init__(self, text=None, file=None, verbose=False, parse_only=False, model_container=None):

        self.collection = {}
        self.verbose = verbose
        self.parse_only = parse_only
        self.model_container = model_container

        self.num_chars = -1
        self.curr_position = -1 # This will get incremented by 1 right off the bat
        self.curr_char = ''
        self.curr_token = ""
        
        self.curr_name = None
        self.curr_color = None
        self.curr_block_type = None

        self.split_types = ['Normal', 'Incomplete']

        self.level = 0
        
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

    def _is_split_type(self, t):

        for st in self.split_types:

            if t == st:

                return True

        return False
    
#-------------------------------------------------------------------------------        

    def parse(self):
        """
        Here we just run blocks to parse through all the blocks
        in the file.
        """
        try:
            
            self._blocks()

        except ParseFinished:

            if self.verbose:

                print "Done parsing: %d lines with %d tokens" % (self.line_number, self.token_count)

#        token = None

        # Really only one loop should go to completion
#         while True:
            
#             token = self.next()
        
#             if token is None:

#                 raise ParseError("Nothing to parse", "(null)", self.get_line_number())

#             elif token == ";":

#                 # We parse out a comment line

#                 self._comment()
                
                
#             elif token == "(":
                
#                 # start of a block or a set of blocks

#                 self._morphology()

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
                
            if ch is None or len(ch) == 0:

                self.curr_token = None

                raise ParseFinished()
                
                return None

            elif ch in _reserved_symbols:

                token_found = True

                token = ch

                self.token_count += 1
            
            elif ch.isspace() or self._peek() in _reserved_symbols or self._peek() == '\n':

                if len(token) > 0:

                    if self._peek() in _reserved_symbols or self._peek() == '\n':

                        if not ch.isspace():
                            
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

        if token == '(':

            self.level += 1

        elif token == ')':

            self.level -=1

        self.curr_token = token

        return token
    
#-------------------------------------------------------------------------------

    def _next_char(self):

        self.curr_position = self.curr_position + 1
        
        if self.curr_position < self.num_chars:

            try:
                
                return self.text[ self.curr_position ]

            except IndexError:

                return None
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

    def _metadata(self):

        token = None

        metadata = []
        
        if self.verbose:

            print "Parsing metadata on line %d" % self.get_line_number()
            
        while token != '\n':
            
            token = self.next(return_newline=True)

            metadata.append(token)

        # This stops on the newline, so we need to get next token to get
        # a real token.

        self.next()

        return ' '.join(metadata)
    
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
        """
           Morphology -> Section] Blocks
    
        Morphology starts off knowing that the first token is
        '(' and nothing else. We check for the sections token, then
        the blocks.
        """

        token = None

        token = self.next()

        if token != "Sections":

            raise UnknownTokenError("Sections", token, self.get_line_number())

        else:

            if self.verbose:

                print "Found 'Sections' block"
                
        token = self.next()

        if token != ')':

            raise ParseError("Error Morphology, no closing parenthesis for 'Sections'", token, self.get_line_number())

        # now parse blocks
        
        self._blocks()
        
#-------------------------------------------------------------------------------

    def _sections(self):
        """
        Should start off with Sections as the current token. This method just
        parses to the second parens.

        Parses:
            Sections -> ( 'Sections' ) 
        """

        if self.verbose:

            print "Parsing Sections block at line %d" % (self.get_line_number())
        
        token = None

        if self.curr_token != "Sections":

            raise UnknownTokenError("Sections", self.curr_token, self.get_line_number())

        else:

            if self.verbose:

                print "Found 'Sections' block"
                
        token = self.next()

        if token != ')':

            raise ParseError("Error Morphology, no closing parenthesis for 'Sections'", token, self.get_line_number())


#-------------------------------------------------------------------------------

    def _blocks(self):
        """
        Blocks -> ( Block ) ... ( Block )

        Here we process a block, or a number of blocks.
        """

        token = None

        while True:
                
            token = self.next()

            if token is None:
                # we're done
                break
            
            elif token == '(':

                # if the block finishes and leaves off on a ')'
                # it should be ok. If it does not this will throw an
                # exception. The next iteration of the loop will parse it out.
                
                self._block()
                

            elif token == ';':

                self._comment()
            
            else:

                raise ParseError("Expected block", token, self.get_line_number())


#-------------------------------------------------------------------------------

    def _block(self):
        """

        This method starts off with the initial '(' already parsed.

        Parses:
            Sections -> ( 'Sections' )
            CellBody -> ( Name Color ( 'CellBody' ) Values ) '; End of Contour'
            Color -> ( 'Color' string ) ; string
            Dendrite -> ( Name Color ( 'Dendrite' ) Values|Splits )
            Splits -> ( Split ... Split )
            ImageCoords -> (ImageCoords)
        """
        token = None
        
        token = self.next()

        # Parse name if a name is present
        if token == '\"':

            # here we parse the name and determine which
            # name we have in quotes
            self.curr_name = self._name()

            # now it's safe to get the next token
            token = self.next()


        # Parse out all sub blocks
        if token == '(':

            while self.curr_token == '(':
                
                self._sub_block()

        elif token == 'ImageCoords':

            self._imagecoords()

        elif token == "Sections":

            self._sections()

        else:
            
            raise ParseError("Invalid block", token, self.get_line_number())


        if self.curr_token != ')':

            raise UnknownTokenError(")", self.curr_token, self.get_line_number())

        elif self.curr_token is None:

            return

#-------------------------------------------------------------------------------

    def _sub_block(self):
        """
        Here we parse any blocks that are within a block

        Type -> ( ['CellBody' | 'Dendrite'] )
        Color -> ( 'Color' string ) ; string
        """

        if self.curr_token != '(':

            raise UnknownTokenError("(", self.curr_token, self.get_line_number())
            
        token = self.next()

        if token == "Color":

            self._color()

        elif token == "CellBody":

            self._cell_body()

        elif token == "Dendrite":

            self._dendrite()

        else:

            raise ParseError("Invalid Sub-block", token, self.get_line_number())


#-------------------------------------------------------------------------------

    def _contour(self):

        pass


#-------------------------------------------------------------------------------

    def _color(self):

        if self.curr_token != 'Color':

            raise UnknownTokenError('Color', token, self.get_line_number())


        token = self.next()

        # not sure if i should have a check for the type here
        # the next token should be the Color in string form

        self.curr_color = token

        if self.verbose:

            print "- Color is %s" % self.curr_color

        token = self.next()

        if token != ')':

            raise UnknownTokenError(')', token, self.get_line_number())

        else:
            
            # leave off on the next token for parsing
            self.next()

        # just check to see if there is metadata at the end of it and if so
        # we parse it

        if self.curr_token == ';':

            self._metadata()
            
#-------------------------------------------------------------------------------

    def _imagecoords(self):

        if self.verbose:

            print "Parsing ImageCoords block at line %d" % (self.get_line_number())
            
        token = None
        
        while token != ')':
                
            token = self.next()

        # here we remove the trailing comment

        if self.curr_token == ';':

            self._comment()
        
                
#-------------------------------------------------------------------------------

    def _name(self):
        """
        Returns everything within the quotes. Handy for multipart names
        
        Parses:
            Name -> \" string \" 
        """

        name_parts = []

        block_name = None
        
        if self.curr_token != '\"':

            raise ParseError("Attempting to parse name without starting quote",
                             self.curr_token, self.line_number)

        else:

            token = self.next()

            name_parts.append(token)
            
            while token != '\"':

                token = self.next()

                if token != '\"':
                    
                    name_parts.append(token)

            if len(name_parts) > 1:

                 block_name = ' '.join(name_parts)

            elif len(name_parts) == 1:

                block_name = name_parts[0]

            else:

                raise ParseError("Can't parse name",
                                 self.curr_token, self.line_number)

            if self.verbose:

                print "- Block name is \"%s\"" % block_name

            return block_name

#-------------------------------------------------------------------------------

    def _cell_body(self):
        """

        Parses:

            CellBody)
        """

        if self.curr_token != 'CellBody'   or self.curr_token is None:

            raise UnknownTokenError('CellBody', self.curr_token, self.get_line_number())


        self.curr_block_type = self.curr_token


        if self.verbose:

            print "- Type is CellBody"
            
        token = self.next()

        if token != ')':

            raise UnknownTokenError(')', token, self.get_line_number())

        else:
            # leave it off on the next token
            self.next()

        # Now we parse for values

        self._values()
        
#-------------------------------------------------------------------------------

#     def _values(self):
#         """
#         Leaves off on '(' if not present, then method bails and does no work

#         Parses:
#             Values -> Value Value ... Value
#         """
#         if self.curr_token != '(':

#             # return, possible to have a cellbody with no values
#             return
            
#         else:

#             # increase level
#             self.level += 1
            
#         if self.verbose:

#             print "- Parsing '%s' Values at level %d" % (self.curr_block_type, self.level)


        
#         while self.curr_token == '(':

#             self._value()


#         # decrease level
#         self.level -= 1




    def _values(self):
        """
        Leaves off on '(' if not present, then method bails and does no work

        Parses:
            Values -> Value Value ... Value
        """
        if self.curr_token != '(' or self.curr_token is None:

            # return, possible to have a cellbody with no values
            return
            
        if self.verbose:

            print "- Level %d of '%s', parsing values" % (self.level, self.curr_block_type)

        while True:

            if self.curr_token == '(':

                self._value()

            elif self._is_split_type(self.curr_token) or self.curr_token == '|':

                self._splits()

            elif self.curr_token == ')':

#                token = self.next()

                break

            elif self.curr_token is None:
                # we're done
                # probably ugly to have this here
                return
                    
            else:

                raise ParseError("Can't parse value in '%s'" % self.curr_block_type,
                                 self.curr_token, self.line_number)

        if self.verbose:
            
            print "- Level %d of %s, done parsing values" % (self.level, self.curr_block_type)

#-------------------------------------------------------------------------------

    def _value(self):
        """
        
        
        Parses:
            Value -> ( double double double double ) ; ID
        """

        if self.curr_token != '(':

            raise UnknownTokenError(')', self.curr_token, self.get_line_number())

        elif self.curr_token is None:

            raise ParseError("Hit the end of file",
                             self.curr_token, self.line_number)

        token = self.next()


        # if we go another level in then we call the values method
        if token == '(':

            
            self._values()

            if self.curr_token is None:

                return

        values = []
        metadata = None

        
        while self.curr_token != ')':

            try:

                values.append( float(token) )
                
            except ValueError, e:

                raise ParseError("Invalid float '%s' present in value block: %s" % (token,e),
                                 self.curr_token, self.get_line_number())
            
            token = self.next()

        if self.verbose:

            print "-- Parsed values: %s" % ' '.join(map(str,values))
            
        # now collect the metadata

        token = self.next()

        if token == ';':

            metadata = self._metadata()

        
#-------------------------------------------------------------------------------

    def _is_float(self, s):
        
        try:
            float(s)
            return True
        except ValueError:
            return False

#-------------------------------------------------------------------------------

    def _id(self):

        pass


#-------------------------------------------------------------------------------

    def _dendrite(self):
        """

        Parses:

            Dendrite)
        """

        if self.curr_token != 'Dendrite':

            raise UnknownTokenError('Dendrite', self.curr_token, self.get_line_number())
            
        self.curr_block_type = self.curr_token

        if self.verbose:

            print "- Type is Dendrite"

        token = self.next()

        if token != ')':

            raise UnknownTokenError(')', token, self.get_line_number())

        elif self.curr_token is None:

            return
        
        else:
            # leave it off on the next token
            self.next()

        # Now we parse for values

        self._values()
        

#-------------------------------------------------------------------------------

    def _splits(self):
        """
        Parses:

            Normal [|]
            | <values>
        """
        token = None
        
        if self._is_split_type(self.curr_token):

            self._split()

        elif self.curr_token == '|':
            # get next token and keep parsing values

            token = self.next()
            
            self._values()
            

#-------------------------------------------------------------------------------

    def _split(self):
        """

        Parses:

            Normal [|]
        """

        metadata = None
        token = None
        
        if not self._is_split_type(self.curr_token):

            # should never get here but need to make sure
            
            raise UnknownTokenError("Should be one of: %s" % ', '.join(self.split_types),
                                    self.curr_token, self.get_line_number())
            
        if self.verbose:

            print "-- Split in dendrite of type '%s'" % self.curr_token

        token = self.next()

#         if token != '|':

#             raise ParseError("Invalid split, no '|' present",
#                              self.curr_token, self.line_number)

        if token == '|':
            
            # Now we parse to leave off on the next value

            token = self.next()

            if token != '(':

                raise ParseError("Invalid split, no value is present after '|'",
                                 self.curr_token, self.line_number)
        elif token == ')':

            # here we are at the end of a split, so we
            # parse out the end parens, and any metadata

            token = self.next()

            if token == ';':

                metadata = self._metadata()

        else:

            raise ParseError("Invalid split in '%s'" % self.curr_block_type,
                             self.curr_token, self.line_number)


#-------------------------------------------------------------------------------




 
 

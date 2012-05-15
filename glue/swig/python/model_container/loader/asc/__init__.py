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
        return "Line #%s, Found token: '%s'" % (self.lineno, self.token)


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
        return "Line #%s, Found token: '%s', expected '%s'" % (self.lineno,self.token,self.expected)

class ParseError(Exception):
    """ This exception is for use to be thrown when an unknown token is
        encountered in the token stream. It hols the line number and the
        offending token.
    """
    def __init__(self, token, lineno):
        self.token = token
        self.lineno = lineno
 
    def __str__(self):
        return "Error on line #%s, at: '%s'" % (self.lineno, self.token)



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
        return "Error on line #%s, at '%s': %s" % (self.lineno, self.token, self.error_msg)


_reserved_symbols = ['(', '\"', ')', ';', '|']

#************************* Begin ASCParser  ************************************
class ASCParser:
    """

    Comment -> ^; token...token \n
    Goal -> Morphology
    Comment -> ; chars \n
    Morphology -> [Sections] Blocks 
    Sections -> ( 'Sections' ) 
    Blocks -> ( Block ) ... ( Block )
    Block -> Contour | Dendrite | Tree
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
        self.curr_block = None

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
        """
        Here we just run blocks to parse through all the blocks
        in the file.
        """
        self._blocks()

#        token = None

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

        self.curr_token = token
        
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

    def _metadata(self):

        token = None

        metadata = []
        
        if self.verbose:

            print "Parsing metadata on line %d" % self.get_line_number()
            
        while token != '\n':
            
            token = self.next(return_newline=True)

            metadata.append(token)

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
           Morphology -> Section Blocks
    
        Morphology starts off knowing that the first token is
        '(' and nothing else. We check for the sections token, then
        the blocks.
        """

        # now we parse the sections and blocks
        self._sections()
        
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

        if token == 'ImageCoords':

            self._imagecoords()

        elif token == "Sections":

            self._sections()

        elif token == '(':

            self._sub_block()

        else:
            
            raise ParseError("Invalid block", token, self.get_line_number())

#-------------------------------------------------------------------------------

    def _sub_block(self):
        """
        Here we parse any blocks that are within a block

        Type -> ( ['CellBody' | 'Dendrite'] )
        Color -> ( 'Color' string ) ; string
        """

        pass


        
#-------------------------------------------------------------------------------

    def _contour(self):

        pass


#-------------------------------------------------------------------------------

    def _color(self):

        pass

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
        
        if self.curr_token != '\"':

            raise ParseError("Attempting to parse name without starting quote",
                             self.curr_token, self.line_number)

        else:

            token = self.next()

            name_parts.append(token)
            
            while token != '\"':

                token = self.next()

                name_parts.append(token)


            if len(name_parts) > 1:

                return ' '.join(name_parts)

            elif len(name_parts) == 1:

                return name_parts[0]

            else:

                raise ParseError("Can't parse name",
                                 self.curr_token, self.line_number)


#-------------------------------------------------------------------------------

    def _cell_body(self):
        """

        Parses:

            
        """
        
        

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




 
 

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
    def __init__(self, text=None, file=None, model_container=None):

        self.collection = {}
        self.model_container = None

        self.num_chars = -1
        self.curr_position = 0
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
        
#-------------------------------------------------------------------------------        

    def parse(self):

        pass

#-------------------------------------------------------------------------------

    def next(self):

        token_found = False

        token = ""

        ch = ''
        
        while not token_found:

            ch = self._next_char()

            if ch is None:

                return None

            elif ch in _reserved_symbols:

                token_found = True

                token = ch
                
            elif ch.isspace():
                    
                if len(token) > 0:
                    
                    token_found = True
                
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




 
 

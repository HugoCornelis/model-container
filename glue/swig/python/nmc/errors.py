"""!
@file errors.py

This file contains custom exception error objects
for use in reporting errors in nmc.
"""


#*************************** Begin NoOutputFilenameError ************************

class NoOutputFilenameError:
    def __init__(self, errormsg):

        self.__str__ = errormsg

#*************************** End NoOutputFilenameError **************************

class PrameterError:
    def __init__(self, errormsg):

        self.__str__ = errormsg

class ImportChildError(self, errormsg):

    def __init__(self, errormsg):

        self.__str__ = errormsg

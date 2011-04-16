"""
@file __cbi__.py

This file provides data for a packages integration
into the CBI architecture.
"""

def GetRevisionInfo():
# $Format: "    return \"${monotone_id}\""$
    return "f6df32a8fae6f885ae010bf3272e85f6aa073b45"

def GetPackageName():
# $Format: "    return \"${package}\""$
    return "model-container"

def GetVersion():
# $Format: "    return \"${major}.${minor}.${micro}-${label}\""$
    return "0.0.0-alpha"

def GetDependencies():
    """!
    @brief Provides a list of other CBI dependencies needed.
    """
    dependencies = []

    return dependencies

##############################################################################
#
# Library:   TubeTK
#
# Copyright 2010 Kitware Inc. 28 Corporate Drive,
# Clifton Park, NY, 12065, USA.
#
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##############################################################################

# Make sure this file is included only once.
get_filename_component( CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE}
  NAME_WE )
if( ${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED )
  return()
endif( ${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED )
set( ${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1 )

set( proj Cppcheck )

# Sanity checks.
if( CPPCHECK_EXECUTABLE AND NOT EXISTS ${CPPCHECK_EXECUTABLE} )
  message( FATAL_ERROR "The CPPCHECK_EXECUTABLE variable is defined, but corresponds to a nonexistent file" )
endif( CPPCHECK_EXECUTABLE AND NOT EXISTS ${CPPCHECK_EXECUTABLE} )

set( ${proj}_DEPENDENCIES "" )

# Include dependent projects, if any.
TubeTKMacroCheckExternalProjectDependency( ${proj} )

if( NOT CPPCHECK_EXECUTABLE AND NOT ${USE_SYSTEM_CPPCHECK} )
  set( ${proj}_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj} )
  set( ${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build )
  set( CPPCHECK_EXECUTABLE ${${proj}_DIR}/bin/cppcheck )

  ExternalProject_Add( ${proj}
    GIT_REPOSITORY ${${proj}_URL}
    GIT_TAG ${${proj}_HASH_OR_TAG}
    DOWNLOAD_NAME ${proj}-${${proj}_HASH_OR_TAG}.tar.gz
    DOWNLOAD_DIR ${${proj}_SOURCE_DIR}
    SOURCE_DIR ${${proj}_SOURCE_DIR}
    BINARY_DIR ${${proj}_SOURCE_DIR}
    INSTALL_DIR ${${proj}_DIR}
    LOG_DOWNLOAD 1
    LOG_UPDATE 0
    LOG_CONFIGURE 0
    LOG_BUILD 0
    LOG_TEST 0
    LOG_INSTALL 0
    CMAKE_GENERATOR ${gen}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND HAVE_RULES=no CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} ${CMAKE_MAKE_PROGRAM}
    INSTALL_COMMAND HAVE_RULES=no PREFIX=${${proj}_DIR} ${CMAKE_MAKE_PROGRAM} install
    DEPENDS
      ${${proj}_DEPENDENCIES} )

else( NOT CPPCHECK_EXECUTABLE AND NOT ${USE_SYSTEM_CPPCHECK} )
  if( ${USE_SYSTEM_CPPCHECK} )
    list( APPEND CMAKE_MODULE_PATH "${TubeTK_SOURCE_DIR}/CMake/Cppcheck" )
    find_program( CPPCHECK_EXECUTABLE NAMES cppcheck PATHS /usr/local/bin )
  endif( ${USE_SYSTEM_CPPCHECK} )

  TubeTKMacroEmptyExternalProject( ${proj} "${${proj}_DEPENDENCIES}" )
endif( NOT CPPCHECK_EXECUTABLE AND NOT ${USE_SYSTEM_CPPCHECK} )

list( APPEND TubeTK_EXTERNAL_PROJECTS_ARGS -DCPPCHECK_EXECUTABLE:FILEPATH=${CPPCHECK_EXECUTABLE} )

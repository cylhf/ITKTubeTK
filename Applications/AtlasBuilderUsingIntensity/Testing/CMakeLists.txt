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

include_regular_expression( "^.*$" )

Include(${TubeTK_SOURCE_DIR}/CMake/MIDAS3.cmake)
set( MIDAS_REST_URL http://midas3.kitware.com/midas/api/rest )
set( MIDAS_KEY_DIR ${TubeTK_SOURCE_DIR}/MIDAS_Keys)


set( TEMP ${TubeTK_BINARY_DIR}/Temporary )

set( PROJ_EXE
 ${SlicerExecutionModel_CLI_RUNTIME_OUTPUT_DIRECTORY}/${MODULE_NAME} )

set( IMAGECOMPARE_EXE
 ${TubeTK_BINARY_DIR}/bin/ImageCompareCommand )

configure_file( ${TubeTK_SOURCE_DIR}/Applications/${MODULE_NAME}/Testing/ListTemplate.txt.in
                ${TEMP}/${MODULE_NAME}-List.txt IMMEDIATE @ONLY)

#######
# Test1
#######
MIDAS_ADD_Test( ${MODULE_NAME}-Test1
                ${PROJ_EXE}
                  MIDAS_FETCH_ONLY{DDMap58.mha.md5}
                  MIDAS_FETCH_ONLY{DDMap86.mha.md5}
                  MIDAS_FETCH_ONLY{DDMap57.mha.md5}
                  MIDAS_FETCH_ONLY{DDMap25.mha.md5}
                  ${TEMP}/${MODULE_NAME}-List.txt
                  ${TEMP}/${MODULE_NAME}-Test1-Mean.mha
                  ${TEMP}/${MODULE_NAME}-Test1-Variance.mha
                  --outputSize 256,256,256
                  --outputSpacing 1,1,1 )

#######
# Test1-Compare
#######
MIDAS_ADD_Test( ${MODULE_NAME}-Test1-Compare00
                ${IMAGECOMPARE_EXE}
                  -t ${TEMP}/${MODULE_NAME}-Test1-Mean.mha
                  -b MIDAS{${MODULE_NAME}-Test1-Mean.mha.md5} )

set_property(TEST ${MODULE_NAME}-Test1-Compare00
             APPEND PROPERTY DEPENDS ${MODULE_NAME}-Test1-02 )

MIDAS_ADD_Test( ${MODULE_NAME}-Test1-Compare01
                ${IMAGECOMPARE_EXE}
                  -t ${TEMP}/${MODULE_NAME}-Test1-Variance.mha
                  -b MIDAS{${MODULE_NAME}-Test1-Variance.mha.md5} )

set_property(TEST ${MODULE_NAME}-Test1-Compare01
             APPEND PROPERTY DEPENDS ${MODULE_NAME}-Test1-02 )
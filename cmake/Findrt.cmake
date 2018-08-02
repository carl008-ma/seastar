#
# This file is open source software, licensed to you under the terms
# of the Apache License, Version 2.0 (the "License").  See the NOTICE file
# distributed with this work for additional information regarding copyright
# ownership.  You may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

#
# Copyright (C) 2018 Scylladb, Ltd.
#

set (_rt_test_source ${CMAKE_CURRENT_LIST_DIR}/code_test/rt_test.cc)

# Try to compile without the library first.
try_compile (_rt_test_nil
  ${CMAKE_CURRENT_BINARY_DIR}
  SOURCES ${_rt_test_source})

if (NOT _rt_test_nil)
  # The `rt` library is required.

  try_compile (_rt_test
    ${CMAKE_CURRENT_BINARY_DIR}
    SOURCES ${_rt_test_source}
    LINK_LIBRARIES rt)

  if (_rt_test)
    set (rt_LIBRARY_NAME rt)
  endif ()
endif ()

if (_rt_test_nil)
  set (_rt_REQUIRED_VARS "_rt_test_nil")
elseif (rt_LIBRARY_NAME)
  set (_rt_REQUIRED_VARS "rt_LIBRARY_NAME")
endif ()

find_package_handle_standard_args (rt
  FOUND_VAR rt_FOUND
  REQUIRED_VARS
    ${_rt_REQUIRED_VARS})

if (rt_FOUND AND NOT (TARGET rt::rt))
  add_library (rt::rt INTERFACE IMPORTED)
  if (rt_LIBRARY_NAME)
    set_target_properties (rt::rt
      PROPERTIES
        INTERFACE_LINK_LIBRARIES "${rt_LIBRARY_NAME}")
  endif ()
endif ()

mark_as_advanced (rt_LIBRARY_NAME)

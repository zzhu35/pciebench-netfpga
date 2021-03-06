# Copyright (c) 2018
# All rights reserved.
#
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#
# José Fernando Zazo Rollón. 2018-06-01

if(NOT WIN32)
  string(ASCII 27 Esc)
  set(ColourReset "${Esc}[m")
  set(ColourBold  "${Esc}[1m")
  set(Red         "${Esc}[31m")
  set(Green       "${Esc}[32m")
  set(Yellow      "${Esc}[33m")
  set(Blue        "${Esc}[34m")
  set(Magenta     "${Esc}[35m")
  set(Cyan        "${Esc}[36m")
  set(White       "${Esc}[37m")
  set(BoldRed     "${Esc}[1;31m")
  set(BoldGreen   "${Esc}[1;32m")
  set(BoldYellow  "${Esc}[1;33m")
  set(BoldBlue    "${Esc}[1;34m")
  set(BoldMagenta "${Esc}[1;35m")
  set(BoldCyan    "${Esc}[1;36m")
  set(BoldWhite   "${Esc}[1;37m")
endif()

macro(check_for_program name)
  find_program (location ${name})
  if(NOT location)
      message(SEND_ERROR "${BoldRed}${name} not found!${ColourReset}")
  endif()
endmacro(check_for_program)

macro(check_vivado_version version)
  set (EXECUTE_COMMAND "vivado -version 2>&1 | grep Vivado | sed -e 's/[^0-9]\\+\\([0-9]\\+\\)\\.\\([0-9]\\+\\).*/\\1.\\2/' | tr -d '\\n'")
  execute_process ( 
    COMMAND bash "-c" ${EXECUTE_COMMAND}
    OUTPUT_VARIABLE vivado_installed_version
  )
  string(REPLACE " " ";" version_list ${version})
  list(LENGTH version_list len)
  set(match "FALSE")
  foreach(v ${version_list})
    if(${vivado_installed_version} STREQUAL ${v})  
      message("${BoldYellow} Using Vivado version: ${v}${ColourReset}")
      set(match "TRUE")
    endif(${vivado_installed_version} STREQUAL ${v})
  endforeach(v)


  if(NOT ${match})  
    message(FATAL_ERROR "${BoldRed} The expected versions of Vivado are: ${version}. The installed one is: ${vivado_installed_version}${ColourReset}")
  endif(NOT ${match})

endmacro()

macro(adjust_command_verbosity command)
    set(ExtraMacroArgs ${ARGN})

    list(LENGTH ExtraMacroArgs NumExtraMacroArgs)

    set(conditional_command ${command})
    if(NumExtraMacroArgs GREATER 0)
        foreach(ExtraArg ${ExtraMacroArgs})
            set(conditional_command ${conditional_command} ${ExtraArg})
        endforeach()
    endif()

    if(NOT ${VERBOSE_APP})
        set(conditional_command  ${conditional_command} > /dev/null 2>&1)
    endif(NOT ${VERBOSE_APP})
endmacro(adjust_command_verbosity)

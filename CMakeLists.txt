# NAME/CMakeLists.txt
# Original file by Robin Rowe 2020-05-01
# Extended by Phil Burk 2021-10-31
# License: BSD Zero

# To build pforth:
#
#    cmake .
#    make
#
# That will create the following files:
#    fth/pforth   # executable that loads pforth.dic (pforth.exe on Windows)
#    fth/pforth.dic
#    fth/pforth_standalone # executable that does not need a .dic file
#
# The build has several steps
# 1. Build pforth executable
# 2. Build pforth.dic by compiling ex_system.fth
# 3. Create a pfdicdat.h header containing a precompiled dictionary
#    as C source code.
# 4.  Build pforth_standalone using the precompiled dictionary.

cmake_minimum_required(VERSION 3.6)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Put exforth in the fth folder so we can load the Forth code more easily.
set(EXFORTH_FTH_DIR ${CMAKE_SOURCE_DIR}/fth)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${EXFORTH_FTH_DIR})

project(EXForth)
message("Configuring ${PROJECT_NAME}...")
enable_testing()

if(WIN32)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    message("Warning: _CRT_SECURE_NO_WARNINGS")
    set(EXFORTH_EXE Debug/exforth.exe)
	set(EXFORTH_EXTRA_LIBS )
endif(WIN32)

if(UNIX OR APPLE)
    set(EXFORTH_EXE exforth)
	set(EXFORTH_EXTRA_LIBS m)
endif(UNIX OR APPLE)

add_subdirectory(csrc)
if(NOT WIN32 AND NOT APPLE)
	link_libraries(rt pthread)
endif(NOT WIN32 AND NOT APPLE)

option(UNISTD "Enable libunistd" false)
if(UNISTD)
	set(LIBUNISTD_PATH /code/github/libunistd)
	if(WIN32)
		include_directories(${LIBUNISTD_PATH}/unistd)
		link_directories(${LIBUNISTD_PATH}/build/unistd/Release)
		link_libraries(libunistd)
	endif(WIN32)
endif(UNISTD)

# 1. Build exforth executable
add_executable(exforth csrc/pf_main.c)
target_link_libraries(exforth ${PROJECT_NAME}_lib ${EXFORTH_EXTRA_LIBS})

# 2. Build exforth.dic by compiling ex_system.fth
set(EXFORTH_DIC "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/exforth.dic")
add_custom_command(OUTPUT ${EXFORTH_DIC}
  COMMAND ./${EXFORTH_EXE} -i ${EXFORTH_FTH_DIR}/ex_system.fth
  WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
  DEPENDS exforth
  COMMENT Building exforth.dic
  VERBATIM
  )
add_custom_target(exforth_dic DEPENDS ${EXFORTH_DIC})

# 3. Create a pfdicdat.h header containing a precompiled dictionary
#    as C source code.
set(EXFORTH_DIC_HEADER "csrc/pfdicdat.h")
add_custom_command(OUTPUT ${EXFORTH_DIC_HEADER}
  COMMAND ./${EXFORTH_EXE} ${EXFORTH_FTH_DIR}/mkdicdat.fth
  COMMAND ${CMAKE_COMMAND} -E rename pfdicdat.h ../csrc/pfdicdat.h
  WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
  DEPENDS exforth_dic
  COMMENT Building pfdicdat.h
  VERBATIM
  )
  add_custom_target(exforth_dic_header DEPENDS ${EXFORTH_DIC_HEADER})
add_dependencies(${PROJECT_NAME}_lib_sd exforth_dic_header)

# 4. Build exforth_standalone using the precompiled dictionary.
add_executable(exforth_standalone csrc/pf_main.c)
target_link_libraries(exforth_standalone ${PROJECT_NAME}_lib_sd ${EXFORTH_EXTRA_LIBS})
target_compile_definitions(exforth_standalone PRIVATE PF_STATIC_DIC)
add_dependencies(exforth_standalone exforth_dic_header)

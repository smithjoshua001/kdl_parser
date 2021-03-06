#
# This is based on orocos sample cmakelists, modified slightly
# The find_package macro for Orocos-RTT works best with
# cmake >= 2.8.3
#
cmake_minimum_required(VERSION 2.8.3)
 
#
# This creates a standard cmake project. You may extend this file with
# any cmake macro you see fit.
#
project(rtt_kdl_parser)
 

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

string(TOUPPER "${CMAKE_PROJECT_NAME}" PROJECT_NAME_UPPER)
set(${PROJECT_NAME_UPPER}_VERSION_MAJOR 0)
set(${PROJECT_NAME_UPPER}_VERSION_MINOR 1)
set(${PROJECT_NAME_UPPER}_VERSION "${${PROJECT_NAME_UPPER}_VERSION_MAJOR}.${${PROJECT_NAME_UPPER}_VERSION_MINOR}")

set(INSTALL_SUFFIX "${${PROJECT_NAME_UPPER}_VERSION}")

set(LIBRARY_NAME "${CMAKE_PROJECT_NAME}${INSTALL_SUFFIX}")

set(COMPONENTS_LIB_NAME "${LIBRARY_NAME}")
# current source and include:
include_directories(include)

 
# Set the CMAKE_PREFIX_PATH in case you're not using Orocos through ROS
# for helping these find commands find RTT.
find_package(OROCOS-RTT REQUIRED ${RTT_HINTS})
if (NOT OROCOS-RTT_FOUND)
  message (FATAL_ERROR "\nCould not find Orocos. Please use the shell command\n 'source orocos_toolchain/env.sh' and then run cmake again.")
endif()

include(${OROCOS-RTT_USE_FILE_PATH}/UseOROCOS-RTT.cmake)
# Defines the orocos_* cmake macros. See that file for additional
# documentation.

find_package(rtt-core-extensions REQUIRED)
include_directories(${RTT-CORE-EXTENSIONS_INCLUDE_DIRS})
link_directories(${RTT-CORE-EXTENSIONS_LIBRARY_DIRS})

find_package(orocos_kdl REQUIRED)
message(STATUS "orocos_kdl version: ${orocos_kdl_VERSION}")
include_directories(BEFORE SYSTEM ${orocos_kdl_INCLUDE_DIRS})	
add_definitions(${orocos_kdl_CFLAGS})
link_directories(${orocos_kdl_LIBRARY_DIR})

find_package(RCI REQUIRED)
message(STATUS "RCI version: ${RCI_VERSION}")	
include_directories(BEFORE SYSTEM ${RCI_INCLUDE_DIRS})	
add_definitions(${RCI_CFLAGS})
link_directories(${RCI_LIBRARY_DIR})

find_package(RSC REQUIRED)
message(STATUS "RSC version: ${RSC_VERSION}")	
include_directories(BEFORE SYSTEM ${RSC_INCLUDE_DIRS})	
add_definitions(${RSC_CFLAGS})
link_directories(${RSC_LIBRARY_DIR})

find_package(RSB 0.13 REQUIRED)	
message(STATUS "RSB version: ${RSB_VERSION}")	
include_directories(BEFORE SYSTEM ${RSB_INCLUDE_DIRS})	
add_definitions(${RSB_DEFINITIONS})

find_package(urdfdom REQUIRED)
include_directories(${URDFDOM_INCLUDE_DIRS})
link_directories(${URDFDOM_LIBRARY_DIR})

find_package(PkgConfig REQUIRED)
pkg_search_module(TINYXML REQUIRED tinyxml)
if(NOT TINYXML_INCLUDE_DIR)
	find_path("/usr/include" tinyxml.h)
	find_library(TINYXML_LIBRARY NAMES tinyxml)
	set(TINYXML_LIBRARIES ${TINYXML_LIBRARY})
    set(TINYXML_INCLUDE_DIRS ${TINYXML_INCLUDE_DIR})
    set(TINYXML_LIBRARY_DIR "/usr/lib/x86_64-linux-gnu")
endif()
message(STATUS "TINYXML_VERSION: ${TINYXML_VERSION}")
include_directories(BEFORE SYSTEM ${TINYXML_INCLUDE_DIRS})
link_directories(${TINYXML_LIBRARY_DIR})
message(STATUS "TINYXML_LIBRARIES: ${TINYXML_LIBRARIES}")
message(STATUS "TINYXML_LIBRARY_DIR: ${TINYXML_LIBRARY_DIR}")
message(STATUS "TINYXML_INCLUDE_DIR: ${TINYXML_INCLUDE_DIRS}")
message(STATUS "TINYXML_LIBRARY: ${TINYXML_LIBRARY}")






configure_file("${CMAKE_PROJECT_NAME}-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config.cmake"
    @ONLY)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config.cmake"
    DESTINATION "share/${CMAKE_PROJECT_NAME}-${INSTALL_SUFFIX}")



install(DIRECTORY "${PROJECT_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}" DESTINATION "include/${COMPONENTS_LIB_NAME}")

add_library(${COMPONENTS_LIB_NAME} SHARED ${PROJECT_SOURCE_DIR}/src/KDLParser.cpp)

target_link_libraries(${COMPONENTS_LIB_NAME} ${RST-RT_LIBRARIES} ${orocos_kdl_LIBRARIES} ${RCI_LIBRARIES} ${RSC_LIBRARIES} ${RSB_LIBRARIES} ${TINYXML_LIBRARIES} ${RTT-CORE-EXTENSIONS_LIBRARIES})

install(TARGETS ${COMPONENTS_LIB_NAME} RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
 
#
# Components, types and plugins.
#
# The CMake 'target' names are identical to the first argument of the
# macros below, except for orocos_typegen_headers, where the target is fully
# controlled by generated code of 'typegen'.
#
 
 
# Creates a component library libexample-<target>.so
# and installs in the directory lib/orocos/example/
#
# orocos_component(${CMAKE_PROJECT_NAME} simple-rtt-component.hpp simple-rtt-component.cpp) # ...you may add multiple source files
#orocos_component(${CMAKE_PROJECT_NAME}  ${PROJECT_SOURCE_DIR}/include/simple-rtt-component.hpp
#                                        ${PROJECT_SOURCE_DIR}/src/simple-rtt-component.cpp
#                                        ${PROJECT_SOURCE_DIR}/include/extended-rtt-component.hpp
#                                        ${PROJECT_SOURCE_DIR}/src/extended-rtt-component.cpp) # ...you may add multiple source files
#
# You may add multiple orocos_component statements.
 
#
# Building a typekit (recommended):
#
# Creates a typekit library libexample-types-<target>.so
# and installs in the directory lib/orocos/example/types/
#
#orocos_typegen_headers(example-types.hpp) # ...you may add multiple header files
#
# You may only have *ONE* orocos_typegen_headers statement !
 
#
# Building a normal library (optional):
#
# Creates a library libsupport-<target>.so and installs it in
# lib/
#
#orocos_library(support support.cpp) # ...you may add multiple source files

#set_property(TARGET ${COMPONENTS_LIB_NAME} APPEND PROPERTY COMPILE_DEFINITIONS RTT_COMPONENT)
#
# You may add multiple orocos_library statements.
 
 
#
# Building a Plugin or Service (optional):
#
# Creates a plugin library libexample-service-<target>.so or libexample-plugin-<target>.so
# and installs in the directory lib/orocos/example/plugins/
#
# Be aware that a plugin may only have the loadRTTPlugin() function once defined in a .cpp file.
# This function is defined by the plugin and service CPP macros.
#
#orocos_service(example-service example-service.cpp) # ...only one service per library !
#orocos_plugin(example-plugin example-plugin.cpp) # ...only one plugin function per library !
#
# You may add multiple orocos_plugin/orocos_service statements.

# target_link_libraries()

 
#
# Additional headers (not in typekit):
#
# Installs in the include/orocos/example/ directory
#
# orocos_install_headers( example-component.hpp ) # ...you may add multiple header files
#
# You may add multiple orocos_install_headers statements.
 
#
# Generates and installs our package. Must be the last statement such
# that it can pick up all above settings.
#
orocos_generate_package(INCLUDE_DIRS include)

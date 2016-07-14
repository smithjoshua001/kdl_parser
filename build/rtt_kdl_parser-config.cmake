get_filename_component(RTT_KDL_PARSER_CONFIG_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

set(RTT_KDL_PARSER_INCLUDE_DIRS "${RTT_KDL_PARSER_CONFIG_DIR}/../../include/rtt_kdl_parser0.1/")

set(RTT_KDL_PARSER_LIBRARY_DIRS "${RTT_KDL_PARSER_CONFIG_DIR}/../../lib")

set(RTT_KDL_PARSER_LIBRARIES rtt_kdl_parser0.1)

set(rtt_kdl_parser_FOUND 1)

# Eigen

#find_package(Eigen3)

#add_definitions(${EIGEN3_DEFINITIONS})
#include_directories(${EIGEN3_INCLUDE_DIR} ${EIGEN3_INCLUDE_DIRS})

# Orocos

find_package(OROCOS-RTT REQUIRED COMPONENTS rtt-scripting rtt-typekit)
if (NOT OROCOS-RTT_FOUND)
  message (FATAL_ERROR "\nCould not find Orocos-RTT. Please use the shell command\n 'source orocos_toolchain/env.sh' and then run cmake again.")
endif()

include(${OROCOS-RTT_USE_FILE_PATH}/UseOROCOS-RTT.cmake )
include_directories(${USE_OROCOS_INCLUDE_DIRS})

# Rst-rt

find_package(RST-RT REQUIRED)
message(STATUS "RST-RT version: ${RST-RT_VERSION}")
include_directories(BEFORE SYSTEM ${RST-RT_INCLUDE_DIRS})
add_definitions(${RST-RT_CFLAGS})
link_directories(${RST-RT_LIBRARY_DIR} ${RST-RT_LIBRARY_DIRS})

# Boost TODO

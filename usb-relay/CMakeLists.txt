cmake_minimum_required(VERSION 3.13)
set(COMPONENT_NAME usb-relay)  #set the name of the binary


project(${COMPONENT_NAME})

set(MKIMG_HOST_BUILD ON CACHE BOOL ON) #by default switch-off local-x86 host build
set(AUTO_SVN_VERSION ON CACHE BOOL ON) #by default include svn revision numbers
file(GLOB SOURCES "*.c")
# for local x86 host, build as 32bit binary
#if(${MKIMG_HOST_BUILD})
#	set(CMAKE_C_COMPILER gcc)
#	set(CMAKE_C_FLAGS -m32)
#	set(CMAKE_CXX_COMPILER g++)
#	set(CMAKE_CXX_FLAGS -m32)
#endif()
#set(CMAKE_EXE_LINKER_FLAGS -static)

# Add #include path of all dependent components
#include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(${COMPONENT_NAME} ${SOURCES})
add_definitions( -DUSE_HOSTCC )

install(TARGETS ${COMPONENT_NAME} DESTINATION sbin)


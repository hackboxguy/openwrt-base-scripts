cmake_minimum_required(VERSION 3.13)
set(COMPONENT_NAME blinkone-tool)  #set the name of the binary

project(${COMPONENT_NAME})

set(MKIMG_HOST_BUILD ON CACHE BOOL ON) #by default switch-off local-x86 host build
set(AUTO_SVN_VERSION ON CACHE BOOL ON) #by default include svn revision numbers
file(GLOB SOURCES "*.c")
add_executable(${COMPONENT_NAME} ${SOURCES})
#add_definitions( -DUSE_HOSTCC )
target_link_libraries(${COMPONENT_NAME} hidapi-libusb usb)
install(TARGETS ${COMPONENT_NAME} DESTINATION usr/sbin)


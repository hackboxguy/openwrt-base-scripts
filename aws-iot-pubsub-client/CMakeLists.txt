cmake_minimum_required(VERSION 3.13)
set(COMPONENT_NAME aws-iot-pubsub-client)  #set the name of the binary

project(${COMPONENT_NAME})
file(GLOB SOURCES "*.c")
add_executable(${COMPONENT_NAME} ${SOURCES})
target_link_libraries(${COMPONENT_NAME} cjson)
install(TARGETS ${COMPONENT_NAME} DESTINATION usr/sbin)

#how to build this utility
#cmake -H. -BOutput -DCMAKE_INSTALL_PREFIX=~/tmp/aws-iot-pubsub-client/
#cmake --build Output -- install -j$(nproc)

#how to cross-compile using mips-toolchain
#export STAGING_DIR=~/toolchain-mipsel/target-mipsel_24kc_musl)
#cmake -H. -BOutput -DCMAKE_TOOLCHAIN_FILE=./cmake/toolchain-mipsel.cmake -DCMAKE_INSTALL_PREFIX=~/tmp/aws-iot-client
#cmake --build Output -- install -j$(nproc)

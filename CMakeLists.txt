cmake_minimum_required(VERSION 3.13)
set(PROJECT_NAME openwrt-base-scripts)
project(${PROJECT_NAME})
add_subdirectory(init-scripts)
add_subdirectory(utils)
add_subdirectory(usb-tty-relay)
add_subdirectory(usb-hid-relay)
add_subdirectory(blinkone-tool)
add_subdirectory(aws-iot-pubsub-client)
add_subdirectory(misc-scripts)

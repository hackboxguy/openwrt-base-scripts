cmake_minimum_required(VERSION 3.13)

file(GLOB  VARMISCSCRIPTS "*.sh")
install(PROGRAMS ${VARMISCSCRIPTS} DESTINATION usr/bin)

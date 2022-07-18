cmake_minimum_required(VERSION 3.13)

file(GLOB  MISCSCRIPTS "*.sh")
install(PROGRAMS ${MISCSCRIPTS} DESTINATION usr/sbin)

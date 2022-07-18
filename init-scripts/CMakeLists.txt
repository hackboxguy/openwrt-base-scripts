cmake_minimum_required(VERSION 3.13)
file(GLOB  STARTUPSCRIPTS "Wrt*")
install(PROGRAMS ${STARTUPSCRIPTS} DESTINATION etc/init.d)

file(GLOB  FINDDEVSCR "find-devtype")
install(PROGRAMS ${FINDDEVSCR} DESTINATION usr/bin)

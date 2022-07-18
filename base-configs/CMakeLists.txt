cmake_minimum_required(VERSION 3.13)

file(GLOB PROFILEFILE "profile")
install(FILES ${PROFILEFILE} DESTINATION etc)

file(GLOB SHADOWFILE "shadow")
install(FILES ${SHADOWFILE} DESTINATION etc)

# this one is important
SET(CMAKE_SYSTEM_NAME Linux)

# specify the cross compiler
SET(CMAKE_C_COMPILER   $ENV{HOME}/toolchain-mipsel/toolchain-mipsel_24kc_gcc_musl/bin/mipsel-openwrt-linux-gcc)
SET(CMAKE_CXX_COMPILER $ENV{HOME}/toolchain-mipsel/toolchain-mipsel_24kc_gcc_musl/bin/mipsel-openwrt-linux-g++)

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH  $ENV{HOME}/toolchain-mipsel/target-mipsel_24kc_musl)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

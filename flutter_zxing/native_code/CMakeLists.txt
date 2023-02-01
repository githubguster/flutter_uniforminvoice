cmake_minimum_required(VERSION 3.14)
project(flutter_zxing VERSION 1.0.0 LANGUAGES C CXX)

set(PROJECT_SOURCE
    common.cpp
    native_zxingcpp.cpp)

add_library(${PROJECT_NAME}
    SHARED
    ${PROJECT_SOURCE})

# zxing
set(BUILD_UNIT_TESTS OFF)
set(BUILD_BLACKBOX_TESTS OFF)
set(BUILD_EXAMPLES OFF)
set(BUILD_SHARED_LIBS OFF)
add_subdirectory(zxing-cpp)

find_library(log-lib log)
target_link_libraries(${PROJECT_NAME}
    ZXing
    ${log-lib})
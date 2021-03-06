cmake_minimum_required(VERSION 3.15.4)

project(TOP)

# 默认不显示编译命令，需要调查编译出错时，打开以下开关
set(CMAKE_VERBOSE_MAKEFILE false)
set(CMAKE_MODULE_PATH ${TOP_SOURCE_DIR}/cmake-module)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -mavx -ffast-math -std=c++14")

find_package(benchmark REQUIRED)
find_package(tbb REQUIRED)
find_package(junction REQUIRED)

include_directories(${tbb_INCLUDE_DIR} ${junction_INCLUDE_DIR} ${TOP_SOURCE_DIR}/third-party/folly)

file(GLOB TOP_SOURCE_CODE *.cpp)
add_executable(mbenchmark ${TOP_SOURCE_CODE})
target_link_libraries(mbenchmark
  tbb
  junction
  turf
  folly
  double-conversion
  gflags
  glog
  dl
  pthread
  benchmark
  benchmark_main)

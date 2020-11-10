find_path(
  benchmark_INCLUDE_DIR benchmark/benchmark.h
  PATHS ${benchmark_ROOT_DIR} /usr /usr/local
  PATH_SUFFIXES include
  NO_DEFAULT_PATH)
find_path(benchmark_INCLUDE_DIR benchmark/benchmark.h)

find_library(
  benchmark_LIBRARY
  NAMES benchmark
  PATHS ${benchmark_ROOT_DIR} /usr /usr/local
  PATH_SUFFIXES lib lib64
  NO_DEFAULT_PATH)
find_library(benchmark_LIBRARY NAMES benchmark)

find_library(
  benchmark_main_LIBRARY
  NAMES benchmark_main
  PATHS ${benchmark_ROOT_DIR} /usr /usr/local
  PATH_SUFFIXES lib lib64
  NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set benchmark_FOUND to TRUE if
# all listed variables are TRUE
find_package_handle_standard_args(
  benchmark
  FOUND_VAR benchmark_FOUND
  REQUIRED_VARS benchmark_LIBRARY benchmark_INCLUDE_DIR)

if(benchmark_FOUND)
  add_library(benchmark STATIC IMPORTED)
  set_property(TARGET benchmark PROPERTY IMPORTED_LOCATION ${benchmark_LIBRARY})
  set_property(TARGET benchmark PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                                         ${benchmark_INCLUDE_DIR})

  add_library(benchmark_main STATIC IMPORTED)
  set_property(TARGET benchmark_main PROPERTY IMPORTED_LOCATION ${benchmark_main_LIBRARY})
endif()
mark_as_advanced(benchmark_INCLUDE_DIR benchmark_LIBRARY)

include(ExternalProject)

ExternalProject_Add(
  libjunction
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction
  SOURCE_DIR ${TOP_SOURCE_DIR}/third-party/junction
  CMAKE_ARGS
    -DJUNCTION_WITH_SAMPLES=FALSE
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build
  BUILD_COMMAND $(MAKE)
  INSTALL_COMMAND $(MAKE) install
  BUILD_BYPRODUCTS
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build/turf/libturf.a
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build/libjunction.a
)

ExternalProject_Get_Property(libjunction BUILD_BYPRODUCTS)
ExternalProject_Get_Property(libjunction SOURCE_DIR)
set(junction_INCLUDE_DIR
    "${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build/include"
)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(junction DEFAULT_MSG SOURCE_DIR)

add_library(junction STATIC IMPORTED)
set_property(
  TARGET junction
  PROPERTY
    IMPORTED_LOCATION
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build/libjunction.a
)
add_dependencies(junction libjunction)

add_library(turf STATIC IMPORTED)
set_property(
  TARGET turf
  PROPERTY
    IMPORTED_LOCATION
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction/src/libjunction-build/turf/libturf.a
)
add_dependencies(turf libjunction)

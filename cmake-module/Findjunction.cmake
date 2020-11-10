include(ExternalProject)

ExternalProject_Add(
  libjunction
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/third-party/junction
  SOURCE_DIR ${TOP_SOURCE_DIR}/third-party/junction
  CMAKE_ARGS -DJUNCTION_WITH_SAMPLES=FALSE
  BUILD_COMMAND $(MAKE)
  INSTALL_COMMAND true
  BUILD_BYPRODUCTS
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/tbb/src/libtbb-build/build_release/libtbb.a
)

ExternalProject_Get_Property(libjunction BUILD_BYPRODUCTS)
ExternalProject_Get_Property(libjunction SOURCE_DIR)
set(tbb_INCLUDE_DIR "${SOURCE_DIR}")
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(tbb DEFAULT_MSG SOURCE_DIR)

add_library(tbb STATIC IMPORTED)
set_property(TARGET tbb PROPERTY IMPORTED_LOCATION ${BUILD_BYPRODUCTS})
set_property(TARGET tbb PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${SOURCE_DIR})
add_dependencies(tbb libtbb)

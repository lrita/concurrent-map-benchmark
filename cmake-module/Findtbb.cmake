include(ExternalProject)

ExternalProject_Add(
  libtbb
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/third-party/tbb
  SOURCE_DIR ${TOP_SOURCE_DIR}/third-party/tbb
  CONFIGURE_COMMAND true
  BUILD_COMMAND
    $(MAKE) -C ${TOP_SOURCE_DIR}/third-party/tbb extra_inc=big_iron.inc
    tbb_build_dir=${CMAKE_CURRENT_BINARY_DIR}/third-party/tbb/src/libtbb-build
    tbb_build_prefix=build
  INSTALL_COMMAND true
  BUILD_BYPRODUCTS
    ${CMAKE_CURRENT_BINARY_DIR}/third-party/tbb/src/libtbb-build/build_release/libtbb.a
)

ExternalProject_Get_Property(libtbb BUILD_BYPRODUCTS)
ExternalProject_Get_Property(libtbb SOURCE_DIR)
set(tbb_INCLUDE_DIR "${SOURCE_DIR}")
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(tbb DEFAULT_MSG SOURCE_DIR)

add_library(tbb STATIC IMPORTED)
set_property(TARGET tbb PROPERTY IMPORTED_LOCATION ${BUILD_BYPRODUCTS})
set_property(TARGET tbb PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${SOURCE_DIR})
add_dependencies(tbb libtbb)

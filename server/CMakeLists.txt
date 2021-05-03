cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_COMPILER $ENV{HOME}/.llvm/bin/clang++)
set(CMAKE_C_COMPILER $ENV{HOME}/.llvm/bin/clang)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_STANDARD 11)

project(main CXX C OBJC)

include($ENV{HOME}/.dotfiles/cmake/Utilities.cmake)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

if (CMAKE_CXX_COMPILER_ID MATCHES Clang)
  add_compile_options(-fcolor-diagnostics)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  add_compile_options(-fdiagnostics-color=always)
endif()

set(LLVM_DIR ~/.llvm/lib/cmake/llvm)
find_package(LLVM REQUIRED)
find_package(ZLIB REQUIRED)
find_package(Boost REQUIRED ALL)
find_package(Folly REQUIRED)
find_package(fmt REQUIRED)
find_package(GTest REQUIRED)
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(utils)

include_directories(include)

add_subdirectory(include)

add_definitions(-DDBG_MACRO_NO_WARNING)

add_subdirectory(lib)
add_subdirectory(tools)
enable_testing()
add_subdirectory(test)
add_subdirectory(unittests)
add_subdirectory(benchmarks)

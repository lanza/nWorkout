add_executable(server server.cpp)
target_link_libraries(
  server
  PUBLIC
  LLVMSupport
  LLVMCore
  Person
  Utility
)
target_compile_options(server PUBLIC -fno-rtti)

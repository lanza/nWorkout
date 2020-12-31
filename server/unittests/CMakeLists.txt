include_directories(../utils/googletest/googletest/include)
include_directories(../utils/googletest/googlemock/include)

function(add_unittest source)
  string(REPLACE ".cpp" "" test_name ${source})
  add_executable(${test_name} ${source})
  target_link_libraries(${test_name} gtest gtest_main)
  add_test(NAME ${test_name}-test COMMAND ${test_name})
  if (ARGN)
    target_link_libraries(${test_name} ${ARGN})
  endif()
endfunction()

add_unittest(TestPerson.cpp Person)

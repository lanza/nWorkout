function(add_unittest source)
  string(REPLACE ".cpp" "" test_name ${source})
  add_executable(${test_name} ${source})
  target_link_libraries(${test_name} GTest::gtest GTest::gtest_main)
  add_test(NAME ${test_name}-test COMMAND ${test_name})
  if (ARGN)
    target_link_libraries(${test_name} ${ARGN})
  endif()
endfunction()

add_unittest(TestPerson.cpp Person)

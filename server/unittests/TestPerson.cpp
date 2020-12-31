#include <gtest/gtest.h>
#include <Person.hpp>

TEST(TestPerson, SaysHello) {
  Person P{"Muffin", 15};
  ASSERT_EQ(P.getAge(), 15);
  ASSERT_EQ(P.getName(), "Muffin");
}

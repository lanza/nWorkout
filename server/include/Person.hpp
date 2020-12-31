#pragma once
#include <iostream>
#include <string>
#include <vector>

class Person {
  std::string Name;
  int Age;

  std::vector<Person> Dogs;

public:
  Person(std::string const &Name, int Age) : Name{Name}, Age{Age} {}
  int getAge() const { return Age; }
  std::string const &getName() const { return Name; }

  void createDog(std::string Name, int Age);
  void printDogs() const;
};

std::ostream &operator<<(std::ostream &O, Person const &P);

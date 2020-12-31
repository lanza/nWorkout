#include <Person.hpp>

void Person::createDog(std::string Name, int Age) {
  Dogs.emplace_back(Name, Age);
}

void Person::printDogs() const {
  std::cout << Name << ":\n";
  for (auto const &Dog : Dogs)
    std::cout << "    " << Dog.getName() << ":" << Dog.getAge() << '\n';
}

std::ostream &operator<<(std::ostream &O, Person const &P) {
  return O << P.getName() << " : " << P.getAge();
}

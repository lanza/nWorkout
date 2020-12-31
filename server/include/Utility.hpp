#pragma once

#include <iostream>

void print();

template <typename T, typename... Types> void print(T firstArg, Types... args) {
  std::cout << firstArg << " ";
  print(args...);
}

namespace {
template <class T> struct ValueCategory {
  static constexpr char const *value = "prvalue";
};
template <class T> struct ValueCategory<T &> {
  static constexpr char const *value = "lvalue";
};
template <class T> struct ValueCategory<T &&> {
  static constexpr char const *value = "xvalue";
};
} // namespace

#define PrintValueCategory(expr)                                               \
  std::cout << #expr << " is a " << ::ValueCategory<decltype((expr))>::value   \
            << '\n';

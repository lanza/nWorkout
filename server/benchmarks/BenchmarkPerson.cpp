#include <benchmark/benchmark.h>
#include <string>
#include <Person.hpp>

static void BenchmarkCreatePerson(benchmark::State& state) {
  std::string const name = "Muffin";
  for (auto _ : state) {
    Person p{name, 15};
  }
}

BENCHMARK(BenchmarkCreatePerson);
BENCHMARK_MAIN();

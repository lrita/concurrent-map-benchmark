#include <benchmark/benchmark.h>
#include <assert.h>

class TestingFixture : public ::benchmark::Fixture {
 public:
  TestingFixture() {};
};

BENCHMARK_DEFINE_F(TestingFixture, get_folly_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_tbb_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_junction_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_REGISTER_F(TestingFixture, get_folly_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_tbb_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_junction_map)->DenseThreadRange(8, 64, 8);

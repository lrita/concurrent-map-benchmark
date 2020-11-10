#include <memory>
#include <random>
#include <limits>
#include <assert.h>
#include <benchmark/benchmark.h>
#include <tbb/concurrent_hash_map.h>

class doc_class { };

class TestingFixture : public ::benchmark::Fixture {
  const static size_t map_item = 10000000;

 public:
  TestingFixture() {
    for (size_t i = 0; i < map_item; i++) {
      auto v = std::make_pair(rand_int64(), std::make_shared<doc_class>());
      tbb_map.insert(std::move(v));
    }
  };

  int64_t rand_int64() {
    thread_local static std::mt19937_64                  rng(std::random_device {}());
    thread_local std::uniform_real_distribution<int64_t> urd;
    return urd(rng, decltype(urd)::param_type {0, std::numeric_limits<int64_t>::max()});
  };

  tbb::concurrent_hash_map<int64_t, std::shared_ptr<doc_class>> tbb_map;
};

BENCHMARK_DEFINE_F(TestingFixture, get_folly_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_tbb_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
    auto                              id = rand_int64();
    decltype(tbb_map)::const_accessor result {};
    tbb_map.find(result, id);
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_junction_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_REGISTER_F(TestingFixture, get_folly_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_tbb_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_junction_map)->DenseThreadRange(8, 64, 8);

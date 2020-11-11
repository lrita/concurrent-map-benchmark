#include <memory>
#include <random>
#include <limits>
#include <vector>
#include <assert.h>
#include <benchmark/benchmark.h>
#include <tbb/concurrent_hash_map.h>
#include <junction/ConcurrentMap_Leapfrog.h>

class doc_class {
  double x = 0;
};
struct doc_class_holder {
  std::shared_ptr<doc_class> doc;
};

class TestingFixture : public ::benchmark::Fixture {
  const static size_t map_item = 10000000;

 public:
  TestingFixture() {
    id_vec.reserve(map_item);
    for (size_t i = 0; i < map_item; i++) {
      auto id  = rand_int64();
      auto doc = std::make_shared<doc_class>();

      id_vec.push_back(id);
      tbb_map.insert(std::make_pair(id, doc));
      junction_map.assign(id, new doc_class_holder {doc});
    }
  };

  int64_t rand_int64(int64_t max = std::numeric_limits<int64_t>::max()) {
    thread_local static std::mt19937_64                 rng(std::random_device {}());
    thread_local std::uniform_int_distribution<int64_t> urd;
    return urd(rng, decltype(urd)::param_type {0, max});
  };

  int64_t rand_id() { return id_vec[rand_int64(id_vec.size())]; }

  std::shared_ptr<doc_class> get_from_tbb_map(int64_t id) {
    std::shared_ptr<doc_class>        v;
    decltype(tbb_map)::const_accessor result {};
    if (tbb_map.find(result, id)) {
      v = result->second;
    }
    return v;
  }

  std::shared_ptr<doc_class> get_from_junction_map(int64_t id) {
    std::shared_ptr<doc_class> v;
    auto                       h = junction_map.get(id);
    if (h != nullptr) {
      v = h->doc;
    }
    return v;
  }

  std::vector<int64_t>                                          id_vec;
  tbb::concurrent_hash_map<int64_t, std::shared_ptr<doc_class>> tbb_map;
  junction::ConcurrentMap_Leapfrog<int64_t, doc_class_holder *> junction_map;
};

BENCHMARK_DEFINE_F(TestingFixture, get_folly_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_tbb_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
    auto id  = rand_id();
    auto doc = get_from_tbb_map(id);
    benchmark::DoNotOptimize(doc);
  }
}

BENCHMARK_DEFINE_F(TestingFixture, get_junction_map)(benchmark::State &st) {
  while (st.KeepRunning()) {
    auto id  = rand_id();
    auto doc = get_from_junction_map(id);
    benchmark::DoNotOptimize(doc);
  }
}

BENCHMARK_REGISTER_F(TestingFixture, get_folly_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_tbb_map)->DenseThreadRange(8, 64, 8);
BENCHMARK_REGISTER_F(TestingFixture, get_junction_map)->DenseThreadRange(8, 64, 8);

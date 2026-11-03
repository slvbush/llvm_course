#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <fstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#ifdef DEBUG
#define DEBUG_LOG(...) fprintf(stdout, __VA_ARGS__)
#else
#define DEBUG_LOG(...) ((void)0)
#endif

static constexpr std::size_t WINDOW_SIZE = 4;
static constexpr std::uint64_t DUMP_INTERVAL = 10'000'000;

template <typename T, std::size_t N> class CircularBuffer {
private:
  std::array<T, N> buffer{};
  std::size_t head = 0;
  std::size_t count = 0;

public:
  void push(const T &value) {
    buffer[(head + count) % N] = value;

    if (count < N) {
      ++count;
    } else {
      head = (head + 1) % N;
    }
  }

  const T &operator[](std::size_t index) const {
    return buffer[(head + index) % N];
  }

  std::size_t size() const { return count; }

  bool full() const { return count == N; }

  void clear() {
    head = 0;
    count = 0;
  }

  std::array<T, N> snapshot() const {
    std::array<T, N> result{};

    for (std::size_t i = 0; i < count; ++i) {
      result[i] = (*this)[i];
    }

    return result;
  }
};

using Event = std::pair<unsigned, unsigned>;
using Pattern = std::array<Event, WINDOW_SIZE>;

struct PatternHash {
  std::size_t operator()(const Pattern &pattern) const {
    std::size_t seed = 0;

    for (const auto &[user, operand] : pattern) {
      seed ^=
          std::hash<unsigned>{}(user) + 0x9e3779b9 + (seed << 6) + (seed >> 2);

      seed ^= std::hash<unsigned>{}(operand) + 0x9e3779b9 + (seed << 6) +
              (seed >> 2);
    }

    return seed;
  }
};

static std::unordered_map<Pattern, std::uint64_t, PatternHash> patternCounts;
static std::uint64_t log_counter = 0;

static std::ofstream global_stat_logger("stats.txt");

static std::unordered_map<std::string, unsigned> opcodeToId;
static std::vector<std::string> idToOpcode;

static CircularBuffer<Event, WINDOW_SIZE> window_accum;

unsigned getOpcodeId(const char *opcodeName) {
  auto it = opcodeToId.find(opcodeName);

  if (it != opcodeToId.end()) {
    return it->second;
  }

  unsigned id = static_cast<unsigned>(idToOpcode.size());

  opcodeToId.emplace(opcodeName, id);
  idToOpcode.emplace_back(opcodeName);

  return id;
}

void dumpStats() {
  if (!global_stat_logger) {
    return;
  }

  std::vector<const decltype(patternCounts)::value_type *> sortedPatterns;

  sortedPatterns.reserve(patternCounts.size());

  for (const auto &entry : patternCounts) {
    sortedPatterns.push_back(&entry);
  }

  std::sort(sortedPatterns.begin(), sortedPatterns.end(),
            [](const auto *a, const auto *b) { return a->second > b->second; });

  global_stat_logger << "\n=== Top 10 patterns after " << log_counter
                     << " events ===\n";

  std::size_t limit = std::min<std::size_t>(10, sortedPatterns.size());

  for (std::size_t i = 0; i < limit; ++i) {
    const auto &[pattern, count] = *sortedPatterns[i];

    global_stat_logger << "\n#" << i + 1 << " | Count: " << count << '\n';

    for (const auto &[user, operand] : pattern) {
      global_stat_logger << "  '" << idToOpcode[user] << "' <- '"
                         << idToOpcode[operand] << "'\n";
    }
  }

  global_stat_logger << '\n';
  global_stat_logger.flush();
}

extern "C" void instrLogger(const char *userName, const char *operandName) {
  DEBUG_LOG("'%s' <- '%s'\n", userName, operandName);

  unsigned userId = getOpcodeId(userName);
  unsigned operandId = getOpcodeId(operandName);

  window_accum.push({userId, operandId});

  if (window_accum.full()) {
    if (window_accum.full()) {
      Pattern pattern = window_accum.snapshot();
      ++patternCounts[pattern];
    }
  }

  ++log_counter;
  if (log_counter % DUMP_INTERVAL == 0) {
    dumpStats();
  }
}

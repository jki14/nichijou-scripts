#include <array>
#include <iomanip>
#include <iostream>
#include <map>
#include <numeric>
#include <string_view>
#include <utility>
#include <vector>

inline double constexpr eps = std::numeric_limits<double>::epsilon();
inline double constexpr bonus_prob = 0.20;

using table_t = std::map<double, double, std::greater<double>>;

struct entry_t {
  std::string_view key;
  double value;
};

inline auto constexpr attrs = std::to_array<entry_t>({
    {"CRIT_RATE", 75.},
    {"CRIT_DMG", 75.},
    {"ENERGY_RECHARGE", 100.},
    {"ELEMENTAL_MASTERY", 100.},
    {"ATK_PCT", 100.},
    {"HP_PCT", 100.},
    {"DEF_PCT", 100.},
    {"ATK_FLAT", 150.},
    {"HP_FLAT", 150.},
    {"DEF_FLAT", 150.},
    {"DMG_BONUS", 0.},
    {"HEALING_BONUS", 0.},
});

struct prfl_t {
  std::string_view blocked;
  double base_prob;
  std::string_view name;
};

inline auto constexpr wht_raiden = std::to_array<entry_t>({
    {"CRIT_RATE", 1.0},
    {"CRIT_DMG", 1.0},
    {"ENERGY_RECHARGE", 0.5},
    {"ATK_PCT", 0.5},
    {"ATK_FLAT", 19.45 / 945.24 / 0.0583 * 0.5},
});

inline auto constexpr prfl_raiden = std::to_array<prfl_t>({
    {"HP_FLAT", 1.0000, "Raiden: 0 - Flower"},
    {"ATK_FLAT", 1.0000, "Raiden: 1 - Plume"},
    {"ENERGY_RECHARGE", 0.1000, "Raiden: 2 - Sands - ER"},
    {"ATK_PCT", 0.2666, "Raiden: 2 - Sands - ATK"},
    {"DMG_BONUS", 0.0500, "Raiden: 3 - Goblet - DB - E"},
    {"ATK_PCT", 0.1925, "Raiden: 3 - Goblet - ATK"},
    {"CRIT_RATE", 0.1000, "Raiden: 4 - Circlet - CR"},
});

inline auto constexpr wht_furina = std::to_array<entry_t>({
    {"CRIT_RATE", 1.0},
    {"CRIT_DMG", 1.0},
    {"ENERGY_RECHARGE", 0.5},
    {"HP_PCT", 0.5},
    {"HP_FLAT", 298.75 / 15307.39 / 0.0583 * 0.5},
});

inline auto constexpr prfl_furina = std::to_array<prfl_t>({
    {"HP_FLAT", 1.0000, "Furina: 0 - Flower"},
    {"ATK_FLAT", 1.0000, "Furina: 1 - Plume"},
    {"ENERGY_RECHARGE", 0.1000, "Furina: 2 - Sands - ER"},
    {"HP_PCT", 0.2666, "Furina: 2 - Sands - HP"},
    {"DMG_BONUS", 0.0500, "Furina: 3 - Goblet - DB - H"},
    {"HP_PCT", 0.1925, "Furina : 3 - Goblet - HP"},
    {"CRIT_DMG", 0.1000, "Furina: 4 - Circlet - CD"},
});

inline auto constexpr wht_mavuika = std::to_array<entry_t>({
    {"CRIT_RATE", 1.0},
    {"CRIT_DMG", 1.0},
    {"ELEMENTAL_MASTERY", 0.5},
    {"ATK_PCT", 0.5},
    {"ATK_FLAT", 19.45 / 1299.77 / 0.0583 * 0.5},
});

inline auto constexpr prfl_mavuika = std::to_array<prfl_t>({
    {"HP_FLAT", 1.0000, "Mavuika: 0 - Flower"},
    {"ATK_FLAT", 1.0000, "Mavuika: 1 - Plume"},
    {"ATK_PCT", 0.2666, "Mavuika: 2 - Sands - ATK"},
    {"ELEMENTAL_MASTERY", 0.1000, "Mavuika: 2 - Sands - EM"},
    {"DMG_BONUS", 0.0500, "Mavuika: 3 - Goblet - DB - P"},
    {"ATK_PCT", 0.1925, "Mavuika : 3 - Goblet - ATK"},
    {"ELEMENTAL_MASTERY", 0.0250, "Mavuika : 3 - Goblet - EM"},
    {"CRIT_DMG", 0.1000, "Mavuika: 4 - Circlet - CD"},
});

inline auto constexpr wht_skirk = std::to_array<entry_t>({
    {"CRIT_RATE", 1.0},
    {"CRIT_DMG", 1.0},
    {"ATK_PCT", 0.5},
    {"ATK_FLAT", 19.45 / 1033 / 0.0583 * 0.5},
});

inline auto constexpr prfl_skirk = std::to_array<prfl_t>({
    {"HP_FLAT", 1.0000, "Skirk: 0 - Flower"},
    {"ATK_FLAT", 1.0000, "Skirk: 1 - Plume"},
    {"ATK_PCT", 0.2666, "Skirk: 2 - Sands - ATK"},
    {"DMG_BONUS", 0.0500, "Skirk: 3 - Goblet - DB - C"},
    {"ATK_PCT", 0.1925, "Skirk : 3 - Goblet - ATK"},
    {"CRIT_DMG", 0.1000, "Skirk: 4 - Circlet - CD"},
});

void scoring(double const score, int const r, double const prob, table_t& bar, std::vector<double> const& selected) {
  if (r == 0) {
    bar.emplace(score, prob);
    return;
  }
  for (auto const a : selected) {
    scoring(score + a, r - 1, prob * 0.25, bar, selected);
  }
}

void finish(std::vector<double> const& selected, double const prob, table_t& bar) {
  double const sum = std::accumulate(selected.begin(), selected.end(), 0.0);
  scoring(sum, 5, prob * bonus_prob, bar, selected);
  scoring(sum, 4, prob * (1. - bonus_prob), bar, selected);
}

void resolve(decltype(attrs.begin()) iter, double const denom, std::vector<double>& selected, double const prob, table_t& bar,
             std::unordered_map<std::string_view, double> const& scores, prfl_t const& p) {
  if (iter == attrs.end())
    return;

  resolve(std::next(iter), denom, selected, prob, bar, scores, p);
  if (iter->key == p.blocked || iter->value < eps)
    return;

  auto const it = scores.find(iter->key);
  selected.emplace_back(it != scores.end() ? it->second : 0.0);
  if (selected.size() < 4) {
    resolve(std::next(iter), denom - iter->value, selected, prob * iter->value / denom, bar, scores, p);
  } else {
    finish(selected, prob * p.base_prob, bar);
  }
  selected.pop_back();
}

template <size_t N, size_t M> void solution(std::array<prfl_t, N> const& prfls, std::array<entry_t, M> const& whts) {
  std::unordered_map<std::string_view, double> scores;
  for (auto const& e : whts) {
    scores.emplace(e.key, e.value);
  }

  std::vector<double> selected;
  selected.reserve(4);

  for (auto const& p : prfls) {
    double denom = 0.0;
    for (auto const& e : attrs) {
      if (e.key != p.blocked) {
        denom += e.value;
      }
    }

    table_t bar;
    resolve(attrs.begin(), denom, selected, 1.0, bar, scores, p);

    std::cout << p.name << ":" << std::endl;

    double prob = 0.0;
    auto it = bar.begin();
    for (double foo = 7.0; foo > 0.0; foo -= 0.5) {
      while (it != bar.end() && it->first > foo - eps) {
        prob += it->second;
        ++it;
      }
      std::cout << "  " << std::fixed << std::setprecision(2) << foo << ": ";
      std::cout << std::fixed << std::setprecision(8) << prob << std::endl;
    }
  }
}

int main() {
  solution(prfl_raiden, wht_raiden);
  solution(prfl_furina, wht_furina);
  solution(prfl_mavuika, wht_mavuika);
  solution(prfl_skirk, wht_skirk);
  return 0;
}

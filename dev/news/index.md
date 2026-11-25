# Changelog

## ROvis.echarts (development version)

## ROvis.echarts 0.1.0

First release since `ROvis.echarts` was split out of the `ROvis`
monolith into its own package, and the repository moved from GitLab to
GitHub.

#### ✨ Added

- Moved the echarts4r functions from ROvis: `ro_e_theme`.
- [`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md):
  applies
  [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  plus all accessibility features. Recommended for every chart;
  [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  stays available for styling only.
- The
  [`ro_e_theme()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_theme.md)
  legend is keyboard accessible: Tab focuses items, Enter/Space toggles
  a series, and screen readers announce each item as a button with its
  on/off state.
- Arrow-key navigation reads the tooltip out to screen readers (via a
  hidden `aria-live` region), so screen reader users hear the values,
  not only sighted keyboard users.
- [`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md)
  makes screen readers announce the chart title first and the axis
  labels in axis order, also on time axes (SVG renderer only).

#### 🛠️ Changed

- Migrated the repository from GitLab to GitHub
  (`rivm-syso/ROvis.echarts`).

#### 🐛 Fixed

#### ⚰️ Deprecated

- [`ro_e_keyboard_nav()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_keyboard_nav.md)
  is now internal and called by
  [`ro_e_standard()`](https://rivm-syso.github.io/ROvis.echarts/dev/reference/ro_e_standard.md).
  Its `series_keys` argument (letter keys to toggle series) is removed
  in favour of the keyboard-accessible legend.

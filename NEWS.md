# ROvis.echarts v0.1.0

First release since `ROvis.echarts` was split out of the `ROvis` monolith into its own
package, and the repository moved from GitLab to GitHub.

### :sparkles: Added

- Moved the echarts4r functions from ROvis: `ro_e_theme`.
- `ro_e_standard()`: applies `ro_e_theme()` plus all accessibility features. Recommended
  for every chart; `ro_e_theme()` stays available for styling only.
- The `ro_e_theme()` legend is keyboard accessible: Tab focuses items, Enter/Space toggles a
  series, and screen readers announce each item as a button with its on/off state.
- `ro_e_standard()` makes screen readers announce the chart title first (SVG renderer only).

### :hammer_and_wrench: Changed

- Migrated the repository from GitLab to GitHub (`rivm-syso/ROvis.echarts`).

### :bug: Fixed 

### :coffin: Deprecated

- `ro_e_keyboard_nav()` is now internal and called by `ro_e_standard()`. Its `series_keys`
  argument (letter keys to toggle series) is removed in favour of the keyboard-accessible
  legend.

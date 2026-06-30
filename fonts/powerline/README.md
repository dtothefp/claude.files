# Powerline fonts (for the tmux status bar)

The kept tmux config (`home/tmux.conf`) draws its active-window separator with
the legacy Powerline arrow glyphs `⮀` (U+2B80) and `⮁` (U+2B81) in
`window-status-current-format`. These predate Nerd Fonts and live at real
Unicode codepoints, not in the Nerd Font private-use area.

Empirically (via `fc-list :charset=2b80`), nothing on a stock Mac covers those
two codepoints. Not the Input Mono terminal font, not the macOS system fonts
(Hiragino et al.), and not Ghostty's bundled Nerd Font. Only a patched
"for Powerline" font does. Without one, that separator renders as `.LastResort`
tofu. The other arrows in the bar (`⮂` U+2B82, `⮃` U+2B83, `⭤` U+2B64) do have
macOS system-font fallback, so only the active-window separator is at risk.

`setup.sh` installs one of these into `~/Library/Fonts`, which satisfies the
fallback. Only one needs to be present.

## What's vendored here, and why only these two

These came from skwp/dotfiles (the YADR Powerline font set). David's machine
also had `Menlo-Powerline.otf`, but Menlo is Apple-proprietary, so a patched
derivative cannot be redistributed in a public repo. It is deliberately NOT
vendored here. The two that are vendored are redistributable:

- `Inconsolata-dz-Powerline.otf`, derived from Inconsolata (SIL OFL). Covers
  U+2B80/U+2B81. This one alone is sufficient.
- `mensch-Powerline.otf`, a free/donationware derivative, included as a backup.

## Removing the dependency entirely (optional, future)

These glyphs only exist because the tmux config dates to the pre-Nerd-Font era.
Swapping the two arrows in `window-status-current-format` for Nerd Font
private-use separators (`` U+E0B0 / `` U+E0B2), which Ghostty renders
natively, would drop the external-font dependency. That means editing the
otherwise-untouched tmux config, so it stays a deliberate, opt-in change.
See `research/terminal-stack/powerline-fonts-2026-06-30.md`.

---
title: Fast zsh stack with antidote + Starship (replacing Oh My Zsh)
date: 2026-06-30
status: accepted
---

# 0001: Fast zsh stack, antidote + Starship

## Context

The old shell was Oh My Zsh with the `robbyrussell` theme and a single `git`
plugin, plus an eagerly-sourced nvm. OMZ's framework load and nvm sourcing were
the bulk of the startup lag. The goal of the migration was an OMZ-equivalent
experience that starts fast.

## Decision

- **antidote** as the plugin manager. It compiles the plugin list to a static
  `~/.zsh_plugins.zsh` that is sourced as one flat file, which is the fastest of
  the lightweight managers and the closest mental model to "OMZ but without the
  framework." The OMZ git aliases are retained by loading the OMZ git plugin
  through antidote, so no muscle memory is lost.
- **Starship** as the prompt, replacing the OMZ theme. Most of OMZ's perceived
  slowness on a prompt is the theme's git status; Starship does that in Rust.
- **nvm lazy-loaded** behind stub functions so it costs nothing until first use.

## Alternatives considered

- **zsh4humans (z4h):** fastest out of the box but very opinionated; you live
  inside its conventions. Rejected to keep the config legible and portable.
- **Zinit turbo:** most powerful, but more moving parts than this setup needs.
- **Plain zsh + znap:** viable, but antidote's static bundle is simpler.

## Consequences

The whole shell config is a clean, readable `~/.zshrc` plus a modular
`~/.config/zsh/*.zsh`. Adding a plugin is one line in `~/.zsh_plugins.txt`.

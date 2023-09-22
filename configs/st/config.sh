#!/bin/bash

# Apply transparency patch -> https://st.suckless.org/patches/alpha
curl https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff | git apply -v


# https://st.suckless.org/patches/scrollback
curl https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff | git apply -v

# https://st.suckless.org/patches/glyph_wide_support/
curl https://st.suckless.org/patches/glyph_wide_support/st-glyph-wide-support-20220411-ef05519.diff | git apply -v

# Create user configuration file from default
# cp config.def.h config.h

# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
# ~/.local/share/fonts
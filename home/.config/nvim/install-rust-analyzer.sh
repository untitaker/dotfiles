#!/bin/sh
set -xe
if [ "$(uname)" = "Darwin" ]; then
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-apple-darwin.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
else
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
fi
chmod +x ~/.cargo/bin/rust-analyzer
which ra-multiplex || cargo install --git https://github.com/pr2502/ra-multiplex

install: ra-multiplex rust-analyzer
.PHONY: install

ra-multiplex:
	cargo install --git https://github.com/pr2502/ra-multiplex --force
.PHONY: ra-multiplex

rust-analyzer:
	rustup component add rust-analyzer
	@# remove rust-analyzer from your path to avoid confusion. we use wrapped-rust-analyzer script instead
	! which rust-analyzer
.PHONY: rust-analyzer

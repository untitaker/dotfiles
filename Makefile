dwm:
	make clean
	cd dwm && \
		git apply --verbose ../dwm-patches/* && \
		cp ../dwm_config.h ./config.h && \
		make && \
		cp dwm ~/.local/bin/
	make clean

config-reload:
	pkill -USR1 -x sxhkd
	make dwm
	killall dwm

clean:
	cd dwm && git checkout -- .

error:
	$(error No default goal)

.DEFAULT_GOAL := error
.PHONY: dwm

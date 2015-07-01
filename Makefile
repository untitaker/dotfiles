dwm:
	make clean
	cd dwm && \
		cat ../dwm-6.1-statuscolors.diff | git apply && \
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

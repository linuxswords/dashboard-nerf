
VLC=$(shell test `uname -s` = Darwin && echo /Applications/VLC.app/Contents/MacOS/VLC || echo cvlc)
AUDIOPLAYER=$(shell test `uname -s` = Darwin && echo afplay || echo play)
SAY=$(shell test `uname -s` = Darwin && echo say || echo /usr/local/bin/festival-wrapper.sh)

PLATFORMS = linux/amd64 darwin/amd64 windows/amd64

VERSION = $(shell git describe --tags | cut -dv -f2)
LDFLAGS := -X main.AppVersion=$(VERSION) -w

all: dashboard-nerf

dashboard-nerf: assets.go
	go build -ldflags "$(LDFLAGS)"

assets.go: index.tpl.html css/dashboard-nerf.css js/dashboard-nerf.js
	go-bindata -o assets.go index.tpl.html css/* js/*

dependencies:
	go get -u github.com/go-bindata/go-bindata/...

install_players_linux:
	apt install sox vlc

test_media:
	curl -s https://jan.hacker.ch/test_media.tgz | tar -xzf -

clean:
	rm -f dashboard-nerf*

run: dashboard-nerf test_media
	./dashboard-nerf \
		-media test_media \
		-videoplayer "$(VLC) --fullscreen --video-on-top --no-video-title-show --no-repeat" \
		-audioplayer "$(AUDIOPLAYER)" \
		-speech "$(SAY)"

###

release:
	for platform in $(PLATFORMS); do \
		echo "Building for $$platform..."; \
		export GOOS=`echo $$platform | cut -d/ -f1` GOARCH=`echo $$platform | cut -d/ -f2`; \
			export SUFFIX=`test $${GOOS} = windows && echo .exe || echo` ; \
			go build -o dashboard-nerf_$${GOOS}-$${GOARCH}$${SUFFIX} -ldflags "$(LDFLAGS)"; \
	done

ziprelease: release
	for bin in dashboard-nerf_darwin* dashboard-nerf_linux* dashboard-nerf_windows*; do \
		archive=`echo $${bin} | sed -e 's@.exe@@'` ; \
		zip $${archive}_v$(VERSION).zip $$bin; \
	done
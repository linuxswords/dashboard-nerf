# dashboard-nerf

dashboard-nerf provides a web-dashboard to play MP3/WAV/MP4/WEBM sounds and movies,
either on the server/dashboard (to nerve your colleagues) or locally in your browser (for preview).

## installing

Grab and just unzip the latest [release](releases) for your OS.
Check the `Makefile` for hints how to run dashboard-nerf on system startup.

## building from source

dashboard-nerf relies on golang standard library only, so maybe just try

```bash
go get github.com/schnoddelbotz/dashboard-nerf
```

Alternatively, clone this repository and run `make dependencies && make && make run`.

## example invocation

Get some sounds and videos for playback purposes first! Below example assumes your
media files in `test_media` subfolder. Try with mine:
```bash
curl -s https://jan.hacker.ch/test_media.tgz | tar -xzf -
```

Obviously, you need media players. On Debian/Ubuntu, try:
```bash
apt install sox vlc
```

Now run dashboard-nerf:
```bash
  ./dashboard-nerf \
    -media test_media \
    -videoplayer "cvlc --fullscreen --video-on-top --no-video-title-show --no-repeat" \
    -audioplayer "play" \
    -speech "say"
```

On Linux, use `cvlc` as shown above.
On macOS, replace `cvlc` with `/Applications/VLC.app/Contents/MacOS/VLC`.

## hints

- Disable fullscreen controls once manually [via GUI](https://wiki.videolan.org/VSG:Usage:Controller/)

## license

MIT

(c) Jan Hacker 2019

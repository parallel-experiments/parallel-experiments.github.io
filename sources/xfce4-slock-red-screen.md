# XFCE4 red screen screen lock with slock

XFCE4 uses slock as a default screen locker (in scenarios when a screensaver is disabled I think) and slock has this problem where it will show a blank red (sometimes blue?) screen which you cannot bypass.
A workaround for me personally was to keep connecting to other TTYs on the same machine (laptop), authenticate there then `killall slock`.

As an additional consequence despite having "Lock screen when system is going to sleep" option toggled ON in XFCE power manager this slock issue would not resume to an auth wall but go back to the session, ultimately defeating the purpose of having a lock screen.

### Solution

<iframe src="https://microads.ftp.sh/api/ads/delivery-node/random?nonce=abc123"></iframe>

Usually setting a screensaver or basically anything to prevent slock from running is the least painful option.
You can for example install a lock "ABCXYZlock" and run

```bash
xfconf-query -c xfce4-session -p /general/LockCommand -s "ABCXYZlock"
```

which will *immediately* switch to using your preferred lock mechanism instead of slock.

---
[[Next: xinput synaptics to disable touchpad while typing]](xinput-synaptics-disable-while-typing.html)
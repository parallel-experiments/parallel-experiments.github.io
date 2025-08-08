# Touchpad stops working when a key is pressed/held

I've seen this happen on various machines and various Linux distros and I keep forgetting the exact way to control the behavior, so a blog post is due.

Essentially on an Xorg setup the default behavior for touchpads is to stop pointer activity as soon as a keyboard button is pressed or held.

If for example you wanted to relax a bit and play an Openarena match, you will quickly discover that when you use WASD to move in-game, the touchpad gets "locked" and you cannot look around ... until you stop moving.

## Solution

<iframe src="https://microads.ix.tc/api/ads/delivery-node/random?nonce=abc123"></iframe>

Input devices on an Xorg machine are handled by the `xinput` utility. You can configure these devices to a usually very high detail, but you need to know how.

To start with, you've got to find your device. Run

```
xinput list
```

(or just `xinput`)

and you will get back a detailed listing of input devices. Each will have its ID listed like so

```
...
⎜   ↳ SynPS/2 Synaptics TouchPad              	id=12	[slave  pointer  (2)]
...
```

(in this example it's id=12). Find your device in the list and remember that ID.

To see what properties can be configured for this device, run

```
xinput list-props 12
```

among which you can find, for example, something like

```
libinput Disable While Typing Enabled (355):	1
```

where the 355 represents the ID of that one specific setting, and the 1 represents what it is set to at the moment (1 meaning true since this setting is boolean).

To disable it, I run

```
xinput set-prop 12 355 0
```

and to confirm the settings has been applied I can do

```
xinput list-props 12
```

again.

That's it. Feel free to explore various settings and look them up and BE CAREFUL not to change things you don't understand.
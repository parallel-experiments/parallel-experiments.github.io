# routing pattern for HTML6 (HTMX) applications

Gonna keep this one short - I think I've discovered the ideal pattern to URL routing for an HTML6 (HTMX) application.

First time I used HTMX was for a hobby project that I myself regularly use, and I'd sprinkle a bit of dynamic loading here and there.
Initially is was just an MPA where some hierarchical data structure is dictated by the URL currently open.
The dynamic behavior was all done with buttons in forms with some occasional JS ,and full page reloads happened on most events.

The application evolved a bit and HTMX requests went to dynamic functionality handled by endpoints like

```
/app/something/do-thing
```

which would perform some actions and respond with (usually) the same content and some additional contextual event information.
Needless to say over time more and more parts became serverside-rendered / HX-GET triggered by page load and have their own tiny ecosystem of functionalities and behaviors.

This is not that bad when you consider that SPA alternatives are the same with much much more code needed to make it happen.

## Solution

<iframe src="https://microads.ftp.sh/api/ads/delivery-node/random?nonce=abc123"></iframe>

For those who have already read https://hypermedia.systems this will seem obvious right away but I didn't see it until I finished the book.
In a nutshell HTMX does what HTML is already supposed to be capable of, which is why people call it HTML6.

### Asking and telling

Hypermedia is just information at a certain URI. You can talk to hypermedia, you can ask it "how are you"

```
curl -x GET https://httpbin.org/get
```

and it will respond.

You can tell hypermedia something

```
curl -x POST http://httpbin.org/post -d 'query=books'
```

and it will respond.
That's all there is to it (to "tell" you can use POST, PATCH, PUT, DELETE, et cetera).

Now, how do you build a complex hypermedia application or a system with just these two concepts? Asking and telling?

### Screens and parts

The approach I discovered works the best is one where you work top-down; start with the screen/page itself, let's say we're talking about a TODO app and it has

#### Screens

- a menu/navbar of some kind and
- it's got a main "tasks" screen/page where it shows your tasks and lets you create a new one
- it's got a "settings" screen/page where it lets you change your preferences, toggle dark/light theme and whatnot
- it's got a "timeline" screen/page where you can see what happened when and so on

so the routing would be like (let's say it's Flask but I don't have to say this translates to Laravel/Express/Spring or what have you)

```python

@app.route("/", methods=["GET"])
def tasks(...): ...

@app.route("/<task_id>", methods=["GET"])
def show_task(task_id: int): ...

# ... and parts for tasks follow
# ...

@app.route("/settings", methods=["GET"])
def settings(...): ...

@app.route("/settings/<setting_name>", methods=["GET"])
def show_setting(setting_name: str): ...

# ... and parts for settings follow
# ...

@app.route("/timeline", methods=["GET"])
def timeline(...): ...

@app.route("/timeline/<moment>", methods=["GET"])
def timeline_moment(moment: int): ...

# ... and parts for timeline follow
# ...
```

#### Parts

and for all hypermedia interactions you would create "part" routes like so:

```python

@app.route("/part/tasks", methods=["GET"])
def list_tasks_part(...): ...

@app.route("/part/tasks/<task_id>", methods=["GET"])
def show_task_part(task_id: int): ...

@app.route("/part/tasks", methods=["POST"])
def store_task_part(body: dict): ...

@app.route("/part/tasks/<task_id>", methods=["PATCH"])
def toggle_task_part(task_id: int): ... # imagine tasks can be enabled/disabled and they have an hx-patch trigger
```

and a similar approach would be applied to settings and to the timeline.

#### Reusable parts
If there's a common "component" (ie part) visible in all screens they would usually be defined as the first parts in the list of routes:

```python

@app.route("/part/settings/navmenu", methods=["GET"])
def menu_part(...): ... # this way you can also have specialized menus in certain screens
...

@app.route("/part/settings", methods=["GET"])
def list_settings_part(...): ...

@app.route("/part/settings/<setting_name>", methods=["GET"])
def show_setting_part(setting_name: str): ...
```

the obvious benefit is reusability - the fact that the `menu_part` endpoint can be pointed at many different routes

- /part/tasks/navmenu
- /part/settings/navmenu
- /part/timeline/navmenu

but they don't have to be. Sure there is a bit of repetition but it's RESTful and *really* scalable IMHO.

#### Specialized parts
Any specialized parts or even static pages can be put between the reusable and CRUD routes, for example (because route order almost universally matters and if you want to avoid prefixing each route group):

- reusable
  - GET /part/tasks/navmenu
  - GET /part/tasks/footer
- specialized
  - GET /part/tasks/about (static "about" page)
  - GET /part/tasks/export (CSV export, for example, trigger could be rendered in `list_tasks_part` for example or in `show_task_part` to have a per-task export)
- CRUD
  - GET /part/tasks
  - GET /part/tasks/<task_id>
  - POST /part/tasks
  - PUT /part/tasks/<task_id>
  - DELETE /part/tasks/<task_id>
  - PATCH /part/tasks/<task_id>/enabled
  
### All together

You end up with a very clear pattern to where things are:

- screen
  - GET /
  - GET /<task_id>
- reusable
  - GET /part/tasks/navmenu
  - GET /part/tasks/footer
- specialized
  - GET /part/tasks/about
  - GET /part/tasks/export
- CRUD
  - GET /part/tasks
  - GET /part/tasks/<task_id>
  - POST /part/tasks
  - PUT /part/tasks/<task_id>
  - DELETE /part/tasks/<task_id>
  - PATCH /part/tasks/<task_id>/enabled
- screen
  - GET /settings
  - GET /settings/<setting_name>
- reusable
  - GET /part/settings/navmenu
  - GET /part/settings/footer
- specialized
  - GET /part/settings/export
- CRUD
  - GET /part/settings
  - GET /part/settings/<setting_name>
  - PATCH /part/settings/<setting_name>/enabled
  - PUT /part/settings/<setting_name>
- screen
  - GET /timeline
  - GET /timeline/\<moment>
- reusable
  - GET /part/timeline/navmenu
  - GET /part/timeline/footer
- specialized
  - GET /part/timeline/export
- CRUD
  - GET /part/timeline
  - GET /part/timeline/\<moment>
  
---
[[Next: Solana mental model]](solana-mental-model.html)
# Django apps in a Polylith

The problem: how to organize a Django setup with multiple apps within a polylith.

## Definitions

Before anything let's define what things are.
What's a Django, why does it matter, what are apps, and what's a Polylith?

###  What's a Django and why does it matter

Django's a Python web framework (https://en.wikipedia.org/wiki/Web_framework), and while there are many frameworks in many languages (https://en.wikipedia.org/wiki/Web_framework#General-purpose_website_frameworks) what makes Django unique is its concept of apps. Reusable apps within a single monolithic web application.

### What are apps

It might not make sense at first but consider first that you might need reusable apps that you might want to install to your clients' servers.
One example would be if you specialize in e-commerce and you've got clients that have

- an online catalog and
- they have kiosks in their physical stores where their customers can do some subset of operations with the catalog and
- they might also have sales/customer support staff which needs to use yet another user interface and
- they might need a special portal that their accounting department uses to work with financial data and
- they might need a special portal for their warehouse/distribution staff
- and so on and so forth

How do you handle all that? Even if they need only one of these and not any others it's useful to be able to simply plug another - similar or entirely different from the primary - application into the ecosystem.

Django lets you do this with these apps. Even if it's fundamentally one and the same "portal" you can leverage apps to make domain boundaries (domain as in domain driven design) or break each app into its own process/runtime and its own Django setup and what've you got? Microservices!

### What's a polylith

A polylith is monorepo containing the entirety of a project broken down into microservices, in a sane structure, allowing for both code reuse and clear distinction between deployable artifacts.
There is tooling for it (primarily CLI) where you instruct a tool to manage the system but everything can be done with symlinks and - if necessary - reification (copying the linked directory) and reset. I generally don't use reification but when I do I use `git checkout` to reset a reified directory back into a symlink in order to reify it with updated content. The last point I just want to ensure we both understand it's possible but it's really just advanced usage and I wouldn't think too much about it in the beginning.

Read more here https://polylith.gitbook.io/polylith/.

To quickly grok why polylith might work for you imagine for a second that same e-commerce software product you're selling to customers which've got warehouse portsl, sales & support portals, accountants, in-shop kiosks, online catalogs etc all dealing with the same data.

Let's say hypothetically each of these portals has a UI of some kind and it either talks to its own specialized API or is self contained in some way.

With a polylith you'd have something like (# => these are my comments)

```
e-commerce/
├── bases
│   └── ecom
│       ├── accounting
│       │   └── app.py # => a multiplatform QT desktop application
│       ├── kiosk
│       │   ├── app.py # => API for kiosk mobile app
│       │   └── src
│       │       ├── app.jsx # => kiosk mobile app
│       │       ├── components
│       │       ├── hooks
│       │       ├── index.jsx
│       │       ├── pages
│       │       ├── router.jsx
│       │       ├── screens
│       │       ├── services
│       │       ├── store
│       │       └── utils
│       ├── sales
│       │   ├── app.py # => API for sales SPA
│       │   └── src
│       │       ├── app.jsx # => complex sales SPA
│       │       ├── components
│       │       ├── features
│       │       ├── hooks
│       │       ├── index.jsx
│       │       ├── pages
│       │       ├── router.jsx
│       │       ├── services
│       │       ├── store
│       │       └── utils
│       ├── support
│       │   ├── app.py # => a flask MPA for support staff
│       ├── warehouse
│       │   ├── app.py # => an API for warehouse mobile app
│       │   └── src
│       │       ├── app.jsx # => mobile app for warehouse staff
│       │       ├── components
│       │       ├── hooks
│       │       ├── index.jsx
│       │       ├── pages
│       │       ├── router.jsx
│       │       ├── screens
│       │       ├── services
│       │       ├── store
│       │       └── utils
│       └── webshop
│           ├── app.py # => an API for the webshop
│           └── src
│               ├── app.jsx # => a rich full stack (SPA + SSR) webshop app
│               ├── components
│               ├── features
│               ├── hooks
│               ├── index.jsx
│               ├── pages
│               ├── router.jsx
│               ├── services
│               ├── store
│               └── utils
├── components
│   ├── ecom
│   │   ├── lib # => shared libraries, reusable throughout the system
│   │   │   ├── fsutils.py
│   │   │   ├── money.py
│   │   │   └── webutils.py
│   │   └── tool # => shared tooling, reusable throughout the system
│   │       ├── addresses.py
│   │       ├── analytics.py
│   │       ├── csv_map.py
│   │       └── email.py
│   └── ops # => ...
├── Makefile
├── projects
│   ├── accounting-linux # => deployable artifact (binary) for linux desktop
│   │   ├── ecom
│   │   │   ├── accounting -> ../../../bases/ecom/accounting/
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── accounting-osx # => deployable artifact (binary) for OSX desktop
│   │   ├── ecom
│   │   │   ├── accounting -> ../../../bases/ecom/accounting/
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── accounting-win # => deployable artifact (binary) for Windows desktop 
│   │   ├── ecom
│   │   │   ├── accounting -> ../../../bases/ecom/accounting/
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── kiosk-api # => deployable (k8s/docker/etc) API server
│   │   ├── ecom
│   │   │   ├── kiosk -> ../../../bases/ecom/kiosk/
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── kiosk-mobile # => deployable (app store/apk/ipa) mobile app
│   │   ├── ecom
│   │   │   ├── kiosk -> ../../../bases/ecom/kiosk/
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── sales-api # => ...
│   │   ├── ecom
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   ├── sales -> ../../../bases/ecom/sales/
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── sales-app # => deployable SPA
│   │   ├── ecom
│   │   │   └── sales -> ../../../bases/ecom/sales/
│   │   ├── index.js
│   │   └── package.json
│   ├── support-app # => deployable (k8s/docker/etc) MPA server
│   │   ├── ecom
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   ├── support -> ../../../bases/ecom/support/
│   │   │   └── tool -> ../../../components/ecom/tool
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── warehouse-api # => ...
│   │   ├── ecom
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   ├── tool -> ../../../components/ecom/tool
│   │   │   └── warehouse -> ../../../bases/ecom/warehouse/
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── warehouse-mobile # => ...
│   │   ├── ecom
│   │   │   └── warehouse -> ../../../bases/ecom/warehouse/
│   │   ├── index.js
│   │   └── package.json
│   ├── webshop-api # => ...
│   │   ├── ecom
│   │   │   ├── lib -> ../../../components/ecom/lib
│   │   │   ├── tool -> ../../../components/ecom/tool
│   │   │   └── webshop -> ../../../bases/ecom/webshop
│   │   ├── main.py
│   │   └── requirements.txt
│   └── webshop-app # => deployable full stack app
│       ├── ecom
│       │   └── webshop -> ../../../bases/ecom/webshop
│       ├── index.js
│       └── package.json
└── README.md
```
Just imagine trying to write code for an ecosystem of this complexity. Then try and imagine how much time and effort and >>cognitive load<< it would take to handle its SDLC.

Polylith puts it all into a single monorepo but helps you with clear separation of what belongs where and why.

Massive props to Joakim Tengstrand, Furkan Bayaraktar, and James Trunk for essentially inventing and creating Polylith as a concept (https://polylith.gitbook.io/polylith/conclusion/who-made-polylith) and of course props to David Vujic for Python tooling (and many many helpful blogs! https://davidvujic.blogspot.com/) for Polylith https://davidvujic.github.io/python-polylith-docs/

So...

back to architecture conundrum - how to fit Django apps into a Polylith?

## Solution

<iframe src="https://microads.ftp.sh/api/ads/delivery-node/random?nonce=abc123"></iframe>

So, two problems with Django apps, and they both stem from how Django is supposed to be set up.

Usually you would either install django globally or

1. init the root project
2. add django itself as a dependency (either via a package manager or by making a venv and doing `.venv/bin/pip3 install django`)
3. once django is installed you can now do `./venv/bin/django-admin` to `startproject` (this makes the Django base setup)
4. use `startapp` to create additional apps for the project, all sitting alongsite the Django base

and it would look like 

```
Script started on 2025-09-02 22:38:40+02:00 [TERM="xterm-256color" TTY="/dev/pts/6" COLUMNS="80" LINES="24"]
user1@machine1:~$ cd /tmp
user1@machine1:/tmp$ mkdir mysystem && cd mysystem
user1@machine1:/tmp/mysystem$ pyenv local 3.13
user1@machine1:/tmp/mysystem$ python3 --version
Python 3.13.5
user1@machine1:/tmp/mysystem$ python3 -m venv .venv
.venv/binuser1@machine1:/tmp/mysystem$ .venv/bin/pip3 install django==5.2.5
Collecting django==5.2.5
  Downloading django-5.2.5-py3-none-any.whl.metadata (4.1 kB)
Collecting asgiref>=3.8.1 (from django==5.2.5)
  Downloading asgiref-3.9.1-py3-none-any.whl.metadata (9.3 kB)
Collecting sqlparse>=0.3.1 (from django==5.2.5)
  Downloading sqlparse-0.5.3-py3-none-any.whl.metadata (3.9 kB)
Downloading django-5.2.5-py3-none-any.whl (8.3 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8.3/8.3 MB 21.0 MB/s eta 0:00:00
.Downloading asgiref-3.9.1-py3-none-any.whl (23 kB)
Downloading sqlparse-0.5.3-py3-none-any.whl (44 kB)
Installing collected packages: sqlparse, asgiref, django
Successfully installed asgiref-3.9.1 django-5.2.5 sqlparse-0.5.3

[notice] A new release of pip is available: 25.1.1 -> 25.2
[notice] To update, run: /tmp/mysystem/.venv/bin/python3 -m pip install --upgrade pip
user1@machine1:/tmp/mysystem$ .venv/bin/pip3 freeze > requirements.txt
user1@machine1:/tmp/mysystem$ .venv/bin/django-admin startproject core .
user1@machine1:/tmp/mysystem$ ls
core  manage.py  requirements.txt
user1@machine1:/tmp/mysystem$ .venv/bin/python3 manage.py startapp firstapp
user1@machine1:/tmp/mysystem$ ls
core  firstapp  manage.py  requirements.txt
user1@machine1:/tmp/mysystem$ .venv/bin/python3 manage.py startapp secondapp
user1@machine1:/tmp/mysystem$ ls
core  firstapp  manage.py  requirements.txt  secondapp
user1@machine1:/tmp/mysystem$ .venv/bin/python3 manage.py runserver
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

You have 18 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
September 02, 2025 - 20:57:43
Django version 5.2.5, using settings 'core.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.

WARNING: This is a development server. Do not use it in a production setting. Use a production WSGI or ASGI server instead.
For more information on production servers see: https://docs.djangoproject.com/en/5.2/howto/deployment/
[02/Sep/2025 20:57:47] "GET / HTTP/1.1" 200 12068
Not Found: /favicon.ico
[02/Sep/2025 20:57:47] "GET /favicon.ico HTTP/1.1" 404 2206
^Cuser1@machine1:/tmp/mysystem$ exit
exit

Script done on 2025-09-02 22:57:52+02:00 [COMMAND_EXIT_CODE="0"]
```

So what you end up with is a django core and one (or many) django apps at the same level, and this way you can configure the apps in the core (this is required of course). Any deviation from this pattern will cause a lot of pain in terms of import paths and namings/configurations.

To translate this into a polylith, because of course we won't be cramming everything into a single `base`, we have two options

- make a new base for each django app (which can make sense in some situations) or
- make a new component for each django app (which I went with for my project)

and the second IMHO makes much more sense. Not only are django apps reusable so they fit as a component but different combinations of apps can be used by multiple different Django artifacts (an admin UI is one simple example).

This way you can mix and match django apps together with multiple different django systems. Here's an example of a personal project of mine where a django system with `primaryapp` brings in multiple other apps as components:

```
.
├── bases
│   └── myproject
│       ├── ...
│       └── webapp
│           ├── asgi.py
│           ├── __init__.py
│           ├── settings.py
│           ├── urls.py
│           └── wsgi.py
│...
├── components
│   ├── djangoapps
│   │   ├── sideapp1
│   │   │   ├── admin.py
│   │   │   ├── apps.py
│   │   │   ├── __init__.py
│   │   │   ├── migrations
│   │   │   │   └── __init__.py
│   │   │   ├── models.py
│   │   │   ├── tests.py
│   │   │   └── views.py
│   │   ├── sideapp2
│   │   │   ├── admin.py
│   │   │   ├── apps.py
│   │   │   ├── __init__.py
│   │   │   ├── migrations
│   │   │   │   └── __init__.py
│   │   │   ├── models.py
│   │   │   ├── __pycache__
│   │   │   ├── tests.py
│   │   │   └── views.py
│   │   ├── sideapp3
│   │   │   ├── admin.py
│   │   │   ├── apps.py
│   │   │   ├── __init__.py
│   │   │   ├── migrations
│   │   │   │   └── __init__.py
│   │   │   ├── models.py
│   │   │   ├── tests.py
│   │   │   └── views.py
│   │   ├── sideapp4
│   │   │   ├── admin.py
│   │   │   ├── apps.py
│   │   │   ├── __init__.py
│   │   │   ├── migrations
│   │   │   │   └── __init__.py
│   │   │   ├── models.py
│   │   │   ├── tests.py
│   │   │   └── views.py
│   │   └── primaryapp
│   │       ├── admin.py
│   │       ├── apps.py
│   │       ├── components.py
│   │       ├── __init__.py
│   │       ├── migrations
│   │       │   └── __init__.py
│   │       ├── models.py
│   │       ├── tests.py
│   │       ├── urls.py
│   │       └── views.py
│   └── myproject
│...
└── projects
    ├── ...
    ├── myproject-webapp
    │   ├── ...
    │   ├── Makefile
    │   ├── README.md
    │   ├── requirements.txt
    │   └── myproject
    │       ├── sideapp1 -> ../../../components/djangoapps/sideapp1
    │       ├── manage.py
    │       ├── sideapp2 -> ../../../components/djangoapps/sideapp2
    │       ├── sideapp3 -> ../../../components/djangoapps/sideapp3
    │       ├── sideapp4 -> ../../../components/djangoapps/sideapp4
    │       ├── primaryapp -> ../../../components/djangoapps/primaryapp
    │       └── webapp -> ../../../bases/myproject/webapp
    └── ...
        └── ...
```

If you have questions or suggestions shoot me an e-mail, at apocpublic@outlook.com.

---
[[Next: how to run both Flask and Django in one runtime](asgi-dispatcher-middleware.html)]
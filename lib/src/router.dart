part of web_router;

/**
 * Route [HttpRequest] objects through an ordered list of routes.
 * 
 * Note that a [Router] is itself a [Route]. This is useful in the case where
 * you may wish to have multiple [Router]s interact with eachother.
 */
class Router extends Route {
  final List<Route> _routes;
  
  /**
   * Create a new [Router] with no routes.
   */
  Router() : _routes = <Route>[];
  
  /**
   * Handle an [HttpRequest] by converting it to a [RouteRequest] and passing it
   * to [handle].
   */
  void httpHandler(HttpRequest request) {
    RouteRequest routeReq = new RouteRequest(request);
    if (!matchesRequest(routeReq)) {
      return sendUnhandled(request.response);
    }
    handle(routeReq).then((bool val) {
      if (!val) return;
      sendUnhandled(request.response);
    });
  }
  
  /**
   * Add a route to the end of the route list.
   */
  void add(Route r) {
    _routes.add(r);
  }
  
  /**
   * Remove a route from the route list.
   */
  void remove(Route r) {
    _routes.remove(r);
  }
  
  /**
   * Register a [function] to handle HTTP GET requests at a certain [path].
   * 
   * This is simply a concise way of creating a [LastPathRoute] and adding it
   * to the [Router].
   */
  void get(String path, LastRouteFunction function,
           {bool caseSensitive: true}) {
    _addLast(path, 'GET', function, caseSensitive);
  }
  
  /**
   * Register a [function] to handle HTTP POST requests at a certain [path].
   * 
   * This is simply a concise way of creating a [LastPathRoute] and adding it
   * to the [Router].
   */
  void post(String path, LastRouteFunction function,
            {bool caseSensitive: true}) {
    _addLast(path, 'POST', function, caseSensitive);
  }
  
  /**
   * Like [get], but the registered handler is simply a pass in the handler
   * chain. This means that the handler must return a [Future] which completes
   * to signal that the request should be passed to the next applicable [Route].
   */
  void getPass(String path, PassRouteFunction function,
               {bool caseSensitive: true}) {
    _addPass(path, 'GET', function, caseSensitive);
  }
  
  /**
   * Like [post], but the registered handler is simply a pass in the handler
   * chain. This means that the handler must return a [Future] which completes
   * to signal that the request should be passed to the next applicable [Route].
   */
  void postPass(String path, PassRouteFunction function,
                {bool caseSensitive: true}) {
    _addPass(path, 'POST', function, caseSensitive);
  }
  
  /**
   * The default 404 handler. This is called when [httpHandler] is called but no
   * routes assume responsibility of the request.
   */
  void sendUnhandled(HttpResponse response) {
    response.statusCode = 404;
    response.headers.contentType = new ContentType('text', 'plain');
    response.write('Unable to handle your request.');
    response.close();
  }
  
  /**
   * Returns `true` if a single route in this router matches the request.
   */
  bool matchesRequest(RouteRequest request) {
    for (Route r in _routes) {
      if (r.matchesRequest(request)) {
        return true;
      }
    }
    return false;
  }
  
  /**
   * Runs a request down the route chain. If no route assumes responsibility of
   * the request, the returned future returns `true`; otherwise it returns
   * `false`.
   */
  Future<bool> handle(RouteRequest request) {
    int idx = 0;
    dynamic runNext(bool val) {
      if (!val) return false;
      if (idx == _routes.length) {
        return true;
      } else {
        Route route = _routes[idx++];
        if (route.matchesRequest(request)) {
          return route.handle(request).then(runNext);
        } else {
          return new Future(() => runNext(true));
        }
      }
    }
    return runNext(true);
  }
  
  void _addLast(String path, String method, LastRouteFunction function,
                bool caseSensitive) {
    LastPathRoute route = new LastPathRoute(path, method, caseSensitive);
    route.handlerFunction = function;
    add(route);
  }
  
  void _addPass(String path, String method, PassRouteFunction function,
                bool caseSensitive) {
    PassPathRoute route = new PassPathRoute(path, method, caseSensitive);
    route.handlerFunction = function;
    add(route);
  }
}

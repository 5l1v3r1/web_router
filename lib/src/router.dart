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
   * Handle an [HttpRequest] by converting it to a [RouteRequest] and passing
   * it to [handle].
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
   * to signal that the request should be passed to the next applicable
   * [Route].
   */
  void getPass(String path, PassRouteFunction function,
               {bool caseSensitive: true}) {
    _addPass(path, 'GET', function, caseSensitive);
  }
  
  /**
   * Like [post], but the registered handler is simply a pass in the handler
   * chain. This means that the handler must return a [Future] which completes
   * to signal that the request should be passed to the next applicable
   * [Route].
   */
  void postPass(String path, PassRouteFunction function,
                {bool caseSensitive: true}) {
    _addPass(path, 'POST', function, caseSensitive);
  }
  
  /**
   * Serve a static file at a specified [localPath].
   * 
   * The file located at [localPath] will be served when a request comes in for
   * [urlPath].
   * 
   * The [method] argument lets you specify the request method to match. The
   * [caseSensitive] flag determines if [urlPath] should be matched in a
   * case-sensitive way.
   * 
   * The [type] argument specifies the MIME type to send in the response. By
   * default, the MIME type is derived from the file extension of [localPath]. 
   */
  void staticFile(String urlPath, String localPath,
                  {String method: 'GET', bool caseSensitive: true,
                   ContentType type: null}) {
    add(new FilePathRoute(urlPath, 'GET', caseSensitive, localPath,
        contentType: type));
  }
  
  /**
   * Serve a directory from the file system.
   * 
   * Whenever a request comes in for a file inside of [urlPath], the
   * corresponding path within [localPath] is read from the local file system
   * and piped to the response.
   */
  void staticDirectory(String urlPath, String localPath) {
    add(new DirectoryRoute(urlPath, localPath));
  }
  
  /**
   * Serve a JavaScript source file by compiling a Dart source file.
   * 
   * The created route will serve [urlPath] by compiling the Dart script
   * [filePath].
   * 
   * The [method] and [caseSensitive] arguments act just like they would for
   * [post] and [get].
   * 
   * Specify `false` for [rebuildOnChange] to prevent the route from
   * recompiling the script when it changes.
   * 
   * By default, the path to the `dart2js` command is determined using the path
   * to the `dart` command running this isolate. You may specify
   * a different [compilerCommand] if you wish to use a different SDK to
   * compile the Dart script.
   */
  void dart2js(String urlPath, String filePath, {String method: 'GET',
               bool caseSensitive: true, bool rebuildOnChange: true,
               String compilerCommand: null}) {
    add(new Dart2JSPathRoute(urlPath, method, caseSensitive, filePath,
        compilerCommand: compilerCommand, rebuildOnChange: rebuildOnChange));
  }
  
  /**
   * Add a route which redirects [path] to [location].
   * 
   * The [location] argument may be a [Uri] or a [String].
   * 
   * The [method] and [caseSensitive] arguments act just like they would for
   * [post] and [get].
   */
  void redirect(String path, dynamic location, {String method: 'GET',
                bool caseSensitive: true}) {
    if (location is String) {
      add(new RedirectPathRoute(path, method, caseSensitive,
          Uri.parse(location)));
    } else if (location is Uri) {
      add(new RedirectPathRoute(path, method, caseSensitive, location));
    } else {
      throw new ArgumentError('redirect location must be a String or a Uri');
    }
  }
  
  /**
   * Add a [PathParameterRoute].
   * 
   * As an example, you may wish to use [pathParameter] to pass user IDs to a
   * "profile" page:
   * 
   *     Router router = new Router();
   *     router.pathParameter('/profile/', fieldName: 'userId');
   *     router.get('/profile/', (RouteRequest r) {
   *       r.request.response..write('User ID is ' + r.map['userId'])
   *                         ..close();
   *     });
   * 
   * This example passes the result of the [PathParameterRoute] to a [get]
   * handler using the "userId" key in the request's map.
   */
  void pathParameter(String path, {String fieldName: 'parameter',
                     bool caseSensitive: true}) {
    add(new PathParameterRoute(path, caseSensitive, fieldName));
  }
  
  /**
   * The default 404 handler. This is called when [httpHandler] is called but
   * no routes assume responsibility of the request.
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

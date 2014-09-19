part of web_router;

/**
 * A request object which gets passed to each handler in the handler chain.
 */
class RouteRequest {
  /**
   * The HTTP request.
   */
  final HttpRequest request;
  
  /**
   * A map of information that may be used to transfer handler-specific data
   * down the chain.
   */
  final Map map;
  
  /**
   * The URI of the request.
   * 
   * Unlike the `uri` property of the raw [request], this may be rewritten by
   * any route. Thus, routes should generally use this property rather than the
   * [request]'s `uri` property.
   */
  Uri uri;
  
  /**
   * The request's response field. This is for convenience only.
   */
  HttpResponse get response => request.response;
  
  /**
   * Create a new request given an HTTP request. The result will have an empty
   * [map].
   */
  RouteRequest(this.request) : map = new Map() {
    uri = request.uri;
  }
  
  /**
   * Update [uri] to contain a different [path].
   */
  void rewritePath(String path) {
    uri = new Uri(scheme: uri.scheme, userInfo: uri.userInfo, host: uri.host,
        port: uri.port, path: path, query: uri.query, fragment: uri.fragment);
  }
}

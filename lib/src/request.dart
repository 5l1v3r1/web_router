part of router;

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
   * The request's response field. This is for convenience only.
   */
  HttpResponse get response => request.response;
  
  /**
   * Create a new request given an HTTP request. The result will have an empty
   * [map].
   */
  RouteRequest(this.request) : map = new Map(); 
}

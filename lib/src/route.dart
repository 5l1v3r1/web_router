part of web_router;

/**
 * A handler for new incoming requests. A handler may decide whether it can
 * handle each request and whether the request should be further passed down the
 * handler chain.
 */
abstract class Route {
  /**
   * Return true if this [Route] should handle a certain [request].
   */
  bool matchesRequest(RouteRequest request);
  
  /**
   * Handle a request. The returned future should end with a value of `true` if
   * the request should be further passed down the chain. A value of `false`
   * indicates that the handler has assumed responsibility of the request.
   */
  Future<bool> handle(RouteRequest request);
}

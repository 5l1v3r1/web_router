part of router;

/**
 * A method which is called to handle a [RouteRequest].
 */
typedef void LastRouteFunction(RouteRequest req);

/**
 * A class intended to be used as a mixin to handle requests with an anonymous
 * function
 */
class LastRoute {
  /**
   * The function to use as the handler.
   */
  LastRouteFunction handlerFunction;
  
  /**
   * Runs [handlerFunction] and returns a [Future] that completes with `false`.
   */
  Future<bool> handle(RouteRequest request) {
    handlerFunction(request);
    return new Future(() => false);
  }
}

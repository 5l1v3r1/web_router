part of router;

/**
 * A handler which returns a [Future] that may complete with any value. When the
 * future completes, the next available route will be triggered.
 */
typedef Future PassRouteFunction(RouteRequest req);

/**
 * A class meant to be used as a mixin to handle requests and pass them along.
 */
class PassRoute {
  /**
   * The function to use as a handler.
   */
  PassRouteFunction handlerFunction;
  
  /**
   * Runs [handlerFunction] with the specified [request]. The returned [Future]
   * finished with a value of `true` when the result of [handlerFunction]
   * completes.
   */
  Future<bool> handle(RouteRequest request) {
    return handlerFunction(request).then((_) => true);
  }
}

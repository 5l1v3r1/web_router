part of web_router;

/**
 * Mix this with a request matcher like [PathRoute] to redirect one URL to
 * another one.
 */
abstract class RedirectRoute {
  Uri get location;
  
  /**
   * Redirect the request to [location] and return a [Future] that completes
   * with `false`.
   */
  Future<bool> handle(RouteRequest request) {
    request.response.redirect(location);
    return new Future(() => false);
  }
}

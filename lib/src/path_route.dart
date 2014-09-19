part of web_router;

/**
 * A [Route] which only matches requests whose path and request method match
 * certain values
 */
abstract class PathRoute extends Route {
  /**
   * The path to match.
   */
  final String path;
  
  /**
   * The method to match. For example, this might be `GET` or `POST`.
   */
  final String method;
  
  /**
   * `true` if [path] should be matched case-sensitively with the requested
   * path.
   */
  final bool caseSensitive;
  
  /**
   * Create a new [PathRoute] with a specified [path], a [method], and the
   * [caseSensitive] flag.
   */
  PathRoute(this.path, this.method, this.caseSensitive);
  
  /**
   * Returns `true` if the [request]'s method matches [method] and its path
   * matches [path].
   */
  bool matchesRequest(RouteRequest request) {
    String reqMethod = request.request.method.toLowerCase();
    String expectMethod = method.toLowerCase();
    if (reqMethod != expectMethod) {
      if (reqMethod != 'head' || expectMethod != 'get') {
        return false;
      }
    }
    String aPath = request.uri.path;
    if (caseSensitive) {
      return aPath == path;
    } else {
      return aPath.toLowerCase() == path.toLowerCase();
    }
  }
}

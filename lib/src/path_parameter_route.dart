part of web_router;

/**
 * A route which facilitates argument-passing via URL path components.
 * 
 * For example, you may wish to have a URL like "http://site.com/profile/3182"
 * where the "/profile/" path ends with a user identifier as the final path
 * component.
 * 
 * To implement such a thing, you can setup a [PathParameterRoute] with a
 * [path] "/profile/" and a [fieldName] of "userId". Then, you can add another
 * router for "/profile/" later on in the [Router] which looks at the "userId"
 * field of the request's map.
 */
class PathParameterRoute implements Route {
  String _matchPath;
  
  /**
   * The path which will be matched.
   * 
   * For example, if [path] is "/my/path", then a request to
   * "/my/path/some/components" will rewrite the request to "/my/path" and
   * yield a parameter of "some/components".
   * 
   * Trailing slashes in [path] are unnecessary, but you may specify one to
   * affect the rewrite path. In the above example, if you used a [path]
   * "/my/path/", the request would be rewritten to "/my/path/" instead of
   * "/my/path".
   */
  final String path;
  
  /**
   * If [caseSensitive] is `true`, [path] will be matched case-sensitively.
   * Otherwise, [path] will be matched case-insensitively.
   */
  final bool caseSensitive;
  
  /**
   * A [PathParameterRoute] finds a parameter by slicing it off the end of a
   * request path. The parameter is set in each matching request's map via the
   * field by the name of [fieldName].
   * 
   * If [fieldName] is `null`, this route will not affect requests' maps.
   */
  final String fieldName;
  
  /**
   * Create a [PathParameterRoute] that matches a [path].
   */
  PathParameterRoute(this.path, this.caseSensitive, this.fieldName) {
    if (!path.endsWith('/')) {
      _matchPath = path + '/';
    } else {
      _matchPath = path;
    }
    if (!caseSensitive) {
      _matchPath = _matchPath.toLowerCase();
    }
  }
  
  /**
   * Returns `true` if the [request]'s URI's path begins with [path]. The
   * comparison is performed in a case-sensitive way if [caseSensitive] is
   * true.
   */
  bool matchesRequest(RouteRequest request) {
    String aPath = request.uri.path;
    if (caseSensitive) {
      return aPath.startsWith(_matchPath);
    } else {
      return aPath.toLowerCase().startsWith(_matchPath);
    }
  }
  
  /**
   * Rewrite a [request]'s path and put the parameter from the old path into
   * its map.
   * 
   * Returns a [Future] which completes with a value of `true`.
   */
  Future<bool> handle(RouteRequest request) {
    String aPath = request.uri.path;
    assert(aPath.length >= _matchPath.length);
    if (fieldName != null) {
      String parameter = aPath.substring(_matchPath.length);
      request.map[fieldName] = parameter;
    }
    request.rewritePath(path);
    return new Future(() => true);
  }
}

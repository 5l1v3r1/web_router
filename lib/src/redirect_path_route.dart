part of web_router;

/**
 * A combination of [PathRoute] and [RedirectRoute].
 */
class RedirectPathRoute extends PathRoute with RedirectRoute {
  final Uri location;
  
  RedirectPathRoute(String path, String method, bool caseSensitive,
      this.location) : super(path, method, caseSensitive);
}

part of web_router;

/**
 * A combination of [PathRoute] and [LastRoute].
 *
 * I would have liked to be able to make this class a pure mixin like this:
 *
 *     class LastPathRoute = PathRoute with LastRoute
 *
 * but a dartanalyzer bug prevented me from doing that, because the analyzer
 * would freeze the Dart Editor.
 */
class LastPathRoute extends PathRoute with LastRoute {
  LastPathRoute(String path, String method, bool caseSensitive) :
      super(path, method, caseSensitive);
}
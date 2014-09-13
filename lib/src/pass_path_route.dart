part of web_router;

/**
 * A combination of [PathRoute] and [PassRoute].
 *
 * I would have liked to be able to make this class a pure mixin like this:
 *
 *     class PassPathRoute = PathRoute with PassRoute
 *
 * but a dartanalyzer bug prevented me from doing that, because the analyzer
 * would freeze the Dart Editor.
 */
class PassPathRoute extends PathRoute with PassRoute {
  PassPathRoute(String path, String method, bool caseSensitive) :
       super(path, method, caseSensitive);
}
part of web_router;

/**
 * The combination of a [PathRoute] and a [Dart2JSRoute]. The [Dart2JSRoute]
 * class is not a simple mixin because it requires several getters be
 * overridden.
 */
class Dart2JSPathRoute extends PathRoute with Dart2JSRoute {
  final String sourcePath;
  final bool rebuildOnChange;
  final String compilerCommand;
  
  Dart2JSPathRoute(String path, String method, bool caseSensitive,
                   this.sourcePath, {this.rebuildOnChange: true,
                   this.compilerCommand: 'dart2js'}) :
                   super(path, method, caseSensitive);
}

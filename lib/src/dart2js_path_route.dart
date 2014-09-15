part of web_router;

/**
 * The combination of a [PathRoute] and a [Dart2JSRoute].
 */
class Dart2JSPathRoute extends PathRoute with Dart2JSRoute {
  final String sourcePath;
  final bool rebuildOnChange;
  String compilerCommand;
  
  /**
   * Create a [Dart2JSPathRoute] that compiles the script file [sourcePath].
   * 
   * The [path], [method], and [caseSensitive] arguments are used to call
   * [PathRoute]'s constructor.
   * 
   * The [rebuildOnChange] argument is passed directly to the [Dart2JSRoute].
   * 
   * The [compilerCommand] argument is a bit fancy. If you specify a command,
   * it will be passed to the [Dart2JSRoute]. However, if [compilerCommand] is
   * `null`, the constructor will use the [Platform]'s executable path to
   * figure out the path to the SDK's `dart2js` command.
   */
  Dart2JSPathRoute(String path, String method, bool caseSensitive,
                   this.sourcePath, {this.rebuildOnChange: true,
                   this.compilerCommand: null}) :
                   super(path, method, caseSensitive) {
    if (compilerCommand == null) {
      String execPath = Platform.executable;
      if (execPath.length == 0 || execPath == 'dart') {
        compilerCommand = 'dart2js';
      } else {
        compilerCommand = path_library.join(path_library.dirname(execPath),
            'dart2js');
      }
    }
  }
}

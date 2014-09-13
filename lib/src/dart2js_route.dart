part of web_router;

abstract class Dart2JSRoute {
  /**
   * Return the path to the Dart source file to compile.
   */
  String get sourcePath;
  
  /**
   * If `true`, every request will trigger the route to check the modification
   * date on the dart source file. If it has been modified since the last
   * time it was compiled, it will be recompiled. If `false`, the source file
   * will be compiled (lazily) once, and then never again.
   */
  bool get rebuildOnChange;
  
  /**
   * Return the `dart2js` command. This may simply be "dart2js".
   */
  String get compilerCommand;
  
  String _compiled = null;
  Future<String> _compileFuture = null;
  DateTime _lastModified = null;
  
  /**
   * Kicks off a compilation [Process] or sends an already-compiled script.
   *
   * Returns a [Future] that completes with `false`.
   */
  Future<bool> handle(RouteRequest request) {
    HttpResponse response = request.request.response;
    response.headers.contentType = new ContentType('text', 'javascript');
    if (_compileFuture != null) {
      _compileFuture = _compileFuture.then((String result) {
        response..write(result)..close();
        return result;
      });
    } else if (_compiled != null && !rebuildOnChange) {
      response..write(_compiled)..close();
    } else {
      _compileFuture = _fileUpdated().then((bool updated) {
        if (!updated) {
          return _compiled;
        } else {
          return _compile();
        }
      }).then((String result) {
        _compiled = result;
        _compileFuture = null;
        response..write(result)..close();
        return result;
      });
    }
    return new Future(() => false);
  }
  
  Future<bool> _fileUpdated() {
    return new File(sourcePath).stat().then((FileStat stats) {
      if (stats.modified != _lastModified) {
        _lastModified = stats.modified;
        return true;
      } else {
        return false;
      }
    });
  }
  
  Future<String> _compile() {
    // generate a temporary directory, run dart2js, strip the source maps, and
    // return the result
    String jsPath;
    Directory outputDirectory;
    return Directory.systemTemp.createTemp().then((Directory d) {
      outputDirectory = d;
      jsPath = path_library.join(d.absolute.path, 'out.js');
      List<String> args = ['-m', sourcePath, '-o', jsPath];
      return Process.run(compilerCommand, args);
    }).then((ProcessResult res) {
      if (res.exitCode != 0) {
        return 'console.error("failed to compile $sourcePath");';
      }
      return new File(jsPath).readAsString();
    }).then((String contents) {
      RegExp sourceMapping = new RegExp('//# sourceMappingURL=.*\n');
      String result = contents.replaceFirst(sourceMapping, '');
      return outputDirectory.delete(recursive: true).then((_) => result);
    });
  }
}

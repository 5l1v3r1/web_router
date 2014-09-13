part of web_router;

/**
 * Serve a directory from the file system.
 */
class DirectoryRoute implements Route {
  final String urlPath;
  final String localPath;
  
  DirectoryRoute(this.urlPath, this.localPath);
  
  /**
   * Return `true` if the request's path is within [urlPath].
   */
  bool matchesRequest(RouteRequest request) {
    return path_library.posix.isWithin(urlPath, request.request.uri.path);
  }
    
  /**
   * Attempt to read a local file and send it as a response.
   * 
   * The returned [Future] will complete with a `true` value if the file does
   * not exist or could not be read. Otherwise, it will complete with `false`.
   */
  Future<bool> handle(RouteRequest request) {
    var c = new Completer();
    String path = _nativeLocalPath(request);
    File file = new File(path);
    file.stat().then((FileStat stats) {
      if (stats.type == FileSystemEntityType.NOT_FOUND ||
          stats.type == FileSystemEntityType.DIRECTORY) {
        throw 'bad type';
      }
      String type = mime_library.lookupMimeType(path);
      if (type == null) type = 'application/octet-stream';
      request.response.headers.contentType = ContentType.parse(type);
      return file.openRead().pipe(request.response).then((_) {
        c.complete(false);
      });
    }).catchError((_) {
      c.complete(true);
    });
    return c.future;
  }
  
  String _nativeLocalPath(RouteRequest request) {
    String relative = path_library.posix.relative(request.request.uri.path,
        from: urlPath);
    List<String> components = path_library.posix.split(relative);
    String relNative = path_library.joinAll(components);
    return path_library.join(localPath, relNative);
  }
}

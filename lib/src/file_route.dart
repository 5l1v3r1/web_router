part of web_router;

/**
 * Mix this with a request matcher like [PathRoute] to serve the contents of a
 * file from the file system.
 */
abstract class FileRoute {
  String get filePath;
  ContentType get contentType;
  
  /**
   * Read the local file and write it as a response.
   * 
   * Returns a [Future] that completes with `false`.
   */
  Future<bool> handle(RouteRequest request) {
    new File(filePath).openRead().pipe(request.request.response);
    return new Future(() => false);
  }
}

part of web_router;

ContentType _computeCT(String path, ContentType ct) {
  if (ct != null) return ct;
  String typeStr = mime_library.lookupMimeType(path);
  if (typeStr == null) {
    return new ContentType('application', 'octet-stream');
  }
  return ContentType.parse(typeStr);
}

/**
 * A combination of [PathRoute] and [FileRoute].
 */
class FilePathRoute extends PathRoute with FileRoute {
  final String filePath;
  final ContentType contentType;
  
  /**
   * Create a [FilePathRoute] that returns the contents of [filePath].
   * 
   * The [method], [path], and [caseSensitive] arguments are passed directly to
   * [PathRoute].
   * 
   * The [contentType] argument determines the MIME type to send with the
   * contents of the file. If [contentType] is not specified or is `null`, it
   * is derived based on the file extension of [filePath].
   */
  FilePathRoute(String path, String method, bool caseSensitive,
                String filePath, {ContentType contentType: null}) :
      super(path, method, caseSensitive), filePath = filePath,
      contentType = _computeCT(filePath, contentType);
}

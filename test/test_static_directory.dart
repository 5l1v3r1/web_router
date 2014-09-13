import 'package:web_router/web_router.dart';
import 'dart:io';

void main() {
  Router router = new Router();
  router.get('', homepage);
  router.get('/', homepage);
  router.staticDirectory('/', '..');
  HttpServer.bind('localhost', 1337).then((HttpServer server) {
    server.listen(router.httpHandler);
  });
  print('navigate to http://localhost:1337/');
}

void homepage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>Static Directory Test</title>
  </head>
  <body>
    <h1>There should be an image below this heading</h1>
    <img src="test/sample.jpg">
    <br /><br />
    You can checkout the source for this test
    <a href="test/test_static_directory.dart">here</a>.
    <br /><br />
    Checkout the README
    <a href="README.md">here</a>
  </body>
</html>
""";
  req.response.headers.contentType = new ContentType('text', 'html');
  req.response.write(page);
  req.response.close();
}

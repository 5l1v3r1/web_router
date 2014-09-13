import 'package:web_router/web_router.dart';
import 'dart:io';

void main() {
  Router router = new Router();
  router.get('', homepage);
  router.get('/', homepage);
  router.staticFile('/sample.jpg', 'sample.jpg');
  HttpServer.bind('localhost', 1337).then((HttpServer server) {
    server.listen(router.httpHandler);
  });
  print('navigate to http://localhost:1337/');
}

void homepage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>Static File Test</title>
  </head>
  <body>
    <h1>There should be an image below this heading</h1>
    <img src="sample.jpg">
  </body>
</html>
""";
  req.response.headers.contentType = new ContentType('text', 'html');
  req.response.write(page);
  req.response.close();
}

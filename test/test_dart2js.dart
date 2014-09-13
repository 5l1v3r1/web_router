import 'package:web_router/web_router.dart';
import 'dart:io';

void main() {
  Router router = new Router();
  router.get('', homepage);
  router.get('/', homepage);
  router.dart2js('/script.dart.js', './sample_script.dart');
  HttpServer.bind('localhost', 1337).then((HttpServer server) {
    server.listen(router.httpHandler);
  });
  print('navigate to http://localhost:1337/');
}

void homepage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>Home</title>
  </head>
  <body>
    <h1>Waiting for script...</h1>
    <script src="script.dart.js"></script>
  </body>
</html>
""";
  req.response.headers.contentType = new ContentType('text', 'html');
  req.response.write(page);
  req.response.close();
}

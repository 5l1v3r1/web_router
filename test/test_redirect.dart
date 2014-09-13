import 'package:web_router/web_router.dart';
import 'dart:io';

void main() {
  Router router = new Router();
  router.redirect('', '/cool.html');
  router.redirect('/', '/cool.html');
  router.redirect('/cool', new Uri(path: '/cool.html'));
  router.get('/cool.html', coolPage);
  HttpServer.bind('localhost', 1337).then((HttpServer server) {
    server.listen(router.httpHandler);
  });
  print('navigate to http://localhost:1337/');
}

void coolPage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>Cool Page</title>
  </head>
  <body>
    <h1>Hey there, this is a cool page, huh?</h1>
  </body>
</html>
""";
  req.response..headers.contentType = new ContentType('text', 'html')
              ..write(page)
              ..close();
}

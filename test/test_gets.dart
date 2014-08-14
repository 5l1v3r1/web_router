import 'package:router/router.dart';
import 'dart:io';
import 'dart:async';

void main() {
  Router router = new Router();
  router.getPass('', (RouteRequest r) {
    r.map['title'] = 'Home';
    return new Future(() => null);
  });
  router.getPass('/', (RouteRequest r) {
    r.map['title'] = 'Home';
    return new Future(() => null);
  });
  router.getPass('/cool.html', (RouteRequest r) {
    r.map['title'] = 'Cool';
    return new Future(() => null);
  });
  router.get('', homepage);
  router.get('/', homepage);
  router.get('/cool.html', coolPage);
  HttpServer.bind('localhost', 1337).then((HttpServer server) {
    server.listen(router.httpHandler);
  });
}

void homepage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>""" + req.map['title'] + """</title>
  </head>
  <body>
    <h1>Welcome</h1>
    Check out my cool page <a href="cool.html">here</a>
  </body>
</html>
""";
  req.response.headers.contentType = new ContentType('text', 'html');
  req.response.write(page);
  req.response.close();
}

void coolPage(RouteRequest req) {
  String page = """
<html>
  <head>
    <title>""" + req.map['title'] + """</title>
  </head>
  <body>
    <marquee>This tag is deprecated because it's useless</marquee>
  </body>
</html>
""";
  req.response.headers.contentType = new ContentType('text', 'html');
  req.response.write(page);
  req.response.close();
}

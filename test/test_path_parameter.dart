import 'package:web_router/web_router.dart';
import 'dart:io';

void main() {
  Router router = new Router();
  router.pathParameter('/profile/', fieldName: 'userId');
  router.get('/profile/', (RouteRequest r) {
    r.request.response..write('User ID is ' + r.map['userId'])
                      ..close();
  });
  /*router.redirect('', '/');
  router.get('/', homepage);
  router.pathParameter('/profile', fieldName: 'userId', caseSensitive: false);
  router.get('/profile', profile);
   */
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
    <h1>Welcome</h1>
    Check out <a href="/PRofILE/Bill">Bill's profile</a>
    <br />
    Check out <a href="/profile/Joe">Joe's profile</a>
  </body>
</html>
""";
  req.response..headers.contentType = new ContentType('text', 'html')
              ..write(page)
              ..close();
}

void profile(RouteRequest req) {
  String userIdentifier = req.map['userId'];
  if (userIdentifier == null) {
    userIdentifier = 'UNIDENTIFIED';
  }
  String page = """
<html>
  <head>
    <title>""" + userIdentifier + """</title>
  </head>
  <body>
    <p>This person's name is <b>""" + userIdentifier + """</b></p>
  </body>
</html>
""";
  req.response..headers.contentType = new ContentType('text', 'html')
              ..write(page)
              ..close();
}

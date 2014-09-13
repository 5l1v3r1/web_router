/**
 * A simple and expandable way to route HTTP requests.
 * 
 * The [Router] class has a method, `httpHandler`, specifically for processing
 * [HttpRequest]s straight from an [HttpServer]. The [Router] runs these
 * through a series of [Route]s. Each [Route] may record information about the
 * request before passing it to the next [Route], or it may choose to respond to
 * the request and prevent further [Route]s from being invoked.
 * 
 * The [Router] provides additional utility methods like `get` and `post` to
 * make it super easy to register simple handler functions in one line of code.
 * Here is an example of how you might configure a simple [Router] to serve one
 * page, "a.txt":
 * 
 *     Router router = new Router();
 *     router.get('/a.txt', (RouteRequest r) {
 *       return r.response..write('hey')..close();
 *     });
 *     HttpServer.bind('localhost', 1337).then((HttpServer server) {
 *       server.listen(router.httpHandler);
 *     });
 *
 */
library web_router;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path_library;

part 'src/router.dart';
part 'src/route.dart';
part 'src/request.dart';
part 'src/path_route.dart';
part 'src/last_route.dart';
part 'src/pass_route.dart';
part 'src/dart2js_route.dart';
part 'src/dart2js_path_route.dart';
part 'src/last_path_route.dart';
part 'src/pass_path_route.dart';

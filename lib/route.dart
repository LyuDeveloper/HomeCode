import 'package:go_router/go_router.dart';

import 'main.dart';
import 'article_read.dart';

class AppRoutes {
  
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'HomePage',
        path: '/', 
        builder: (context, state) => MyHomePage(title: 'Home Page'),
      ),
      GoRoute(
        name: "ReadArtPage",
        path: '/article/:name', 
        builder: (context, state) {
          final name = state.params['name']!;
          return ReadArtPage(filename: name);
        }
      )
    ]
  );
}

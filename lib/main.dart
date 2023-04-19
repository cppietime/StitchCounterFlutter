import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch_counter/screens/home_screen.dart';
import 'package:stitch_counter/screens/project_screen.dart';

import 'data/database.dart';

void main() {
  runApp(const StitcCounterApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/project',
      builder: (context, state) {
        final args = state.extra as List<dynamic>;
        final db = args[0] as StitchDb;
        final project = args[1] as Project;
        return ProjectScreen(db, project);
      },
    ),
  ],
);

class StitcCounterApp extends StatelessWidget {
  const StitcCounterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Stitch Counter',
    );
  }
}

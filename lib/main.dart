import 'package:flutter/material.dart';
import 'package:navigation/presentation/views/home_screen.dart';

import 'navigator/route_observer/route_observer_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        RouteObserverUtils().getObserver(ObserverType.route),
      ],
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

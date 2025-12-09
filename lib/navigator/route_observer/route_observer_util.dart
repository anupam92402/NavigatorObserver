import 'package:flutter/material.dart';
import 'package:navigation/navigator/route_observer/route_observer.dart';

import '../navigator_observer/navigation_observer.dart';

/// Enum to select which observer to provide.
enum ObserverType { navigator, route }

class RouteObserverUtils {
  static final RouteObserverUtils _instance = RouteObserverUtils._internal();

  factory RouteObserverUtils() {
    return _instance;
  }

  RouteObserverUtils._internal();

  /// A shared NavigatorObserver (can be a base observer or your custom one elsewhere).
  NavigatorObserver? observer;

  /// Factory method that returns a single observer instance based on [kind].
  NavigatorObserver getObserver(ObserverType type, [bool enableLogger = true]) {
    switch (type) {
      case ObserverType.navigator:
        {
          observer ??= CustomNavigatorObserver(enableLogger: enableLogger);
        }
      case ObserverType.route:
        {
          observer ??= CustomRouteObserver(enableLogger: enableLogger);
        }
    }
    return observer!;
  }
}

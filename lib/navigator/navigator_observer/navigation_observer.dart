import 'package:flutter/widgets.dart';

/// Custom NavigatorObserver that logs all navigation lifecycle events.
class CustomNavigatorObserver extends NavigatorObserver {
  /// List to maintain the stack of routes.
  static final List<Route<dynamic>> _stack = [];

  /// Flag to enable or disable logging.
  final bool enableLogger;

  CustomNavigatorObserver({this.enableLogger = true});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    _log(
      'didPush: ${_routeName(route)} from ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _log(
      'didPop: ${_routeName(route)} to ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _log(
      'didRemove: ${_routeName(route)}; previous ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      final idx = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
      if (idx >= 0) {
        _stack[idx] = newRoute;
      } else {
        _stack.add(newRoute);
      }
    }
    _log(
      'didReplace: ${_routeName(oldRoute)} -> ${_routeName(newRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    _log(
      'didStartUserGesture on ${_routeName(route)}; previous ${_routeName(previousRoute)}',
    );
  }

  @override
  void didStopUserGesture() {
    _log('didStopUserGesture');
  }

  /// Common logger to centralize printing and respect enableLogger.
  void _log(String message) {
    if (enableLogger) {
      print('[NavigatorObserver] $message');
    }
  }

  String _routeName(Route<dynamic>? route) {
    if (route == null) return 'null';
    final name = route.settings.name;
    return (name != null && name.isNotEmpty)
        ? name
        : route.runtimeType.toString();
  }
}

import 'package:flutter/widgets.dart';

/// Custom RouteObserver that mirrors the behavior of CustomNavigatorObserver
/// and tracks a stack of ModalRoute<dynamic> while logging in green.
class CustomRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  /// List to maintain the stack of page routes.
  final List<ModalRoute<dynamic>> _stack = [];

  /// Flag to enable or disable logging.
  final bool enableLogger;

  CustomRouteObserver({this.enableLogger = true});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final modalRoute = route is ModalRoute<dynamic> ? route : null;
    if (modalRoute != null) {
      _stack.add(modalRoute);
    }
    _log(
      'didPush: ${_routeName(route)} from ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final modalRoute = route is ModalRoute<dynamic> ? route : null;
    if (modalRoute != null) {
      _stack.remove(modalRoute);
    }
    _log(
      'didPop: ${_routeName(route)} to ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final modalRoute = route is ModalRoute<dynamic> ? route : null;
    if (modalRoute != null) {
      _stack.remove(modalRoute);
    }
    _log(
      'didRemove: ${_routeName(route)}; previous ${_routeName(previousRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final newPage = newRoute is ModalRoute<dynamic> ? newRoute : null;
    final oldPage = oldRoute is ModalRoute<dynamic> ? oldRoute : null;

    if (newPage != null) {
      final idx = oldPage == null ? -1 : _stack.indexOf(oldPage);
      if (idx >= 0) {
        _stack[idx] = newPage;
      } else {
        _stack.add(newPage);
      }
    }
    _log(
      'didReplace: ${_routeName(oldRoute)} -> ${_routeName(newRoute)} | stack=${_stack.map(_routeName).toList()}',
    );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  /// Common logger to centralize printing and respect enableLogger.
  void _log(String message) {
    if (enableLogger) {
      print('[RouteObserver] $message');
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

# Navigation Observers and Route Awareness

This project demonstrates custom Navigator and Route observers and how to use RouteAware in screens to react to navigation lifecycle events.

## Features
- CustomNavigatorObserver: logs push, pop, remove, replace, and user gesture events via NavigatorObserver, maintains a route stack.
- CustomRouteObserver: logs page route events via RouteObserver and keeps a page route stack.
- RouteAware integration: subscribe/unsubscribe screens and handle didPush, didPop, didPopNext, didPushNext.

## Key Files
- `lib/navigator/navigation_observer.dart`: Custom NavigatorObserver with plain logging and route stack.
- `lib/navigator/route_observer/route_observer.dart`: Custom RouteObserver for `PageRoute<dynamic>`.
- `lib/navigator/route_observer/route_observer_util.dart`: Utility that returns a singleton observer instance based on `ObserverType`.
- `lib/presentation/views/home_screen.dart`: Example screen using RouteAware, named routes, and an internal `_log` method for class-level logging.

## Setup
Ensure Flutter is installed and dependencies are ready. This project uses Flutter SDK 3.35.1.

```sh
flutter pub get
flutter run
```

## Register Observers
Register the desired observer(s) in your `MaterialApp`:

```dart
import 'package:navigation/navigator/route_observer/route_observer_util.dart';

MaterialApp(
  navigatorObservers: [
    // Route-level observer (for RouteAware widgets):
    RouteObserverUtils().getObserver(ObserverType.route),

    // Navigator-level observer (for global navigation lifecycle):
    RouteObserverUtils().getObserver(ObserverType.navigator),
  ],
  // routes, home, etc.
)
```

Notes:
- The `enableLogger` flag is respected only on the first creation of each observer kind.
- To disable logs globally, call the utility early with `enableLogger: false`:


## Using RouteAware in a Screen
Example: `HomeScreen`

Subscribe in `didChangeDependencies` and unsubscribe in `dispose`:

```dart
import 'package:flutter/widgets.dart';
import 'package:navigation/navigator/route_observer/route_observer_util.dart';

class HomeScreenState extends State<HomeScreen> with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  // Optional: small helper for class-level logs
  void _log(String message) => print('[RouteAware][HomeScreen] $message');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final observer = RouteObserverUtils().getObserver(ObserverType.route);
    if (observer is RouteObserver<PageRoute<dynamic>>) {
      _routeObserver = observer;
      final route = ModalRoute.of(context);
      if (route is PageRoute<dynamic>) {
        _routeObserver!.subscribe(this, route);
        _log('Subscribed to RouteObserver for \'${route.settings.name ?? 'unknown'}\'');
      }
    }
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    _log('Unsubscribed from RouteObserver');
    super.dispose();
  }

  @override
  void didPush() => _log('didPush');
  @override
  void didPop() => _log('didPop');
  @override
  void didPopNext() => _log('didPopNext');
  @override
  void didPushNext() => _log('didPushNext');
}
```

## Troubleshooting
- If logs show `MaterialPageRoute<dynamic>` instead of screen names, ensure you set `RouteSettings(name: ...)` or use named routes.
- If RouteAware callbacks don’t fire, confirm the route observer instance is registered in `MaterialApp`.

## License
This repository is for demonstration purposes. Adapt as needed for your projects.

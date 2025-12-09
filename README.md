# Navigation Observers and Route Awareness

This project demonstrates custom Navigator and Route observers, a simple logging utility, and how to use RouteAware in screens to react to navigation lifecycle events.

## Features
- CustomNavigatorObserver: logs push, pop, remove, replace, and user gesture events, maintains a route stack.
- CustomRouteObserver: logs page route events via RouteObserver and keeps a page route stack.
- RouteAware integration: subscribe/unsubscribe screens and handle didPush, didPop, didPopNext, didPushNext.
- Centralized, colorless logging with a simple `log(tag, message)` method.

## Key Files
- `lib/navigator/navigation_observer.dart`: Custom NavigatorObserver with plain logging and route stack.
- `lib/navigator/route_observer/route_observer.dart`: Custom RouteObserver for `PageRoute<dynamic>`.
- `lib/navigator/route_observer/route_observer_util.dart`: Utility that returns a singleton observer instance based on `ObserverType`.
- `lib/utils/logger.dart`: Top-level `log(tag, message)` method for plain logs.
- `lib/presentation/views/home_screen.dart`: Example screen using RouteAware and named routes.

## Setup
Ensure Flutter is installed and dependencies are ready.

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

```dart
// Example: in main() before building MaterialApp
final routeObs = RouteObserverUtils().getObserver(ObserverType.route, false);
final navObs = RouteObserverUtils().getObserver(ObserverType.navigator, false);
MaterialApp(navigatorObservers: [routeObs, navObs]);
```

## Using RouteAware in a Screen
Example: `HomeScreen`

Subscribe in `didChangeDependencies` and unsubscribe in `dispose`:

```dart
import 'package:flutter/widgets.dart';
import 'package:navigation/navigator/route_observer/route_observer_util.dart';

class HomeScreenState extends State<HomeScreen> with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final observer = RouteObserverUtils().getObserver(ObserverType.route);
    if (observer is RouteObserver<PageRoute<dynamic>>) {
      _routeObserver = observer;
      final route = ModalRoute.of(context);
      if (route is PageRoute<dynamic>) {
        _routeObserver!.subscribe(this, route);
      }
    }
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {}
  @override
  void didPop() {}
  @override
  void didPopNext() {}
  @override
  void didPushNext() {}
}
```

## Named Routes for Better Logs
To see meaningful screen names in logs, set `RouteSettings(name: 'ScreenName')` when pushing routes or use `Navigator.pushNamed` with an `onGenerateRoute` that assigns names.

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    settings: const RouteSettings(name: 'SettingsScreen'),
    builder: (_) => const SettingsScreen(),
  ),
);
```

## Logging
Use the top-level logger method for plain logs without ANSI colors:

```dart
import 'package:navigation/utils/logger.dart';

log('Navigator', 'didPush: /home');
```

## Troubleshooting
- If logs show `MaterialPageRoute<dynamic>` instead of screen names, ensure you set `RouteSettings(name: ...)` or use named routes.
- If RouteAware callbacks don’t fire, confirm the route observer instance is registered in `MaterialApp` and that your widget subscribes with a `PageRoute`.
- If you mix both observers, ensure you pass both instances to `navigatorObservers`.

## License
This repository is for demonstration purposes. Adapt as needed for your projects.

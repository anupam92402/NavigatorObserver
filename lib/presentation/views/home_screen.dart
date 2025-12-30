import 'package:flutter/material.dart';
import 'package:navigation/navigator/route_observer/route_observer_util.dart';
import 'package:navigation/presentation/views/profile_screen.dart';
import 'package:navigation/presentation/views/settings_screen.dart';
import 'package:navigation/presentation/views/tab_bar_screen.dart';

import 'bottom_nav_bar_screen.dart';
import 'bottom_sheet_screen.dart';
import 'multiple_route_aware_impl_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  /// Centralized plain logger for this class.
  void _log(String message) {
    print('[RouteAware][HomeScreen] $message');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Subscribe this screen to the shared RouteObserver.
    final observer = RouteObserverUtils().getObserver(ObserverType.route);
    if (observer is RouteObserver<PageRoute<dynamic>>) {
      _routeObserver = observer;
      final route = ModalRoute.of(context);
      if (route is PageRoute<dynamic>) {
        _routeObserver!.subscribe(this, route);
        _log(
          'Subscribed to RouteObserver for ${route.settings.name ?? 'unknown'}',
        );
      }
    }
  }

  @override
  void dispose() {
    /// Unsubscribe on dispose to avoid leaks.
    if (_routeObserver != null) {
      _routeObserver!.unsubscribe(this);
      _log('Unsubscribed from RouteObserver');
    }
    super.dispose();
  }

  @override
  void didPush() {
    _log('didPush');
  }

  @override
  void didPop() {
    _log('didPop');
  }

  @override
  void didPopNext() {
    _log('didPopNext (returned to this screen)');
  }

  @override
  void didPushNext() {
    _log('didPushNext (navigated away from this screen)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Home Screen', style: TextStyle(fontSize: 32))),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'SettingsScreen'),
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            child: Text('Navigate to Settings Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'ProfileScreen'),
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            child: Text('Navigate to Profile Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'BottomSheetScreen'),
                  builder: (context) => BottomSheetScreen(),
                ),
              );
            },
            child: Text('Open Bottom Sheet Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'BottomNavBarScreen'),
                  builder: (context) => BottomNavBarScreen(),
                ),
              );
            },
            child: Text('Open Bottom Navigation Bar screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'TabBarScreen'),
                  builder: (context) => TabBarScreen(),
                ),
              );
            },
            child: Text('Open Tab View Bar Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'MultipleRouteAwareImplScreen'),
                  builder: (context) => MultipleRouteAwareImplScreen(),
                ),
              );
            },
            child: Text('Navigate to Multiple Route Aware UseCase'),
          ),
        ],
      ),
    );
  }
}

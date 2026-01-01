import 'package:flutter/material.dart';

import '../../navigator/route_observer/route_observer.dart';
import '../../navigator/route_observer/route_observer_util.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen>
    with RouteAware {
  RouteObserver<ModalRoute<dynamic>>? _routeObserver;

  /// Centralized plain logger for this class.
  void _log(String message) {
    print('[RouteAware][BottomNavBarScreen] $message');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Subscribe this screen to the shared RouteObserver.
    final observer = RouteObserverUtils().getObserver(ObserverType.route);
    if (observer is RouteObserver<ModalRoute<dynamic>>) {
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

  int _currentIndex = 0;

  final List<Widget> _screens = const [HomeNavigator(), SearchNavigator()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          print("BottomNav Tab Switch Event→ Switched to tab index: $index");
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

//
// ---------------- TABS ----------------
//

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [CustomRouteObserver()],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: const RouteSettings(name: 'HomeRoot'),
          builder: (_) => const HomeTab(),
        );
      },
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Home Screen", style: TextStyle(fontSize: 24)),
    );
  }
}

class SearchNavigator extends StatelessWidget {
  const SearchNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [CustomRouteObserver()],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: const RouteSettings(name: 'SearchRoot'),
          builder: (_) => const SearchTab(),
        );
      },
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Search Screen", style: TextStyle(fontSize: 24)),
    );
  }
}

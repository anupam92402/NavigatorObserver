import 'package:flutter/material.dart';
import 'package:navigation/navigator/route_observer/route_observer_util.dart';
import 'package:navigation/presentation/views/settings_screen.dart';

import '../widgets/description_text_widget.dart';
import '../widgets/user_text_widget.dart';

class MultipleRouteAwareImplScreen extends StatefulWidget {
  const MultipleRouteAwareImplScreen({super.key});

  @override
  State<MultipleRouteAwareImplScreen> createState() =>
      _MultipleRouteAwareImplScreenState();
}

class _MultipleRouteAwareImplScreenState
    extends State<MultipleRouteAwareImplScreen>
    with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  /// Centralized plain logger for this class.
  void _log(String message) {
    print('[RouteAware][MultipleRouteAwareImplScreen] $message');
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
          Center(
            child: Text(
              'Multiple RouteAware Implementation Screen',
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          UserTextWidget(),
          DescriptionTextWidget(),
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
        ],
      ),
    );
  }
}



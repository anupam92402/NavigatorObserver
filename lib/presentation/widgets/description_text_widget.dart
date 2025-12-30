import 'package:flutter/material.dart';

import '../../navigator/route_observer/route_observer_util.dart';

class DescriptionTextWidget extends StatefulWidget {
  const DescriptionTextWidget({super.key});

  @override
  State<DescriptionTextWidget> createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget>
    with RouteAware {

  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  /// Centralized plain logger for this class.
  void _log(String message) {
    print('[RouteAware][DescriptionTextWidget] $message');
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
    return Text('Are you ready?', style: TextStyle(fontSize: 20));
  }
}

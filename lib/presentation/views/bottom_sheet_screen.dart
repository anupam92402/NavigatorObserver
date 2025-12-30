import 'package:flutter/material.dart';

import '../../navigator/route_observer/route_observer_util.dart';

class BottomSheetScreen extends StatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _routeObserver;

  /// Centralized plain logger for this class.
  void _log(String message) {
    print('[RouteAware][BottomSheetScreen] $message');
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
  void _openFirstBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const FirstBottomSheet(),
    );
  }

  void _openSecondBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SecondBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bottom Sheet Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _openFirstBottomSheet(context),
              child: const Text("Open First Bottom Sheet"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openSecondBottomSheet(context),
              child: const Text("Open Second Bottom Sheet"),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ---------------- FIRST BOTTOM SHEET ----------------
//

class FirstBottomSheet extends StatelessWidget {
  const FirstBottomSheet({super.key});

  void _openNestedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NestedBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------- AppBar Header --------
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "First Bottom Sheet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 48), // To balance the back button
            ],
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => _openNestedSheet(context),
            child: const Text("Open Another Sheet on Top"),
          ),
        ],
      ),
    );
  }
}

//
// ---------------- SECOND BOTTOM SHEET ----------------
//

class SecondBottomSheet extends StatelessWidget {
  const SecondBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------- AppBar Header --------
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "Second Bottom Sheet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            "This is a separate bottom sheet opened from the main screen.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//
// ---------------- NESTED BOTTOM SHEET ----------------
//

class NestedBottomSheet extends StatelessWidget {
  const NestedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------- AppBar Header --------
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "Nested Bottom Sheet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            "Opened on top of the first bottom sheet.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

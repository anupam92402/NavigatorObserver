import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Widget> _tabs = const [
    Tab(text: "Home", icon: Icon(Icons.home)),
    Tab(text: "Search", icon: Icon(Icons.search)),
    Tab(text: "Profile", icon: Icon(Icons.person)),
  ];

  final List<Widget> _views = const [
    HomeTab(),
    SearchTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab Bar Example"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: _views,
      ),
    );
  }
}

//
// ---------------- TAB SCREENS ----------------
//

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Home Tab",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Search Tab",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profile Tab",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

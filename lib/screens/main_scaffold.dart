import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'dashboard_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _PlaceholderTab(
        icon: Icons.home_rounded,
        title: 'Feed',
        description: 'Your personalized OJAS social feed.',
      ),
      const _PlaceholderTab(
        icon: Icons.play_circle_rounded,
        title: 'Shorts',
        description: 'Discover short-form videos and creators.',
      ),
      const _PlaceholderTab(
        icon: Icons.add_circle_rounded,
        title: 'Create & Live',
        description: 'Create posts and manage live broadcasts.',
      ),
      const DashboardScreen(),
      const _ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OJAS',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () {
              final brightness = Theme.of(context).brightness;
              context.read<ThemeController>().toggleBrightness(brightness);
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You are all caught up')),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline_rounded),
            selectedIcon: Icon(Icons.play_circle_rounded),
            label: 'Shorts',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        CircleAvatar(
          radius: 42,
          child: Icon(
            Icons.person_rounded,
            size: 42,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Your Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Choose the preferred OJAS appearance.'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (bool value) {
              themeController.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ),
      ],
    );
  }
}

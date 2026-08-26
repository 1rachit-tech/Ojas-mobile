import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _DashboardPage(onAction: _showMessage),
      const _SectionPage(
        icon: Icons.analytics_rounded,
        title: 'Analytics',
        description: 'Detailed audience and performance analytics.',
      ),
      const _SectionPage(
        icon: Icons.live_tv_rounded,
        title: 'Streams',
        description: 'Manage live and scheduled broadcasts.',
      ),
      const _SectionPage(
        icon: Icons.person_rounded,
        title: 'Profile',
        description: 'Manage your creator account and preferences.',
      ),
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
              widget.onThemeModeChanged(
                widget.themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showMessage('You are all caught up'),
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv_outlined),
            selectedIcon: Icon(Icons.live_tv_rounded),
            label: 'Streams',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showMessage('Create flow opened'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create'),
            )
          : null,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({required this.onAction});

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 600));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: <Widget>[
          const Text(
            'Good afternoon 👋',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text('Here is how your content is performing today.'),
          const SizedBox(height: 24),
          const _Heading('Overview', 'Last 30 days'),
          const SizedBox(height: 12),
          const _MetricsGrid(),
          const SizedBox(height: 28),
          const _Heading('Engagement', 'Updated live'),
          const SizedBox(height: 12),
          const _EngagementCard(),
          const SizedBox(height: 28),
          const _Heading('Live streams', 'Manage all'),
          const SizedBox(height: 12),
          _LiveCard(onAction: onAction),
          const SizedBox(height: 12),
          _ScheduledCard(onAction: onAction),
          const SizedBox(height: 28),
          const Text(
            'Quick actions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.video_call_rounded,
            title: 'Go Live',
            subtitle: 'Start streaming now',
            onAction: onAction,
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.add_photo_alternate_rounded,
            title: 'Upload',
            subtitle: 'Publish new content',
            onAction: onAction,
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.campaign_rounded,
            title: 'Promote',
            subtitle: 'Boost your reach',
            onAction: onAction,
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title, this.trailing);

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          trailing,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 650;
    return GridView.count(
      crossAxisCount: isWide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: isWide ? 1.0 : 1.25,
      children: const <Widget>[
        _Metric('Total Views', '128.4K', '+18.6%', Icons.visibility_rounded),
        _Metric('Watch Time', '2,846h', '+12.4%', Icons.schedule_rounded),
        _Metric(
          'New Followers',
          '4,892',
          '+8.2%',
          Icons.person_add_alt_1_rounded,
        ),
        _Metric('Engagement', '9.8%', '+1.7%', Icons.auto_graph_rounded),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.title, this.value, this.change, this.icon);

  final String title;
  final String value;
  final String change;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: scheme.primary),
            const Spacer(),
            Text(title),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            Text(
              change,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EngagementCard extends StatelessWidget {
  const _EngagementCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _MiniMetric('12.8K', 'Likes', Icons.favorite_rounded),
                _MiniMetric(
                  '3.4K',
                  'Comments',
                  Icons.mode_comment_rounded,
                ),
                _MiniMetric('1.9K', 'Shares', Icons.ios_share_rounded),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: <Widget>[
                Text(
                  'Audience activity',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Text(
                  'High',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(value: 0.82, minHeight: 10),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(label),
      ],
    );
  }
}

class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.onAction});

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.sensors_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text(
          'No stream is live',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: const Text(
          'Start a broadcast and connect with your audience.',
        ),
        trailing: FilledButton(
          onPressed: () => onAction('Live stream setup opened'),
          child: const Text('Go Live'),
        ),
      ),
    );
  }
}

class _ScheduledCard extends StatelessWidget {
  const _ScheduledCard({required this.onAction});

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event_available_rounded),
        title: const Text(
          'Creator session',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: const Text('Scheduled for tomorrow at 7:00 PM'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => onAction('Scheduled stream details opened'),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_rounded),
        onTap: () => onAction('$title opened'),
      ),
    );
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({
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
        ),
      ),
    );
  }
}

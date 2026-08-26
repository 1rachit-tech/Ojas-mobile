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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _dashboard(),
      const _EmptyPage(icon: Icons.analytics_rounded, title: 'Analytics'),
      const _EmptyPage(icon: Icons.live_tv_rounded, title: 'Streams'),
      const _EmptyPage(icon: Icons.person_rounded, title: 'Profile'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('OJAS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => widget.onThemeModeChanged(
              widget.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
            ),
            icon: Icon(widget.themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are all caught up'))),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics_rounded), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.live_tv_outlined), selectedIcon: Icon(Icons.live_tv_rounded), label: 'Streams'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
      floatingActionButton: _index == 0 ? FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create flow opened'))),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ) : null,
    );
  }

  Widget _dashboard() {
    return RefreshIndicator(
      onRefresh: () async => Future<void>.delayed(const Duration(milliseconds: 600)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: const [
          Text('Good afternoon 👋', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          SizedBox(height: 6),
          Text('Here is how your content is performing today.'),
          SizedBox(height: 24),
          _Heading('Overview', 'Last 30 days'),
          SizedBox(height: 12),
          _MetricsGrid(),
          SizedBox(height: 28),
          _Heading('Engagement', 'Updated live'),
          SizedBox(height: 12),
          _EngagementCard(),
          SizedBox(height: 28),
          _Heading('Live streams', 'Manage all'),
          SizedBox(height: 12),
          _LiveCard(),
          SizedBox(height: 12),
          _ScheduledCard(),
          SizedBox(height: 28),
          Text('Quick actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          SizedBox(height: 12),
          _ActionCard(icon: Icons.video_call_rounded, title: 'Go Live', subtitle: 'Start streaming now'),
          SizedBox(height: 12),
          _ActionCard(icon: Icons.add_photo_alternate_rounded, title: 'Upload', subtitle: 'Publish new content'),
          SizedBox(height: 12),
          _ActionCard(icon: Icons.campaign_rounded, title: 'Promote', subtitle: 'Boost your reach'),
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
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
    Text(trailing, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
  ]);
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();
  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: MediaQuery.sizeOf(context).width >= 650 ? 4 : 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 1.25,
    children: const [
      _Metric('Total Views', '128.4K', '+18.6%', Icons.visibility_rounded),
      _Metric('Watch Time', '2,846h', '+12.4%', Icons.schedule_rounded),
      _Metric('New Followers', '4,892', '+8.2%', Icons.person_add_alt_1_rounded),
      _Metric('Engagement', '9.8%', '+1.7%', Icons.auto_graph_rounded),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric(this.title, this.value, this.change, this.icon);
  final String title, value, change;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: scheme.primary), const Spacer(), Text(title), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), Text(change, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
    ])));
  }
}

class _EngagementCard extends StatelessWidget {
  const _EngagementCard();
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
    const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_MiniMetric('12.8K', 'Likes', Icons.favorite_rounded), _MiniMetric('3.4K', 'Comments', Icons.mode_comment_rounded), _MiniMetric('1.9K', 'Shares', Icons.ios_share_rounded)]),
    const SizedBox(height: 24), const Row(children: [Text('Audience activity', style: TextStyle(fontWeight: FontWeight.w800)), Spacer(), Text('High', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700))]),
    const SizedBox(height: 12), const LinearProgressIndicator(value: .82, minHeight: 10),
  ])));
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric(this.value, this.label, this.icon);
  final String value, label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w800)), Text(label)]);
}

class _LiveCard extends StatelessWidget {
  const _LiveCard();
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
    leading: Icon(Icons.sensors_rounded, color: Theme.of(context).colorScheme.primary),
    title: const Text('No stream is live', style: TextStyle(fontWeight: FontWeight.w800)),
    subtitle: const Text('Start a broadcast and connect with your audience.'),
    trailing: FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live stream setup opened'))), child: const Text('Go Live')),
  ));
}

class _ScheduledCard extends StatelessWidget {
  const _ScheduledCard();
  @override
  Widget build(BuildContext context) => const Card(child: ListTile(leading: Icon(Icons.event_available_rounded), title: Text('Creator session', style: TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('Scheduled for tomorrow at 7:00 PM'), trailing: Icon(Icons.chevron_right_rounded)));
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_rounded),
    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title opened'))),
  ));
}

class _EmptyPage extends StatelessWidget {
  const _EmptyPage({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('This section is ready for the next implementation phase.') ]));
}

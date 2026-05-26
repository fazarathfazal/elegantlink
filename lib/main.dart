import 'package:flutter/material.dart';

// Brand colours — use these named constants throughout the code
const Color kBrandBlue    = Color(0xFF1F3864); // primary brand colour
const Color kBrandLight   = Color(0xFF2E5C8A); // secondary / AppBar
const Color kStatusGreen  = Color(0xFF388E3C); // complete / approved
const Color kStatusAmber  = Color(0xFFF9A825); // in progress / at risk
const Color kStatusRed    = Color(0xFFD32F2F); // blocked
const Color kStatusGrey   = Color(0xFF9E9E9E); // pending / read
const Color kSurface      = Color(0xFFF7FBFF); // background surface

void main() {
  runApp(const ElegantLinkApp());
}

/// The root widget of the ElegantLink application.
/// It configures the Material3 theme and sets the initial screen.
class ElegantLinkApp extends StatelessWidget {
  const ElegantLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElegantLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrandBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: kSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBrandLight,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

/// LoginScreen simulates authentication for the portal.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: Center(
        // Wrap in SingleChildScrollView to prevent overflow when keyboard appears
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Placeholder using Icons.link in brand color
              const Icon(
                Icons.link,
                size: 64,
                color: kBrandBlue,
              ),
              const SizedBox(height: 16),
              Text(
                'ElegantLink',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: kBrandBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Project Transparency Portal',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kStatusGrey,
                    ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  // Navigate to DashboardScreen, replace the current route
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// DashboardScreen is the main portal page displaying active projects and SDLC phase cards.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Navigation helper for the NavigationBar tabs across the app
  void _onTabTapped(int index) {
    if (index == 0) {
      // Already on Dashboard
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const ProjectsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const NotificationsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Active Project',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kBrandBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          ProjectStatusCard(
            projectName: 'Elegant Shop App',
            overallStatus: 'on_track',
            completionPercent: 65,
            nextMilestone: 'Core UI Screens',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhaseDetailScreen(
                    phaseName: 'Development Phase',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'SDLC Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kBrandBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          PhaseCard(
            phaseName: 'Discovery',
            status: 'complete',
            completionPercent: 100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhaseDetailScreen(
                    phaseName: 'Discovery Phase',
                  ),
                ),
              );
            },
          ),
          PhaseCard(
            phaseName: 'Design',
            status: 'complete',
            completionPercent: 100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhaseDetailScreen(
                    phaseName: 'Design Phase',
                  ),
                ),
              );
            },
          ),
          PhaseCard(
            phaseName: 'Development',
            status: 'in_progress',
            completionPercent: 65,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhaseDetailScreen(
                    phaseName: 'Development Phase',
                  ),
                ),
              );
            },
          ),
          PhaseCard(
            phaseName: 'UAT',
            status: 'pending',
            completionPercent: 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhaseDetailScreen(
                    phaseName: 'UAT Phase',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

/// ProjectsScreen displays all projects the client is involved in.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const DashboardScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      // Already on Projects
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const NotificationsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Project 1: Elegant Shop App (Active)
          Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: kBrandBlue,
                foregroundColor: Colors.white,
                child: Text('ES'),
              ),
              title: const Text(
                'Elegant Shop App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Development Phase — 65% complete'),
              trailing: const Icon(Icons.chevron_right, color: kBrandLight),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
            ),
          ),
          // Project 2: Marketing Website (Completed)
          Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade100, // Visual cue for completed/inactive status
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              enabled: false, // Disables tapping
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.white,
                child: const Text('MW'),
              ),
              title: Text(
                'Marketing Website',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              subtitle: Text(
                'Launched 12 Jan 2025',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              trailing: const StatusChip(
                status: 'complete',
                label: 'Completed',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

/// NotificationsScreen displays recent push notifications the client has received.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const DashboardScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const ProjectsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      // Already on Notifications
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        // Explicit back button if opened from bell icon on DashboardScreen
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: ListView(
        children: [
          NotificationTile(
            title: 'Milestone Ready for Review',
            body: 'Core UI Screens is ready for your approval.',
            time: 'Today, 9:14 AM',
            isUnread: true,
          ),
          NotificationTile(
            title: 'New Mockup Uploaded',
            body: 'James R. uploaded Login Screen v3 for your review.',
            time: 'Today, 8:50 AM',
            isUnread: true,
          ),
          NotificationTile(
            title: 'Phase Status Updated',
            body: 'Development phase is now 65% complete.',
            time: 'Yesterday, 4:30 PM',
            isUnread: false,
          ),
          NotificationTile(
            title: 'Comment Reply',
            body: 'James R. replied to your comment on the Login mockup.',
            time: 'Yesterday, 2:10 PM',
            isUnread: false,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

/// A small rounded chip showing a status label with matching color.
class StatusChip extends StatelessWidget {
  final String status;
  final String label;

  const StatusChip({
    super.key,
    required this.status,
    required this.label,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'on_track':
      case 'complete':
      case 'approved':
        return kStatusGreen;
      case 'at_risk':
      case 'in_progress':
      case 'ready_for_review':
        return kStatusAmber;
      case 'blocked':
        return kStatusRed;
      case 'pending':
      case 'read':
      default:
        return kStatusGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    // Uses 15% opacity background for readability and modern M3 chip look
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// A Card widget showing the overall project health at a glance.
class ProjectStatusCard extends StatelessWidget {
  final String projectName;
  final String overallStatus;
  final int completionPercent;
  final String nextMilestone;
  final VoidCallback onTap;

  const ProjectStatusCard({
    super.key,
    required this.projectName,
    required this.overallStatus,
    required this.completionPercent,
    required this.nextMilestone,
    required this.onTap,
  });

  String _getStatusLabel() {
    switch (overallStatus) {
      case 'on_track':
        return 'On Track';
      case 'at_risk':
        return 'At Risk';
      case 'blocked':
        return 'Blocked';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Stack elements vertically with clear gap constraints
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: kBrandBlue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Progress indicator on the right side of the card
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: completionPercent / 100,
                        backgroundColor: Colors.grey.shade200,
                        color: kBrandLight,
                        strokeWidth: 6,
                      ),
                      Text(
                        '$completionPercent%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Next milestone: $nextMilestone',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kStatusGrey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A Card widget for each SDLC phase shown on the dashboard.
class PhaseCard extends StatelessWidget {
  final String phaseName;
  final String status;
  final int completionPercent;
  final VoidCallback onTap;

  const PhaseCard({
    super.key,
    required this.phaseName,
    required this.status,
    required this.completionPercent,
    required this.onTap,
  });

  Color _getStatusDotColor() {
    switch (status) {
      case 'complete':
        return Colors.green.shade600;
      case 'in_progress':
        return Colors.amber.shade700;
      case 'pending':
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = _getStatusDotColor();
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      phaseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Text(
                    '$completionPercent%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kBrandLight,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: completionPercent / 100,
                backgroundColor: Colors.grey.shade200,
                color: dotColor,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A ListTile inside a Card for each milestone.
class MilestoneListTile extends StatelessWidget {
  final String milestoneName;
  final String status;
  final VoidCallback onTap;

  const MilestoneListTile({
    super.key,
    required this.milestoneName,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData leadingIcon;
    Color iconColor;
    String statusLabel;

    switch (status) {
      case 'approved':
        leadingIcon = Icons.check_circle;
        iconColor = kStatusGreen;
        statusLabel = 'Approved';
        break;
      case 'ready_for_review':
        leadingIcon = Icons.rate_review;
        iconColor = kStatusAmber;
        statusLabel = 'Ready for Review';
        break;
      case 'in_progress':
      default:
        leadingIcon = Icons.timelapse;
        iconColor = Colors.blue;
        statusLabel = 'In Progress';
        break;
    }

    final isTappable = status == 'ready_for_review';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: isTappable ? onTap : null,
        leading: Icon(leadingIcon, color: iconColor),
        title: Text(
          milestoneName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isTappable ? Colors.black : Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusLabel,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (isTappable) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16, color: kStatusAmber),
            ],
          ],
        ),
      ),
    );
  }
}

/// A custom widget for a single comment in a comment thread.
class CommentTile extends StatelessWidget {
  final String authorName;
  final String commentText;
  final String timeAgo;

  const CommentTile({
    super.key,
    required this.authorName,
    required this.commentText,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    // Generate initials for the author avatar
    final initials = authorName.isNotEmpty
        ? authorName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kBrandLight.withOpacity(0.2),
                foregroundColor: kBrandBlue,
                radius: 18,
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kStatusGrey,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Text(
              commentText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

/// A ListTile for each notification.
class NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: Icon(
        Icons.notifications,
        color: isUnread ? kBrandLight : kStatusGrey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(body),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: kStatusGrey,
            ),
      ),
    );

    if (isUnread) {
      // Wraps in a container to show unread status with a distinct left brand border
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: kBrandLight, width: 3),
          ),
        ),
        child: tile,
      );
    }

    return tile;
  }
}

/// PhaseDetailScreen displays the detailed timeline, ownership and milestone checklist of a specific SDLC phase.
class PhaseDetailScreen extends StatelessWidget {
  final String phaseName;

  const PhaseDetailScreen({
    super.key,
    required this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    // Determine info based on the selected phase for a realistic walkthrough
    String status = 'pending';
    String statusLabel = 'Pending';
    String startDate = 'TBD';
    String endDate = 'TBD';
    String completion = '0%';
    String owner = 'James R. — Elegant Media';
    List<Map<String, String>> milestones = [];

    if (phaseName.contains('Discovery')) {
      status = 'complete';
      statusLabel = 'Complete';
      startDate = '10 Mar 2025';
      endDate = '25 Mar 2025';
      completion = '100%';
      owner = 'Sarah P. — Elegant Media';
      milestones = [
        {'name': 'Requirements Gathering', 'status': 'approved'},
        {'name': 'Scope Definition', 'status': 'approved'},
      ];
    } else if (phaseName.contains('Design')) {
      status = 'complete';
      statusLabel = 'Complete';
      startDate = '1 Apr 2025';
      endDate = '30 Apr 2025';
      completion = '100%';
      owner = 'Alex D. — Elegant Media';
      milestones = [
        {'name': 'Wireframes Approved', 'status': 'approved'},
        {'name': 'High-Fidelity Mockups', 'status': 'approved'},
      ];
    } else if (phaseName.contains('Development')) {
      status = 'in_progress';
      statusLabel = 'In Progress';
      startDate = '12 May 2025';
      endDate = '30 Jun 2025';
      completion = '65%';
      owner = 'James R. — Elegant Media';
      milestones = [
        {'name': 'API Integration', 'status': 'approved'},
        {'name': 'Core UI Screens', 'status': 'ready_for_review'},
        {'name': 'Push Notifications', 'status': 'in_progress'},
      ];
    } else if (phaseName.contains('UAT')) {
      status = 'pending';
      statusLabel = 'Pending';
      startDate = '1 Jul 2025';
      endDate = '20 Jul 2025';
      completion = '0%';
      owner = 'James R. — Elegant Media';
      milestones = [
        {'name': 'User Sign-Off', 'status': 'in_progress'},
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(phaseName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Chip at top showing current status
            Center(
              child: StatusChip(status: status, label: statusLabel),
            ),
            const SizedBox(height: 24),
            Text(
              'Phase Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: kBrandLight),
                    title: const Text('Start Date'),
                    trailing: Text(
                      startDate,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.event, color: kBrandLight),
                    title: const Text('Target End Date'),
                    trailing: Text(
                      endDate,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.percent, color: kBrandLight),
                    title: const Text('Completion'),
                    trailing: Text(
                      completion,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person, color: kBrandLight),
                    title: const Text('Owner'),
                    trailing: Text(
                      owner,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Milestones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (milestones.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No milestones defined for this phase.'),
                ),
              )
            else
              ...milestones.map((m) {
                return MilestoneListTile(
                  milestoneName: m['name']!,
                  status: m['status']!,
                  onTap: () {
                    if (m['status'] == 'ready_for_review') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MilestoneSummaryScreen(),
                        ),
                      );
                    }
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}

/// MilestoneSummaryScreen lets the user review completed deliverables and decide to approve or request changes.
class MilestoneSummaryScreen extends StatefulWidget {
  const MilestoneSummaryScreen({super.key});

  @override
  State<MilestoneSummaryScreen> createState() => _MilestoneSummaryScreenState();
}

class _MilestoneSummaryScreenState extends State<MilestoneSummaryScreen> {
  // Helper to show the confirmation dialog
  void _showApprovalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Milestone Approval'),
          content: const Text(
            'Approving this milestone will mark it as complete and notify your Project Manager. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MilestoneApprovedScreen(),
                  ),
                );
              },
              child: const Text('Yes, Approve'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestone Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Milestone Details Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Core UI Screens',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kBrandBlue,
                          ),
                        ),
                        StatusChip(
                          status: 'ready_for_review',
                          label: 'Ready for Review',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Submitted by:', style: TextStyle(color: kStatusGrey)),
                        Text('James R.', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Submitted on:', style: TextStyle(color: kStatusGrey)),
                        Text('18 Jun 2025', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Deliverables Completed',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Deliverables Checklist
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: true,
                    onChanged: null, // Hardcoded disabled checked state
                    title: const Text('Login and authentication screens'),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: const Text('Dashboard and phase overview screens'),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: const Text('Milestone review and approval screens'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Attached Files',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Attachment files. Tapping Mockup_Preview.png goes to mockup viewer.
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text('UI_Screens_v2.pdf'),
                    subtitle: Text('2.4 MB'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.image, color: Colors.blue),
                    title: const Text('Mockup_Preview.png'),
                    subtitle: const Text('1.8 MB • Tap to review & comment'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MockupViewerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Bottom Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RequestChangesScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: kStatusRed),
                      foregroundColor: kStatusRed,
                    ),
                    child: const Text('Request Changes'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _showApprovalDialog,
                    style: FilledButton.styleFrom(
                      backgroundColor: kStatusGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Approve Milestone'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// MilestoneApprovedScreen displays a gorgeous success verification after milestone sign-off.
class MilestoneApprovedScreen extends StatelessWidget {
  const MilestoneApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestone Approved'),
        automaticallyImplyLeading: false, // Prevent navigation back
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: kStatusGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Milestone Approved!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kBrandBlue,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Core UI Screens has been approved. James R. has been notified and the next development phase will begin shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kStatusGrey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Navigate back to Dashboard and clear routing stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Return to Dashboard'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// RequestChangesScreen captures student/client feedback to send to the project manager.
class RequestChangesScreen extends StatefulWidget {
  const RequestChangesScreen({super.key});

  @override
  State<RequestChangesScreen> createState() => _RequestChangesScreenState();
}

class _RequestChangesScreenState extends State<RequestChangesScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the changes needed before submitting.'),
          backgroundColor: kStatusRed,
        ),
      );
      return;
    }

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change request sent to James R.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to DashboardScreen and clear the stack to maintain fresh portal state
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Changes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Milestone Info Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Milestone: Core UI Screens',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kBrandBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Describe the changes needed',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Your feedback will be sent to the Project Manager.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: kStatusGrey,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _feedbackController,
                maxLines: null, // Makes the TextField expand vertically
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'e.g. The login screen button colour needs to match our brand...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitRequest,
              style: FilledButton.styleFrom(
                backgroundColor: kStatusRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}

/// MockupViewerScreen allows client feedback, annotations, and comments directly on design assets.
class MockupViewerScreen extends StatefulWidget {
  const MockupViewerScreen({super.key});

  @override
  State<MockupViewerScreen> createState() => _MockupViewerScreenState();
}

class _MockupViewerScreenState extends State<MockupViewerScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _comments = [
    {
      'author': 'James R.',
      'text': 'The logo placement here looks good. Can you confirm the font size for the tagline?',
      'time': '2 hours ago',
    },
    {
      'author': 'Fred M.',
      'text': 'I think the button should be darker to match our brand. See the style guide.',
      'time': '1 hour ago',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _postComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add({
        'author': 'Fred M.', // Current logged in user as per specs
        'text': text,
        'time': 'Just now',
      });
    });

    _commentController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment posted'),
      ),
    );

    // Scroll to the end of the comments list to show the newly added comment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mockup Review'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Design mockup placeholder
            Card(
              elevation: 1,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 220,
                color: Colors.blueGrey.shade100,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 64,
                      color: Colors.blueGrey.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'UI Mockup — Login Screen v3',
                      style: TextStyle(
                        color: Colors.blueGrey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kBrandBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_comments.length} comments',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kStatusGrey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Comments thread list
            ..._comments.map((c) {
              return CommentTile(
                authorName: c['author']!,
                commentText: c['text']!,
                timeAgo: c['time']!,
              );
            }),
            const SizedBox(height: 16),
            Text(
              'Add a comment',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: kBrandBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your feedback...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _postComment,
                child: const Text('Post Comment'),
              ),
            ),
            const SizedBox(height: 48), // Padding at bottom to avoid keyboard overlap
          ],
        ),
      ),
      // FAB to scroll to comment input and focus it
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _commentFocusNode.requestFocus();
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        tooltip: 'Add Comment',
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}



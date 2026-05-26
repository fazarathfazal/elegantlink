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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
      ),
      body: const Center(
        child: Text('Dashboard placeholder'),
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
                        const SizedBox(height: 8),
                        StatusChip(
                          status: overallStatus,
                          label: _getStatusLabel(),
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
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
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


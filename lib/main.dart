import 'package:flutter/material.dart';

// Brand colours — use these named constants throughout the code
const Color kBrandBlue    = Color(0xFF1F3864); // primary brand colour
const Color kBrandLight   = Color(0xFF2E5C8A); // secondary / AppBar
const Color kStatusGreen  = Color(0xFF388E3C); // complete / approved
const Color kStatusAmber  = Color(0xFFF9A825); // in progress / at risk
const Color kStatusRed    = Color(0xFFD32F2F); // blocked
const Color kStatusGrey   = Color(0xFF9E9E9E); // pending / read
const Color kSurface      = Color(0xFFF7FBFF); // background surface

/// Item representing a push notification.
class NotificationItem {
  final String title;
  final String body;
  final String time;
  bool isUnread;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });
}

void main() {
  runApp(const ElegantLinkAppState(child: ElegantLinkApp()));
}

/// A stateful wrapper that hosts the global app state.
class ElegantLinkAppState extends StatefulWidget {
  final Widget child;
  const ElegantLinkAppState({super.key, required this.child});

  @override
  State<ElegantLinkAppState> createState() => ElegantLinkAppStateState();
}

class ElegantLinkAppStateState extends State<ElegantLinkAppState> {
  int completionPercent = 65;
  String milestoneStatus = 'ready_for_review'; // 'ready_for_review' or 'approved'
  
  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    notifications = [
      NotificationItem(
        title: 'Milestone Ready for Review',
        body: 'Core UI Screens is ready for your approval.',
        time: 'Today, 9:14 AM',
        isUnread: true,
      ),
      NotificationItem(
        title: 'New Mockup Uploaded',
        body: 'James R. uploaded Login Screen v3 for your review.',
        time: 'Today, 8:50 AM',
        isUnread: true,
      ),
      NotificationItem(
        title: 'Phase Status Updated',
        body: 'Development phase is now 65% complete.',
        time: 'Yesterday, 4:30 PM',
        isUnread: false,
      ),
      NotificationItem(
        title: 'Comment Reply',
        body: 'James R. replied to your comment on the Login mockup.',
        time: 'Yesterday, 2:10 PM',
        isUnread: false,
      ),
    ];
  }

  void markNotificationAsRead(int index) {
    setState(() {
      notifications[index].isUnread = false;
    });
  }

  int get unreadNotificationsCount {
    return notifications.where((n) => n.isUnread).length;
  }

  void approveCoreMilestone() {
    setState(() {
      milestoneStatus = 'approved';
      completionPercent = 80; // Project updates completion dynamically when approved
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: this,
      child: widget.child,
    );
  }
}

/// InheritedWidget that provides the ElegantLinkAppStateState down the tree.
class AppStateProvider extends InheritedWidget {
  final ElegantLinkAppStateState state;

  const AppStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static ElegantLinkAppStateState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => true;
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

/// Helper function to create a slide transition (from right to left) for page routing.
Route<T> createSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

/// LoginScreen simulates authentication for the portal.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    // Validate form before navigating
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    }
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
      ),
    );
  }
}

/// DashboardScreen is the main portal page displaying active projects and progress cards.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final unreadCount = state.unreadNotificationsCount;

    // Determine the AppBar Title and Actions based on active index
    String titleText = 'My Projects';
    List<Widget> actionsList = [];

    if (_currentIndex == 1) {
      titleText = 'Projects';
    } else if (_currentIndex == 2) {
      titleText = 'Notifications';
    } else {
      actionsList = [
        IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text('$unreadCount'),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () {
            // Smoothly scrolls/transitions directly to the notifications page view
            _pageController.animateToPage(
              2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: actionsList,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Tab 0: Dashboard Content
          _buildDashboardContent(context),
          // Tab 1: Projects List
          const ProjectsScreen(isNested: true),
          // Tab 2: Notifications List
          const NotificationsScreen(isNested: true),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isApproved = state.milestoneStatus == 'approved';

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ProjectStatusCard(
          projectName: 'Elegant Shop App',
          overallStatus: 'on_track',
          completionPercent: state.completionPercent,
          nextMilestone: isApproved ? 'UAT Sign-off' : 'Core UI Screens',
          onTap: () {
            Navigator.push(
              context,
              createSlideRoute(
                const PhaseDetailScreen(
                  phaseName: 'Development Phase',
                ),
              ),
            );
          },
          phases: [
            PhaseCard(
              phaseName: 'Discovery',
              status: 'complete',
              completionPercent: 100,
              flat: true,
              onTap: () {
                Navigator.push(
                  context,
                  createSlideRoute(
                    const PhaseDetailScreen(
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
              flat: true,
              onTap: () {
                Navigator.push(
                  context,
                  createSlideRoute(
                    const PhaseDetailScreen(
                      phaseName: 'Design Phase',
                    ),
                  ),
                );
              },
            ),
            PhaseCard(
              phaseName: 'Development',
              status: isApproved ? 'complete' : 'in_progress',
              completionPercent: isApproved ? 100 : state.completionPercent,
              flat: true,
              onTap: () {
                Navigator.push(
                  context,
                  createSlideRoute(
                    const PhaseDetailScreen(
                      phaseName: 'Development Phase',
                    ),
                  ),
                );
              },
            ),
            PhaseCard(
              phaseName: 'UAT',
              status: isApproved ? 'in_progress' : 'pending',
              completionPercent: isApproved ? 10 : 0,
              flat: true,
              onTap: () {
                Navigator.push(
                  context,
                  createSlideRoute(
                    const PhaseDetailScreen(
                      phaseName: 'UAT Phase',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// ProjectsScreen displays all projects the client is involved in.
class ProjectsScreen extends StatefulWidget {
  final bool isNested;
  const ProjectsScreen({super.key, this.isNested = false});

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
    final appState = AppStateProvider.of(context);
    final bodyContent = ListView(
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
            subtitle: Text('Development Phase — ${appState.completionPercent}% complete'),
            trailing: const Icon(Icons.chevron_right, color: kBrandLight),
            onTap: () {
              if (widget.isNested) {
                // Instantly navigate back to the Dashboard tab view using the PageController
                final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                if (dashboardState != null) {
                  dashboardState._onTabTapped(0);
                }
              } else {
                Navigator.pushReplacement(
                  context,
                  createSlideRoute(const DashboardScreen()),
                );
              }
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
    );

    if (widget.isNested) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: bodyContent,
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
  final bool isNested;
  const NotificationsScreen({super.key, this.isNested = false});

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
    final state = AppStateProvider.of(context);
    final listContent = ListView.builder(
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final item = state.notifications[index];
        return NotificationTile(
          title: item.title,
          body: item.body,
          time: item.time,
          isUnread: item.isUnread,
          onTap: () {
            // Mark notification as read dynamically
            state.markNotificationAsRead(index);

            // Determine routing targets based on title
            Widget targetPage;
            if (item.title.contains('Milestone')) {
              targetPage = const MilestoneSummaryScreen();
            } else if (item.title.contains('Mockup') || item.title.contains('Reply')) {
              targetPage = const MockupViewerScreen();
            } else {
              targetPage = const PhaseDetailScreen(phaseName: 'Development Phase');
            }

            Navigator.push(
              context,
              createSlideRoute(targetPage),
            );
          },
        );
      },
    );

    if (widget.isNested) {
      return listContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: listContent,
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
  final List<Widget> phases;
  final VoidCallback onTap;

  const ProjectStatusCard({
    super.key,
    required this.projectName,
    required this.overallStatus,
    required this.completionPercent,
    required this.nextMilestone,
    required this.phases,
    required this.onTap,
  });



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
                'Progress',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: kBrandBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...phases,
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

/// A Card widget for each phase shown on the dashboard.
class PhaseCard extends StatelessWidget {
  final String phaseName;
  final String status;
  final int completionPercent;
  final bool flat;
  final VoidCallback onTap;

  const PhaseCard({
    super.key,
    required this.phaseName,
    required this.status,
    required this.completionPercent,
    this.flat = false,
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
    final childContent = Padding(
      padding: EdgeInsets.all(flat ? 8.0 : 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  phaseName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: completionPercent / 100,
            backgroundColor: Colors.grey.shade200,
            color: dotColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );

    if (flat) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: childContent,
      );
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: childContent,
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
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      onTap: onTap,
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

/// PhaseDetailScreen displays the detailed timeline, ownership and milestone checklist of a specific project phase.
class PhaseDetailScreen extends StatelessWidget {
  final String phaseName;

  const PhaseDetailScreen({
    super.key,
    required this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isApproved = appState.milestoneStatus == 'approved';

    String startDate = 'TBD';
    String endDate = 'TBD';
    String completion = '0%';
    String owner = 'James R. — Elegant Media';
    List<Map<String, String>> milestones = [];

    if (phaseName.contains('Discovery')) {
      startDate = '10 Mar 2025';
      endDate = '25 Mar 2025';
      completion = '100%';
      owner = 'Sarah P. — Elegant Media';
      milestones = [
        {'name': 'Requirements Gathering', 'status': 'approved'},
        {'name': 'Scope Definition', 'status': 'approved'},
      ];
    } else if (phaseName.contains('Design')) {
      startDate = '1 Apr 2025';
      endDate = '30 Apr 2025';
      completion = '100%';
      owner = 'Alex D. — Elegant Media';
      milestones = [
        {'name': 'Wireframes Approved', 'status': 'approved'},
        {'name': 'High-Fidelity Mockups', 'status': 'approved'},
      ];
    } else if (phaseName.contains('Development')) {
      startDate = '12 May 2025';
      endDate = '30 Jun 2025';
      completion = isApproved ? '100%' : '${appState.completionPercent}%';
      owner = 'James R. — Elegant Media';
      milestones = [
        {'name': 'API Integration', 'status': 'approved'},
        {'name': 'Core UI Screens', 'status': appState.milestoneStatus},
        {'name': 'Push Notifications', 'status': 'in_progress'},
      ];
    } else if (phaseName.contains('UAT')) {
      startDate = '1 Jul 2025';
      endDate = '20 Jul 2025';
      completion = isApproved ? '10%' : '0%';
      owner = 'James R. — Elegant Media';
      milestones = [
        {'name': 'User Sign-Off', 'status': isApproved ? 'in_progress' : 'pending'},
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
                        createSlideRoute(const MilestoneSummaryScreen()),
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
          // A3 usability finding: participants (P2) were unsure whether approval
          // had a financial consequence. Dialog now explicitly states the
          // payment implication to satisfy Nielsen's error-prevention heuristic.
          content: const Text(
            'Approving this milestone confirms that Core UI Screens meet your requirements and will release the next payment instalment to Elegant Media. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                // Trigger global state updates
                AppStateProvider.of(context).approveCoreMilestone();
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  createSlideRoute(const MilestoneApprovedScreen()),
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
                      children: [
                        const Text(
                          'Core UI Screens',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kBrandBlue,
                          ),
                        ),
                        StatusChip(
                          status: AppStateProvider.of(context).milestoneStatus,
                          label: AppStateProvider.of(context).milestoneStatus == 'approved' ? 'Approved' : 'Ready for Review',
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
                        createSlideRoute(const MockupViewerScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Bottom Action buttons
            AppStateProvider.of(context).milestoneStatus == 'approved'
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: StatusChip(status: 'approved', label: 'Milestone Approved & Confirmed'),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              createSlideRoute(const RequestChangesScreen()),
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

/// MilestoneApprovedScreen displays a success screen after milestone sign-off.
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
              // A3 usability finding (Rec. 4): P2 briefly hesitated on this screen
              // because the back arrow is hidden. This caption explains why and
              // guides users to the only available exit action, consistent with
              // Material3 confirmation screen patterns.
              const Text(
                'Your approval has been recorded. Use the button below to return to your project dashboard.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kBrandBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
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

/// RequestChangesScreen captures user feedback to send to the project manager.
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

    // Navigate back to DashboardScreen and clear the stack
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



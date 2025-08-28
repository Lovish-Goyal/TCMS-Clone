import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/features/teachers/model/teachers_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../router.dart';
import '../providers/profile_provider.dart';

Drawer teacherDrawer(BuildContext context, WidgetRef ref) {
  final teacherAsync = ref.watch(teacherProfileProvider);
  return Drawer(
    width: 280,
    child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header Section
              teacherAsync.when(
                data: (teacher) {
                  if (teacher == null) return const Text('No teacher data');
                  return _buildModernHeader(context, teacher);
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),

              // Navigation Items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Main Navigation Section
                      _buildSectionHeader('MAIN'),
                      _buildModernDrawerItem(
                        icon: Icons.dashboard_outlined,
                        activeIcon: Icons.dashboard,
                        title: 'Dashboard',
                        onTap: () => Navigator.pop(context),
                        isActive: true,
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.people_outline,
                        activeIcon: Icons.people,
                        title: 'Manage Students',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.activeStudentsList.name);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.school_outlined,
                        activeIcon: Icons.school,
                        title: 'Manage Classes',
                        onTap: () {
                          Navigator.pop(context);
                          // context.go('/class-management');
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.book_outlined,
                        activeIcon: Icons.book,
                        title: 'Manage Courses',
                        onTap: () {
                          Navigator.pop(context);
                          // context.go('/course-management');
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.assignment_outlined,
                        activeIcon: Icons.assignment,
                        title: 'Tests & Assignments',
                        onTap: () {
                          Navigator.pop(context);
                          // context.go('/test-management');
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.analytics_outlined,
                        activeIcon: Icons.analytics,
                        title: 'Reports & Analytics',
                        onTap: () {
                          Navigator.pop(context);
                          // context.go('/analytics');
                        },
                      ),

                      const SizedBox(height: 16),

                      // Management Section
                      _buildSectionHeader('MANAGEMENT'),
                      _buildModernDrawerItem(
                        icon: Icons.subscriptions_outlined,
                        activeIcon: Icons.subscriptions,
                        title: 'Subscription',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.subscriptionPlans.name);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.notifications_outlined,
                        activeIcon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.pop(context);
                          context.push(AppRoute.notifications.path);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.setting.path);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Support Section
                      _buildSectionHeader('SUPPORT'),
                      _buildModernDrawerItem(
                        icon: Icons.help_outline,
                        activeIcon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.help.path);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.info_outline,
                        activeIcon: Icons.info,
                        title: 'About',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.about.path);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.card_giftcard_outlined,
                        activeIcon: Icons.card_giftcard,
                        title: 'Referral Code',
                        onTap: () {
                          Navigator.pop(context);
                          // context.push(AppRoute.referral.path);
                        },
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.apps_outlined,
                        activeIcon: Icons.apps,
                        title: 'Other Apps',
                        onTap: () async {
                          Navigator.pop(context);
                          const url =
                              'https://play.google.com/store/apps/dev?id=5700313618786177705&hl=en_IN';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Logout Section
                      _buildModernDrawerItem(
                        icon: Icons.logout_outlined,
                        activeIcon: Icons.logout,
                        title: 'Logout',
                        onTap: () => _showLogoutDialog(context),
                        isDestructive: true,
                      ),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildModernHeader(BuildContext context, TeacherModel teacher) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF4A90E2), const Color(0xFF357ABD)],
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Column(
      children: [
        // Profile Avatar
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: const AssetImage('assets/logo/sems.png'),
              backgroundColor: Colors.grey[100],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Welcome Text
        const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // Academy ID
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            teacher.academyId,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    ),
  );
}

Widget _buildModernDrawerItem({
  required IconData icon,
  required IconData activeIcon,
  required String title,
  required VoidCallback onTap,
  bool isActive = false,
  bool isDestructive = false,
}) {
  final Color primaryColor = isDestructive
      ? Colors.red[600]!
      : isActive
      ? const Color(0xFF4A90E2)
      : Colors.grey[700]!;

  final Color backgroundColor = isActive
      ? const Color(0xFF4A90E2).withOpacity(0.1)
      : Colors.transparent;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        isActive ? activeIcon : icon,
        color: primaryColor,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isActive
          ? Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      dense: true,
    ),
  );
}

Widget _buildFooter() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.school,
                color: Color(0xFF4A90E2),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SEMS Education',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Mohit, Mukul, Ankit, Anuj © 2024',
          style: TextStyle(color: Colors.grey[500], fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: 12),
          Text('Logout'),
        ],
      ),
      content: const Text(
        'Are you sure you want to logout from your account?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context); // Close drawer
            // BlocProvider.of<AuthBloc>(context).add(SignOut());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

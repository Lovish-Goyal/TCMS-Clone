import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/features/teachers/utils/drawer.dart';
import 'package:sems/router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/utils/grid_icon_data.dart';
import '../../../shared/widgets/my_app_bar.dart';
import '../../admin/utils/financial_chart_widget.dart';

class TeacherHome extends ConsumerWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: myAppBar(context, title: 'Student Dashboard'),
      drawer: teacherDrawer(context, ref),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Section
            _buildWelcomeHeader(),

            // Quick Stats Cards
            _buildQuickStats(),

            // Quick Actions Grid
            _buildQuickActionsSection(),

            // Chart Section
            _buildChartSection(),

            // Recent Activity Section
            _buildRecentActivitySection(),

            // Footer
            _buildFooter(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 126, 185, 234),
            Color.fromARGB(255, 83, 169, 240),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your academy efficiently',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Students',
              value: '248',
              icon: Icons.group,
              color: const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildStatCard(
              title: 'Classes',
              value: '12',
              icon: Icons.class_,
              color: const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildStatCard(
              title: 'Exams',
              value: '5',
              icon: Icons.quiz,
              color: const Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemCount: iconData.length,
          itemBuilder: (context, index) {
            return _buildModernActionCard(
              icon: iconData[index]['icon'],
              label: iconData[index]['label'],
              color: iconData[index]['color'],
              onTap: () {
                switch (index) {
                  case 0:
                    context.push(AppRoute.createBatch.path);
                    break;
                  case 1:
                    context.push(AppRoute.activeStudentsList.path);
                  case 2:
                    context.push(AppRoute.attendance.path);
                    break;
                  case 8:
                    const url =
                        'https://play.google.com/store/apps/details?id=com.rkgroup.papergenerator';
                    try {
                      launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (e) {
                      // Handle error
                    }
                    break;
                  default:
                  // SnackbarHelper.showInfoSnackBar(context, '📢 Coming Soon');
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: const Text(
                  'Performance Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 12,
              //     vertical: 6,
              //   ),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF4CAF50).withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: const Text(
              //     'This Month',
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w600,
              //       color: Color(0xFF4CAF50),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: FinancialChartWidget(
              line1Data: [
                FlSpot(0, 1),
                FlSpot(1, 1.5),
                FlSpot(2, 1.4),
                FlSpot(3, 3.4),
                FlSpot(4, 5),
              ],
              line2Data: [
                FlSpot(0, 1),
                FlSpot(1, 1.8),
                FlSpot(2, 1.2),
                FlSpot(3, 2.8),
                FlSpot(4, 8),
              ],
              line1Color: const Color(0xFF4CAF50),
              line2Color: const Color(0xFF2196F3),
              currencySymbol: '',
              aspectRatio: 2.0,
              onDataPointTap: (spot, lineIndex) {
                print(
                  'Tapped point: x=${spot.x}, y=${spot.y} on line $lineIndex',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  icon: Icons.person_add,
                  title: 'New student enrolled',
                  subtitle: 'John Doe joined Class 10A',
                  time: '2 hours ago',
                  color: const Color(0xFF4CAF50),
                ),
                _buildActivityItem(
                  icon: Icons.assignment,
                  title: 'Exam scheduled',
                  subtitle: 'Mathematics exam for Class 9',
                  time: '4 hours ago',
                  color: const Color(0xFF2196F3),
                ),
                _buildActivityItem(
                  icon: Icons.notification_important,
                  title: 'System update',
                  subtitle: 'New features added to dashboard',
                  time: '1 day ago',
                  color: const Color(0xFFFF9800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 133, 185, 227),
            Color.fromARGB(255, 56, 155, 235),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(width: 8),
          Text(
            'Built with ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Text(
            'for Education',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

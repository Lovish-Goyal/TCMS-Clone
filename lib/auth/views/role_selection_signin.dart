import 'package:sems/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum UserRole { admin, student, teacher }

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome message
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 217, 231, 242),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.waving_hand,
                    size: 50,
                    color: Color(0xFFFFB84D),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to SEMS!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Who are you today?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Admin Role
            _buildKidsRoleCard(
              context: context,
              role: 'Admin',
              icon: Icons.person_outline,
              color: const Color(0xFF6C5CE7),
              onPressed: () => _onRoleSelected(context, 'Admin'),
            ),

            const SizedBox(height: 20),

            // Teacher Role
            _buildKidsRoleCard(
              context: context,
              role: 'Teacher',
              icon: Icons.person_4_outlined,
              color: const Color.fromARGB(255, 26, 142, 184),
              onPressed: () => _onRoleSelected(context, 'Teacher'),
            ),

            const SizedBox(height: 20),

            // Student Role
            _buildKidsRoleCard(
              context: context,
              role: 'Student',
              icon: Icons.school_outlined,
              color: const Color(0xFF00B894),
              onPressed: () => _onRoleSelected(context, 'Student'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKidsRoleCard({
    required BuildContext context,
    required String role,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color.withOpacity(0.2), width: 2),
          ),
          padding: const EdgeInsets.all(20),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRoleSelected(BuildContext context, String role) {
    switch (role) {
      case 'Admin':
        // context.push(AppRoute.AdminLogin.path);
        debugPrint('Admin selected');
        break;
      case 'Student':
        context.push(AppRoute.studentLogin.path);
        debugPrint('Student selected');
        break;
      case 'Teacher':
        context.push(AppRoute.teacherLogin.path);
        debugPrint('Teacher selected');
        break;
    }
  }
}

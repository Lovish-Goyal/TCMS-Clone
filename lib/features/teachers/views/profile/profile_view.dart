import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/teachers_model.dart';
import '../../providers/profile_provider.dart';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(teacherProfileProvider.notifier)
          .loadTeacherProfile('current_user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(teacherProfileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error loading profile: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(teacherProfileProvider.notifier)
                    .loadTeacherProfile('current_user_id'),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }
          return _buildProfileContent(context, profile);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF4A90E2),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          // TODO: Open drawer
        },
      ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Open notifications
          },
        ),
      ],
    );
  }

  Widget _buildProfileContent(BuildContext context, TeacherModel profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          _buildProfileCard(profile),
          const SizedBox(height: 20),

          // Action Buttons
          _buildActionButtons(context),
          const SizedBox(height: 20),

          // Trial/Subscription Info
          _buildSubscriptionCard(profile),
          const SizedBox(height: 20),

          // Logout Button
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileCard(TeacherModel profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to edit profile
                },
                child: const Text(
                  'EDIT',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildProfileInfoRow(
            Icons.badge_outlined,
            'Academy ID',
            profile.academyId,
          ),
          const SizedBox(height: 16),
          _buildProfileInfoRow(
            Icons.business_outlined,
            'Academy',
            profile.academyName,
          ),
          const SizedBox(height: 16),
          _buildProfileInfoRow(Icons.person_outline, 'Name', profile.name),
          const SizedBox(height: 16),
          _buildProfileInfoRow(Icons.email_outlined, 'Email', profile.email),
          const SizedBox(height: 16),
          _buildProfileInfoRow(
            Icons.phone_outlined,
            'Phone',
            profile.phoneNumber,
          ),
          const SizedBox(height: 16),
          _buildProfileInfoRow(
            Icons.location_on_outlined,
            'Address',
            profile.address,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4A90E2), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'Not provided',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          'SHARE DIGITAL CARD',
          const Color(0xFF3498DB),
          Icons.share,
          () {
            // TODO: Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'SHARE ACADEMY QR CODE',
          const Color(0xFF2980B9),
          Icons.qr_code,
          () {
            // TODO: Implement QR code sharing
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR Code sharing coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'CHANGE TEACHER ID REQUEST',
          const Color(0xFF1A5490),
          Icons.edit,
          () {
            // TODO: Implement change ID request
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Change ID request coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(TeacherModel profile) {
    final isTrialActive =
        profile.trialEndDate != null &&
        profile.trialEndDate!.isAfter(DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            profile.isPremium ? 'Premium Account' : 'Trial Period',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (isTrialActive &&
              profile.trialStartDate != null &&
              profile.trialEndDate != null)
            Text(
              '${_formatDate(profile.trialStartDate!)} TO ${_formatDate(profile.trialEndDate!)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 20),
          if (!profile.isPremium)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(teacherProfileProvider.notifier).upgradeAccount();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE74C3C),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'LOGOUT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(teacherProfileProvider.notifier).logout();
                // TODO: Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/setting_screen.dart';
import '../theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(color: AppColors.cream, shape: BoxShape.circle),
              child: const Icon(Icons.person_rounded, color: AppColors.navy, size: 60),
            ),
            const SizedBox(height: 18),
            Text("user", style: appFont(size: 22, weight: FontWeight.w800, color: Colors.white)),
            Text('email@gmail.com',
                style: appFont(size: 14, weight: FontWeight.w500, color: AppColors.subtitleGrey)),
            const SizedBox(height: 30),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },child: _ProfileRow(icon: Icons.settings_outlined, label: 'Settings')),
            _ProfileRow(icon: Icons.notifications_none_rounded, label: 'Notifications'),
            _ProfileRow(icon: Icons.help_outline_rounded, label: 'Help & Support'),
            _ProfileRow(icon: Icons.logout_rounded, label: 'Log out'),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProfileRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(color: AppColors.greyCard, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Text(label, style: appFont(size: 15, weight: FontWeight.w600, color: Colors.white)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

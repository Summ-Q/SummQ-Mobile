import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/buildSettingRows.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _studyRemindersEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: appFont(
              size: 22, weight: FontWeight.w800, color: Colors.white),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          buildSectionTitle('Account'),
          buildSettingsRow(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile',
            onTap: () {},
          ),
          buildSettingsRow(
            icon: Icons.lock_outline_rounded,
            label: 'Change Password',
            onTap: () {},
          ),
          const SizedBox(height: 30),

          buildSectionTitle('Preferences'),
          buildSwitchRow(
            icon: Icons.notifications_none_rounded,
            label: 'Push Notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          buildSwitchRow(
            icon: Icons.schedule_rounded,
            label: 'Study Reminders',
            value: _studyRemindersEnabled,
            onChanged: (value) {
              setState(() => _studyRemindersEnabled = value);
            },
          ),
          buildSwitchRow(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
            },
          ),
          const SizedBox(height: 30),

          buildSectionTitle('About'),
          buildSettingsRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () {},
          ),
          buildSettingsRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () {},
          ),
          buildSettingsRow(
            icon: Icons.info_outline_rounded,
            label: 'App Version',
            trailingText: 'v1.0.0',
            onTap: () {},
          ),

          const SizedBox(height: 40),

          Center(
            child: TextButton(
              onPressed: () {
              },
              child: Text(
                'Delete Account',
                style: appFont(size: 16,
                    weight: FontWeight.w600,
                    color: AppColors.chartRed),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}
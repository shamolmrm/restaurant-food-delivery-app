import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif = true;
  bool _emailNotif = false;
  bool _smsNotif = true;
  bool _biometric = false;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: isDark ? Iconsax.moon : Iconsax.sun_1,
                label: 'Dark Mode',
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Iconsax.notification,
                label: 'Push Notifications',
                trailing: Switch.adaptive(
                  value: _pushNotif,
                  onChanged: (v) {
                    setState(() => _pushNotif = v);
                    _snack(v ? 'Push notifications enabled' : 'Push notifications disabled');
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Iconsax.sms,
                label: 'Email Notifications',
                trailing: Switch.adaptive(
                  value: _emailNotif,
                  onChanged: (v) {
                    setState(() => _emailNotif = v);
                    _snack(v ? 'Email notifications enabled' : 'Email notifications disabled');
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Iconsax.mobile,
                label: 'SMS Notifications',
                trailing: Switch.adaptive(
                  value: _smsNotif,
                  onChanged: (v) {
                    setState(() => _smsNotif = v);
                    _snack(v ? 'SMS notifications enabled' : 'SMS notifications disabled');
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Privacy & Security',
            children: [
              _SettingsTile(
                icon: Iconsax.lock,
                label: 'Change Password',
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Change Password'),
                    content: const Text('A password reset link will be sent to your registered email address.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _snack('Password reset link sent to your email!');
                        },
                        child: const Text('Send Link'),
                      ),
                    ],
                  ),
                ),
              ),
              _SettingsTile(
                icon: Iconsax.finger_scan,
                label: 'Biometric Login',
                trailing: Switch.adaptive(
                  value: _biometric,
                  onChanged: (v) {
                    setState(() => _biometric = v);
                    _snack(v ? 'Biometric login enabled' : 'Biometric login disabled');
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'App',
            children: [
              _SettingsTile(
                icon: Iconsax.language_square,
                label: 'Language',
                subtitle: 'English',
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => SimpleDialog(
                    title: const Text('Select Language'),
                    children: ['English', 'বাংলা', 'हिन्दी', 'اردو']
                        .map((lang) => SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                _snack('Language set to $lang');
                              },
                              child: Text(lang),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const _SettingsTile(
                icon: Iconsax.info_circle,
                label: 'App Version',
                subtitle: '1.0.0 (Build 1)',
              ),
              _SettingsTile(
                icon: Iconsax.document,
                label: 'Privacy Policy',
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _snack('Opening Privacy Policy...'),
              ),
              _SettingsTile(
                icon: Iconsax.document_text,
                label: 'Terms of Service',
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _snack('Opening Terms of Service...'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(label, style: AppTextStyles.titleSmall),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary))
          : null,
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

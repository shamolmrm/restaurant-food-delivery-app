import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/inputs/custom_text_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@feastly.com');
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (_emailCtrl.text.trim() == 'admin@feastly.com' &&
        _passCtrl.text == 'Admin@123') {
      context.go(RouteNames.adminDashboard);
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid admin credentials'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Back
              GestureDetector(
                onTap: () => context.go(RouteNames.login),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
              ),
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('⚙️', style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(height: 28),
              Text('Admin Portal',
                  style: AppTextStyles.displayMedium
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Feastly Business Dashboard',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54)),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Admin Email',
                      hint: 'admin@feastly.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.admin_panel_settings_outlined,
                          color: AppColors.textTertiary, size: 20),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter admin email' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textTertiary, size: 20),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 32),
                    GradientButton(
                      label: 'Login to Dashboard',
                      onPressed: _login,
                      isLoading: _loading,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          Text('🔑  Admin Credentials',
                              style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('admin@feastly.com  /  Admin@123',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: Colors.white54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

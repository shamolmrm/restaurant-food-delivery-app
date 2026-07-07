import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../core/utils/extensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      context.go(RouteNames.main);
    } else {
      context.showSnack('Registration failed. Please try again.',
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Account'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join Feastly 🍔',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Create an account and start ordering',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Full Name',
                hint: 'Shamol Ahmed',
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.person_outline,
                    color: AppColors.textTertiary, size: 20),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email Address',
                hint: 'you@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.textTertiary, size: 20),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter email';
                  if (!v.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone Number',
                hint: '+880 1712 345678',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppColors.textTertiary, size: 20),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordCtrl,
                isPassword: true,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textTertiary, size: 20),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter password';
                  if (v.length < 6) {
                    return 'Password must be at least 6 chars';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password',
                hint: '••••••••',
                controller: _confirmCtrl,
                isPassword: true,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textTertiary, size: 20),
                validator: (v) {
                  if (v != _passwordCtrl.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => GradientButton(
                  label: 'Create Account',
                  onPressed: _register,
                  isLoading: auth.status == AuthStatus.loading,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
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

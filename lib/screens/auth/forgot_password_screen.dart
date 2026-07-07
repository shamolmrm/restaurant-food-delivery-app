import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../core/utils/extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_emailCtrl.text.isEmpty || !_emailCtrl.text.contains('@')) {
      context.showSnack('Enter a valid email', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isLoading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Forgot Password'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Reset Password 🔐', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'Enter your email address and we\'ll send you a reset link',
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          label: 'Email Address',
          hint: 'you@example.com',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined,
              color: AppColors.textTertiary, size: 20),
        ),
        const SizedBox(height: 24),
        GradientButton(
          label: 'Send Reset Link',
          onPressed: _send,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📧', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          const Text('Check Your Email!',
              style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'We sent a reset link to\n${_emailCtrl.text}',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Back to Login',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

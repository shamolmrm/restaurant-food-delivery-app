import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../core/utils/extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      context.go(RouteNames.main);
    } else {
      context.showSnack(auth.error ?? 'Login failed', isError: true);
    }
  }

  void _socialLogin(String provider) {
    _emailCtrl.text = 'demo@feastly.com';
    _passwordCtrl.text = 'demo1234';
    _login();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 700;
    return isWide ? _buildWebLayout(context) : _buildMobileLayout(context);
  }

  // ──────────────────────────────────────────
  // WEB / TABLET — two-column layout
  // ──────────────────────────────────────────
  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text('🍔', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Feastly',
                        style: AppTextStyles.displayLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                      const SizedBox(height: 12),
                      Text(
                        'Food. Fast. Flawless.',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                      const SizedBox(height: 24),
                      Text(
                        'Your favourite restaurants,\ndelivered to your door.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.7,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '4.9 • 50,000+ happy customers',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right form panel
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _buildForm(context, isWide: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // MOBILE — original sliding card design
  // ──────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top gradient header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text('🍔', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome\nBack 👋',
                        style: AppTextStyles.displayLarge.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue ordering',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),

            // Form section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: _buildForm(context, isWide: false),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // SHARED FORM
  // ──────────────────────────────────────────
  Widget _buildForm(BuildContext context, {required bool isWide}) {
    final isDark = context.isDark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide) ...[
            Text(
              'Welcome Back 👋',
              style: AppTextStyles.displayMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
            const SizedBox(height: 6),
            Text(
              'Sign in to your account',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
            const SizedBox(height: 32),
          ],

          // Email field
          CustomTextField(
            label: 'Email Address',
            hint: 'demo@feastly.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined,
                color: AppColors.textTertiary, size: 20),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ).animate().fadeIn(delay: isWide ? 200.ms : 0.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Password field
          CustomTextField(
            label: 'Password',
            hint: '••••••••',
            controller: _passwordCtrl,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _login(),
            prefixIcon: const Icon(Icons.lock_outline,
                color: AppColors.textTertiary, size: 20),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Password must be at least 6 chars';
              return null;
            },
          ).animate().fadeIn(delay: isWide ? 300.ms : 0.ms, duration: 400.ms),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push(RouteNames.forgotPassword),
              child: Text(
                'Forgot Password?',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Consumer<AuthProvider>(
            builder: (_, auth, __) => GradientButton(
              label: 'Sign In',
              onPressed: _login,
              isLoading: auth.status == AuthStatus.loading,
            ),
          ).animate().fadeIn(delay: isWide ? 400.ms : 0.ms, duration: 400.ms),

          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(
                  child: Divider(color: AppColors.border, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textTertiary),
                ),
              ),
              const Expanded(
                  child: Divider(color: AppColors.border, thickness: 1)),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  emoji: '🇬',
                  label: 'Google',
                  onTap: () => _socialLogin('Google'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SocialButton(
                  emoji: '📘',
                  label: 'Facebook',
                  onTap: () => _socialLogin('Facebook'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Center(
            child: GestureDetector(
              onTap: () => context.push(RouteNames.register),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '🔑  Demo Credentials',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'demo@feastly.com  /  demo1234',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => context.push(RouteNames.adminLogin),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.admin_panel_settings_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('Admin Dashboard',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color:
              isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

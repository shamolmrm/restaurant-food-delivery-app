import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/gradient_button.dart';

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> colors;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colors,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      emoji: '🍕',
      title: 'Discover Amazing\nRestaurants',
      subtitle:
          'Explore hundreds of local restaurants and cuisines delivered right to your door',
      colors: [Color(0xFFFF6B35), Color(0xFFFF8C5E)],
    ),
    _OnboardingPage(
      emoji: '🛵',
      title: 'Lightning Fast\nDelivery',
      subtitle:
          'Real-time tracking so you always know exactly where your food is',
      colors: [Color(0xFFFFB627), Color(0xFFFFCC60)],
    ),
    _OnboardingPage(
      emoji: '🎁',
      title: 'Exclusive Deals\n& Offers',
      subtitle:
          'Save more with daily deals, promo codes and loyalty rewards',
      colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keySeenOnboarding, true);
    if (mounted) context.go(RouteNames.login);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) =>
                _PageItem(page: _pages[index]),
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: _finish,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: WormEffect(
                    dotColor: Colors.white.withValues(alpha: 0.4),
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: _currentPage < _pages.length - 1
                      ? 'Next'
                      : 'Get Started 🚀',
                  onPressed: _next,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.9),
                  ],
                  textStyle: AppTextStyles.labelLarge.copyWith(
                    color: _pages[_currentPage].colors.first,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageItem extends StatelessWidget {
  final _OnboardingPage page;

  const _PageItem({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // Illustration
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  page.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    page.title,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    page.subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}

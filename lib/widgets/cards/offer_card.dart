import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onTap;

  const OfferCard({super.key, required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: offer.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: offer.gradient.first.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    offer.code,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    offer.timeLeftFormatted,
                    style: AppTextStyles.badge
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              offer.title,
              style: AppTextStyles.displayMedium.copyWith(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              offer.subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

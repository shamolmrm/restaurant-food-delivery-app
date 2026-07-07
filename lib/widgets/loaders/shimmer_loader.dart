import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppDimensions.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.shimmerBase,
      highlightColor: isDark
          ? AppColors.darkBorder
          : AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerRestaurantCard extends StatelessWidget {
  const ShimmerRestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: const Column(
        children: [
          ShimmerLoader(
            width: double.infinity,
            height: 140,
            borderRadius: AppDimensions.cardRadius,
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(height: 14, width: 140),
                SizedBox(height: 8),
                ShimmerLoader(height: 10, width: 100),
                SizedBox(height: 8),
                ShimmerLoader(height: 10, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerFoodCard extends StatelessWidget {
  const ShimmerFoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(
            height: 130,
            borderRadius: AppDimensions.cardRadius,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(height: 12, width: 100),
                SizedBox(height: 6),
                ShimmerLoader(height: 10, width: 80),
                SizedBox(height: 8),
                ShimmerLoader(height: 14, width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

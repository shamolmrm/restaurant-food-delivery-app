import 'package:flutter/material.dart';

class OfferModel {
  final String id;
  final String title;
  final String subtitle;
  final String code;
  final List<Color> gradient;
  final DateTime expiresAt;
  final double? discountPercent;
  final double? discountAmount;
  final double? minOrderAmount;

  const OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.gradient,
    required this.expiresAt,
    this.discountPercent,
    this.discountAmount,
    this.minOrderAmount,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get timeLeft => expiresAt.difference(DateTime.now());

  String get timeLeftFormatted {
    final d = timeLeft;
    if (d.inDays > 0) return '${d.inDays}d left';
    if (d.inHours > 0) return '${d.inHours}h left';
    if (d.inMinutes > 0) return '${d.inMinutes}m left';
    return 'Expiring soon';
  }
}

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

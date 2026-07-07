enum StaffRole { headChef, chef, cook, helper }
enum StaffStatus { active, onBreak, offline }

class StaffModel {
  final String id;
  final String name;
  final String phone;
  final String photo;
  final StaffRole role;
  final StaffStatus status;
  final int ordersToday;
  final String shift;
  final double rating;

  const StaffModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
    required this.role,
    required this.status,
    required this.ordersToday,
    required this.shift,
    required this.rating,
  });

  String get roleLabel {
    switch (role) {
      case StaffRole.headChef: return 'Head Chef';
      case StaffRole.chef: return 'Chef';
      case StaffRole.cook: return 'Cook';
      case StaffRole.helper: return 'Helper';
    }
  }
}

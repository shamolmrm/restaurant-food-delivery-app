import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../core/constants/dummy_data.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> _addresses = [];
  AddressModel? _selected;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selected =>
      _selected ?? (_addresses.isNotEmpty ? _addresses.first : null);

  AddressProvider() {
    _addresses = List.from(dummyAddresses);
    _selected = _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }

  void selectAddress(AddressModel address) {
    _selected = address;
    notifyListeners();
  }

  void addAddress(AddressModel address) {
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void setDefault(String id) {
    _addresses = _addresses.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
    _selected = _addresses.firstWhere((a) => a.id == id);
    notifyListeners();
  }
}

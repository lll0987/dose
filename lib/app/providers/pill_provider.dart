import 'package:flutter/material.dart';

import '../database/repository/pill_repository.dart';
import '../models/pill_model.dart';
import '../utils/result.dart';

class PillProvider with ChangeNotifier {
  final PillRepository _pillRepository;

  PillProvider(this._pillRepository);

  List<PillModel> _allPills = [];

  List<PillModel> get allPills => _allPills;

  Future<void> loadPills() async {
    _allPills = await _pillRepository.getAllPills();
    notifyListeners();
  }

  Map<int, PillModel> get pillMap {
    final Map<int, PillModel> result = {};
    for (var pill in _allPills) {
      result[pill.id!] = pill;
    }
    return result;
  }

  Future<Result<int>> addPill(PillModel pill) async {
    final result = await _pillRepository.addPill(pill);
    if (result.isSuccess) {
      await loadPills();
    }
    return result;
  }

  Future<void> updatePill(PillModel pill) async {
    await _pillRepository.updatePill(pill);
    await loadPills();
  }

  Future<Result<void>> deletePill(int id) async {
    final result = await _pillRepository.deletePill(id);
    if (result.isSuccess) {
      await loadPills();
    }
    return result;
  }
}

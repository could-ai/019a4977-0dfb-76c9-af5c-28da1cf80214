import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class RosterProvider extends ChangeNotifier {
  List<Employee> _employees = [];
  List<Roster> _rosters = [];

  List<Employee> get employees => _employees;
  List<Roster> get rosters => _rosters;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void updateEmployee(String id, Employee updatedEmployee) {
    final index = _employees.indexWhere((e) => e.id == id);
    if (index != -1) {
      _employees[index] = updatedEmployee;
      notifyListeners();
    }
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addRoster(Roster roster) {
    _rosters.add(roster);
    notifyListeners();
  }

  void deleteRoster(String id) {
    _rosters.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<Employee> getAvailableEmployees() {
    return _employees;
  }
}
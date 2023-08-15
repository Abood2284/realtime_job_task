// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class Employee with ChangeNotifier {
  int? id;
  String? name;
  String? role;
  DateTime? startDate;
  DateTime? endDate;

  Employee({
    this.id,
    this.name,
    this.role,
    this.startDate,
    this.endDate,
  });

  final List<Employee> _employees = [];

  Future<void> addEmp(
      {required int id,
      String? name,
      String? role,
      DateTime? startDate,
      DateTime? endDate}) async {
    final newEmp = Employee(
      id: id,
      name: name!,
      role: role!,
      startDate: startDate!,
      endDate: endDate,
    );
    _employees.add(newEmp);
    notifyListeners();
  }

  Future<void> updateEmp({required Employee newEmp}) async {
    final oldEmp = _employees.indexWhere((element) => element.id == newEmp.id);
    log('oldEmp: ${oldEmp.toString()}');
    _employees[oldEmp] = newEmp;
    notifyListeners();
  }

  Future<void> removeEmp(
    int id,
  ) async {
    Employee employeeToRemove =
        _employees.firstWhere((employee) => employee.id == id);
    _employees.remove(employeeToRemove);
    notifyListeners();
  }

  List<Employee> get allEmployee {
    return [..._employees];
  }

/*
  * Get the list of current employess based on criteria
  * if endDate is null or endDate is after today, the employee is sill workin for the company
*/
  List<Employee> get currEmployees {
    return [
      ..._employees.where((element) =>
          element.endDate == null || element.endDate!.isAfter(DateTime.now()))
    ];
  }

  /* 
    * Get the list of previous employess based on criteria
    * if endDate is before today, the employee is no longer working for the company
   */
  List<Employee> get prevEmployees {
    final list = [
      ..._employees.where((element) =>
          element.endDate?.isBefore(
            DateTime.now(),
          ) ??
          false),
    ];

    return list;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'role': role,
      'startDate': startDate != null ? startDate!.millisecondsSinceEpoch : null,
      'endDate': endDate != null ? endDate!.millisecondsSinceEpoch : null,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] != null ? map['id'] as int : 0,
      name: map['name'] as String,
      role: map['role'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source) as Map<String, dynamic>);
}

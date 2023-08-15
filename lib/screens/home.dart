import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:realtime_job_task/helpers/logger.dart';
import 'package:realtime_job_task/screens/employee_list.dart';

import '../helpers/db_helper.dart';
import '../models/employee.dart';
import 'add_employee_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final db = DatabaseHelper.instance;
    final list = await db.getTableData();
    // create Employee from every list object in there
    for (int i = 0; i < list.length; i++) {
      final employee = Employee(
        id: list[i]['id'] as int,
        name: list[i]['name'] as String,
        role: list[i]['role'] as String,
        startDate: DateTime.parse(list[i]['startdate'] as String),
        endDate: list[i]['endDate'] != null
            ? DateTime.parse(list[i]['enddate'] as String)
            : null,
      );
      // add employee to the list
      Provider.of<Employee>(context, listen: false).addEmp(
        id: employee.id!,
        name: employee.name,
        role: employee.role,
        startDate: employee.startDate,
        endDate: employee.endDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loger = getLogger('HomeScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: const EmployeeListScreen(),
      floatingActionButton: IconButton(
          onPressed: () {
            loger
                .i('Button Pressed: Navigate to add Employee to the DB screen');
            Get.to(() => const AddEditEmployeeInfo());
          },
          icon: const Icon(Icons.add)),
    );
  }
}

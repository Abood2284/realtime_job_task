// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:realtime_job_task/screens/add_employee_screen.dart';

import '../../helpers/db_helper.dart';
import '../../models/employee.dart';

@immutable
class CurrEmployeeWidget extends StatelessWidget {
  final db = DatabaseHelper.instance;

  final List<Employee> currEmp;
  final Function(int) callBack;

  CurrEmployeeWidget({
    Key? key,
    required this.currEmp,
    required this.callBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Employees List',
              style: TextStyle(
                backgroundColor: Colors.amber[200],
                fontSize: 25,
                fontFamily: GoogleFonts.laila().fontFamily,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currEmp.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child:
                        const Icon(Icons.delete, size: 40, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    // Handle item dismissal (e.g., remove from list)
                    await db.delete(currEmp[index].id!);
                    callBack(currEmp[index].id!);
                    // employeeData
                    //     .removeEmp(employeeData.currEmployees[index].id!);
                  },
                  child: InkWell(
                    onTap: () {
                      //* Navigate to edit employee details screen
                      Get.to(
                        () => AddEditEmployeeInfo(
                          employeeDetails: currEmp[index],
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Set the color of the border
                            width: 0.2, // Set the width of the border
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              currEmp[index].name!,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              currEmp[index].role!,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "From ${DateFormat('d MMM y').format(DateTime.parse(currEmp[index].startDate!.toString()))}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

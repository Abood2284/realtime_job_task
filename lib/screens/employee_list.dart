// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../assets/images/curr_employee_widget.dart';
import '../widgets/prev_employee_widget.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeData = Provider.of<Employee>(context);
    return Scaffold(
      body: employeeData.allEmployee.isNotEmpty
          ? Column(
              children: [
                CurrEmployeeWidget(
                    currEmp: employeeData.currEmployees,
                    callBack: employeeData.removeEmp),
                const SizedBox(
                  height: 20,
                ),
                PrevEmployeeWidget(
                    currEmp: employeeData.prevEmployees,
                    callBack: employeeData.removeEmp),
              ],
            )
          : Center(
              child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Image(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        'lib/assets/images/no.gif',
                      ),
                    ),
                  ),
                  Text(
                    'No Employee Data Found',
                    style: TextStyle(
                        fontFamily: GoogleFonts.laila().fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  )
                ],
              ),
            )),
    );
  }
}

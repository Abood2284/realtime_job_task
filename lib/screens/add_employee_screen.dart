// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:realtime_job_task/helpers/db_helper.dart';
import 'package:realtime_job_task/helpers/logger.dart';
import 'package:realtime_job_task/models/employee.dart';

enum DateSelection { start, end }

@immutable
class AddEditEmployeeInfo extends StatefulWidget {
  final Employee? employeeDetails;

  const AddEditEmployeeInfo({
    Key? key,
    this.employeeDetails,
  }) : super(key: key);

  @override
  State<AddEditEmployeeInfo> createState() => _AddEditEmployeeInfoState();
}

class _AddEditEmployeeInfoState extends State<AddEditEmployeeInfo> {
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate.value = widget.employeeDetails?.startDate != null
        ? TextEditingValue(
            text: DateFormat('d MMM y')
                .format(widget.employeeDetails!.startDate!))
        : TextEditingValue(text: DateFormat('d MMM y').format(DateTime.now()));

    _endDate.value = widget.employeeDetails?.endDate != null
        ? TextEditingValue(
            text:
                DateFormat('d MMM y').format(widget.employeeDetails!.endDate!))
        : const TextEditingValue(text: 'Select End Date');
    // : TextEditingValue(text: DateFormat('d MMM y').format(DateTime.now()));
  }

  final loger = getLogger('AddEmployeeScreen');
  /* 
    * If widget.employeeDetails isnt null then you are navigated to this Screen, 
    * from {{EmployeeListScreen}}
    * Else you were navigated to this Screen,
    * from {{HomeScreen}}
   */
  DateTime? selectedStartDate;

  late String? empName = widget.employeeDetails?.name;

  late DateTime? selectedEndDate = widget.employeeDetails?.endDate;

  late String selectedRole =
      widget.employeeDetails?.role ?? 'Flutter Developer';

  late DateTime selectedFirstDate =
      widget.employeeDetails?.startDate ?? DateTime.now();

  DateTime? initialDate;

  final dbHelper = DatabaseHelper.instance;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final employeeData = Provider.of<Employee>(context);
    Future<void> _selectDate(
        BuildContext context, DateSelection dateSelection) async {
      DateTime currentDate = DateTime.now();
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        setState(() {
          if (dateSelection == DateSelection.start) {
            selectedFirstDate = selectedDate;
            _startDate.value = TextEditingValue(
                text: DateFormat('d MMM y').format(selectedDate));
          } else {
            selectedEndDate = selectedDate;
            _endDate.value = TextEditingValue(
                text: DateFormat('d MMM y').format(selectedDate));
          }
        });
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (dateSelection == DateSelection.start) {
                            selectedFirstDate = currentDate;
                            _startDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedFirstDate));
                          } else {
                            selectedEndDate = currentDate;
                            _endDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedEndDate!));
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Today'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        int daysUntilNextMonday = 8 - currentDate.weekday;
                        DateTime nextMonday = currentDate
                            .add(Duration(days: daysUntilNextMonday));
                        setState(() {
                          loger.i('Next Monday: $nextMonday');
                          if (dateSelection == DateSelection.start) {
                            selectedFirstDate = nextMonday;
                            _startDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedFirstDate));
                          } else {
                            selectedEndDate = nextMonday;
                            _endDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedEndDate!));
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Next Monday'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        int daysUntilNextTuesday = 9 - currentDate.weekday;
                        DateTime nextTuesday = currentDate
                            .add(Duration(days: daysUntilNextTuesday));
                        setState(() {
                          if (dateSelection == DateSelection.start) {
                            selectedFirstDate = nextTuesday;
                            _startDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedFirstDate));
                          } else {
                            selectedEndDate = nextTuesday;
                            _endDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedEndDate!));
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Next Tuesday'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DateTime nextWeek =
                            currentDate.add(const Duration(days: 7));
                        setState(() {
                          if (dateSelection == DateSelection.start) {
                            selectedFirstDate = nextWeek;
                            _startDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedFirstDate));
                          } else {
                            selectedEndDate = nextWeek;
                            _endDate.value = TextEditingValue(
                                text: DateFormat('d MMM y')
                                    .format(selectedEndDate!));
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('After 1 week'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // DatePickerDialog(
                //     initialDate: initialDate ?? DateTime.now(),
                //     firstDate: DateTime(2000),
                //     lastDate: DateTime(2101),
                //     onDatePickerModeChange: (newDate) {
                //       log('New Date: $newDate');
                //     }),
                // const SizedBox(height: 5),
                // ElevatedButton(
                //   onPressed: () async {
                //     DateTime? selectedDate = await showDatePicker(
                //       context: context,
                //       initialDate: initialDate ?? DateTime.now(),
                //       firstDate: DateTime(2000),
                //       lastDate: DateTime(2101),
                //     );
                //     if (selectedDate != null) {
                //       setState(() {
                //         if (dateSelection == DateSelection.start) {
                //           selectedFirstDate = selectedDate;
                //         } else {
                //           selectedEndDate = selectedDate;
                //         }
                //       });
                //     }
                //   },
                //   child: const Text('Select Date'),
                // ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(_startDate.text);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person),
                labelText: 'Employee Name',
              ),
              initialValue: widget.employeeDetails?.name ?? '',
              onChanged: (value) {
                empName = value;
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (newValue) {
                setState(() {
                  selectedRole = newValue!;
                });
              },
              items: <String>[
                'Product Designer',
                'Flutter Developer',
                'QA Tester',
                'Prodcut Owner'
              ]
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Select role',
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GestureDetector(
                //   // onTap: () => _selectStartDate(context),
                //   onTap: () async {
                //     _selectDate(context, DateSelection.start);
                //     loger.i('Selected First Date: $selectedFirstDate');
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey),
                //     ),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.calendar_today),
                //         const SizedBox(width: 10),
                //         Text(
                //           // selectedStartDate == null
                //           // ? 'Select Start Date'
                //           // : '${selectedStartDate!.toLocal()}'.split(' ')[0],
                //           DateFormat('d MMM y').format(selectedFirstDate),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: GestureDetector(
                    onTap: () => _selectDate(context, DateSelection.start),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startDate,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: 'Date of Birth',
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            // color: _icon,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: GestureDetector(
                    onTap: () => _selectDate(context, DateSelection.end),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endDate,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: 'Date of Birth',
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            // color: _icon,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   // onTap: () => _selectEndDate(context),
                //   onTap: () async {
                //     _selectDate(context, DateSelection.end);
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey),
                //     ),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.calendar_today),
                //         const SizedBox(width: 10),
                //         Text(
                //           selectedEndDate == null
                //               ? 'Select End Date'
                //               : DateFormat('d MMM y').format(selectedEndDate!),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  loger.d('Cancel button clicked -> Clear all fields');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue),
                child: const Text('Cancel')),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                if (empName == null) {
                  loger.e('Please enter Employee Name');
                  Get.snackbar('Error', 'Please enter Employee Name',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                loger.d('Save button clicked -> Clear all fields');

                if (widget.employeeDetails == null) {
                  log('Inserting New Employee Details');
                  final emp = await dbHelper.insertValues(
                      empName!,
                      selectedRole,
                      selectedFirstDate.toIso8601String(),
                      selectedEndDate == null
                          ? null
                          : selectedEndDate!.toIso8601String());

                  employeeData.addEmp(
                    id: emp.id!,
                    name: emp.name!,
                    role: emp.role!,
                    startDate: emp.startDate,
                    endDate: emp.endDate,
                  );

                  Get.snackbar('Success🎉', 'Employee Added Successfully',
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  // Becuase the _startDAte.text is in format -> 22 Aug 2023
                  DateFormat inputFormat = DateFormat("d MMM yyyy");
                  DateTime formattedStartDate =
                      inputFormat.parse(_startDate.text);
                  DateTime formattedEndDate = inputFormat.parse(_endDate.text);

                  if (formattedStartDate.isAfter(formattedEndDate)) {
                    Get.snackbar('Error', 'Start Date cannot be after End Date',
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  log('Updating Existing Employee Details');
                  dbHelper.updateName(
                    name: empName!,
                    id: widget.employeeDetails!.id!,
                  );
                  employeeData.updateEmp(
                    newEmp: Employee(
                      id: widget.employeeDetails!.id!,
                      name: empName!,
                      role: selectedRole,
                      startDate: formattedStartDate,
                      endDate: formattedEndDate,
                    ),
                  );
                }
                Get.snackbar('Success🎉', 'Employee Updated Successfully',
                    snackPosition: SnackPosition.BOTTOM);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

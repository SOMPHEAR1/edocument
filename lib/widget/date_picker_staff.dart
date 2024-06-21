// ignore_for_file: library_private_types_in_public_api

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_detail_controller.dart';

class DateSinglePickerStaff extends StatefulWidget {
  const DateSinglePickerStaff({
    Key? key,
  }) : super(key: key);

  @override
  _DateSinglePickerStaffState createState() => _DateSinglePickerStaffState();
}

class _DateSinglePickerStaffState extends State<DateSinglePickerStaff> {
  final TaskDetailController taskDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 320,
        child: ListView(
          children: [
            _buildDefaultRangeDatePickerWithValue(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        CalendarDatePicker2(
          config: taskDetailController.config,
          value: taskDetailController.dateValue,
          onValueChanged: (dates) => setState(
            () {
              taskDetailController.dateValue = dates;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

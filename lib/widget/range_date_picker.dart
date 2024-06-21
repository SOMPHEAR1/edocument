// ignore_for_file: library_private_types_in_public_api

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    Key? key,
  }) : super(key: key);

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  final HistoryController historyController = Get.find();

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
          config: historyController.config,
          value: historyController.datePickerValue,
          onValueChanged: (dates) => setState(
            () {
              historyController.datePickerValue = dates;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

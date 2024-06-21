// ignore_for_file: library_private_types_in_public_api

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/comment_controller.dart';

class DateSinglePicker extends StatefulWidget {
  const DateSinglePicker({
    Key? key,
  }) : super(key: key);

  @override
  _DateSinglePickerState createState() => _DateSinglePickerState();
}

class _DateSinglePickerState extends State<DateSinglePicker> {
  final CommentController commentController = Get.find();

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
          config: commentController.config,
          value: commentController.dateValue,
          onValueChanged: (dates) => setState(
            () {
              commentController.dateValue = dates;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

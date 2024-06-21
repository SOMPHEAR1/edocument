import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/staff_model.dart';
import '../models/task_detail_model.dart';
import '../services/api/home/task_detail_service.dart';
import '../widget/app_widget.dart';
import '../widget/color.dart';

class TaskDetailController extends GetxController {
  TaskDetailController({required this.assignmentID});

  final String assignmentID;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  TaskDetailService service = TaskDetailService();
  Rx<TaskDetailModel> taskDetailResModel = TaskDetailModel().obs;
  Rx<StaffModel> staffResModel = StaffModel().obs;

  String dateString = '';
  DateTime? parsedDateTime;

  List<DateTime?> dateValue = [
    null,
  ];

  Future<void> submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      assignmentID,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      taskDetailResModel.value = right;
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.single,
    selectedDayHighlightColor: AppColor().tertiary,
    selectedRangeHighlightColor: AppColor().tertiary,
    controlsTextStyle: TextStyle(
      color: AppColor().primary,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    weekdayLabelTextStyle: TextStyle(
      color: AppColor().primary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    selectedDayTextStyle: TextStyle(
      color: AppColor().info,
      fontSize: 14,
    ),
    dayTextStyle: TextStyle(
      color: AppColor().primaryText,
      fontSize: 14,
    ),
    disabledDayTextStyle: TextStyle(
      color: AppColor().primaryText,
      fontSize: 14,
    ),
    todayTextStyle: TextStyle(
      color: AppColor().primaryText,
      fontSize: 14,
    ),
    yearTextStyle: TextStyle(
      color: AppColor().primaryText,
      fontSize: 14,
    ),
    selectedYearTextStyle: TextStyle(
      color: AppColor().primaryText,
      fontSize: 14,
    ),
  );

  String getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      if (values.isNotEmpty) {
        valueText = values
            .map((v) => v.toString().replaceAll('00:00:00.000', ''))
            .join(',');
      } else {
        valueText = 'Start Date';
      }
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'End Date';
        valueText = '$startDate > $endDate';
      } else {
        return 'null';
      }
    }
    update();
    return valueText;
  }
}

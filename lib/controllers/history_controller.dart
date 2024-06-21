// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/history_model.dart';
import '../services/api/history/history_service.dart';
import '../widget/app_widget.dart';
import '../widget/color.dart';

class HistoryController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  HistoryService service = HistoryService();
  Rx<HistoryModel> historyResModel = HistoryModel().obs;
  var place = '';
  var dFrom;
  var dTo;
  var docNumber = '';

  final TextEditingController searchTextField = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  List<DateTime?> datePickerValue = [
    DateTime.now().subtract(const Duration(days: 31)),
    DateTime.now(),
  ];

  int visibleItemCount = 5;

  void loadMoreItems(int length) {
    visibleItemCount = min(visibleItemCount + 5, length);
  }

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }

  String newTitle = '';
  String newNumber = '';
  String newPlace = '';

  List<String> search = ['Number', 'Title', 'Release Place'];

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    if (newTitle == '' && newNumber == '' && newPlace == '') {
      newTitle = searchTextField.text;
    }

    final res = await service.postAPI(
      newPlace,
      dFrom = formatDateTime(dateTime: datePickerValue[0]),
      dTo = datePickerValue.length == 1
          ? dFrom
          : formatDateTime(dateTime: datePickerValue[1]),
      newNumber,
      newTitle,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      newTitle = '';
      newNumber = '';
      newPlace = '';
      historyResModel.value = right;
    });
  }

  searchByDate() {
    Get.back();
    Future.delayed(const Duration(seconds: 2), () {
      update();
    });
  }

  searchByText() {
    EasyLoading.show(status: 'loading...');
    Get.back();
    Future.delayed(const Duration(seconds: 2), () {
      submitData();
      EasyLoading.dismiss();
      update();
    });
  }

  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
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
    selectedRangeDayTextStyle: TextStyle(
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
}

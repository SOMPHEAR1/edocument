import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bom_model.dart';
import '../models/proposal_detail_model.dart';
import '../models/task_proposal_model.dart';
import '../services/api/home/proposal_detail_service.dart';
import '../widget/app_widget.dart';
import '../widget/color.dart';

class CommentController extends GetxController {
  CommentController({required this.documentID});

  final String documentID;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
    submitTaskProsal();
  }

  ProposalDetailService service = ProposalDetailService();
  Rx<ProposalDetailModel> documentDetailResModel = ProposalDetailModel().obs;
  Rx<TaskProposalModel> taskProposalResModel = TaskProposalModel().obs;

  List<DateTime?> dateValue = [
    null,
  ];

  Rx<BOMModel> bomResModel = BOMModel().obs;
  var bomID = ''.obs;

  int visibleTaskItemCount = 2;

  void loadMoreTaskItems(int length) {
    visibleTaskItemCount = min(visibleTaskItemCount + 2, length);
  }

  int visibleSubItemCount = 2;

  void loadMoreSubItems(int length) {
    visibleSubItemCount = min(visibleSubItemCount + 2, length);
  }

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postCommentAPI(
      documentID,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      documentDetailResModel.value = right;
    });
  }

  void submitTaskProsal() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postTaskProposalAPI(
      documentID,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      taskProposalResModel.value = right;
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
        valueText = '$startDate   >    $endDate';
      } else {
        return 'null';
      }
    }
    update();
    return valueText;
  }
}

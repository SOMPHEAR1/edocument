// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:e_document_app/widget/dismiss_keyboad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/history_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/range_date_picker.dart';
import '../../widget/color.dart';
import '../home/comment_screen.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController historyController = Get.put(HistoryController());

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String newKey = '';

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: Scaffold(
        backgroundColor: AppColor().primary.withOpacity(0.85),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 210,
          title: Column(
            children: [
              date(context: context),
              const SizedBox(height: 6),
              searchField(
                action: () {
                  setState(() {
                    if (newKey == 'Title') {
                      historyController.newTitle =
                          historyController.searchTextField.text;
                      historyController.newNumber = '';
                      historyController.newPlace = '';
                      historyController.searchFocusNode;
                    } else if (newKey == 'Number') {
                      historyController.newNumber =
                          historyController.searchTextField.text;
                      historyController.newTitle = '';
                      historyController.newPlace = '';
                    } else if (newKey == 'Release Place') {
                      historyController.newPlace =
                          historyController.searchTextField.text;
                      historyController.newNumber = '';
                      historyController.newTitle = '';
                    } else {
                      historyController.newNumber =
                          historyController.searchTextField.text;
                      historyController.newTitle = '';
                      historyController.newPlace = '';
                    }
                  });
                  historyController.searchFocusNode.unfocus();
                  historyController.searchByText();
                },
              ),
              const SizedBox(height: 6),
              Container(
                height: 35,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: historyController.search.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: TouchRippleEffect(
                        onTap: () {
                          setState(() {
                            if (historyController.search[index] == 'Title') {
                              newKey = historyController.search[index];
                              historyController.newTitle =
                                  historyController.searchTextField.text;
                              historyController.newNumber = '';
                              historyController.newPlace = '';
                            } else if (historyController.search[index] ==
                                'Number') {
                              newKey = historyController.search[index];
                              historyController.newNumber =
                                  historyController.searchTextField.text;
                              historyController.newTitle = '';
                              historyController.newPlace = '';
                            } else if (historyController.search[index] ==
                                'Release Place') {
                              newKey = historyController.search[index];
                              historyController.newPlace =
                                  historyController.searchTextField.text;
                              historyController.newNumber = '';
                              historyController.newTitle = '';
                            } else {
                              newKey = historyController.search[index];
                              historyController.newNumber =
                                  historyController.searchTextField.text;
                              historyController.newTitle = '';
                              historyController.newPlace = '';
                            }
                          });
                        },
                        rippleColor: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: newKey == historyController.search[index]
                                ? AppColor().accent3
                                : AppColor().accent2,
                            border: Border.all(color: AppColor().info),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppWidget().textTitle(
                            title: historyController.search[index],
                            color: AppColor().info,
                            size: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: DismissKeyboard(
          child: AppWidget().pullRefresh(
            action: () {
              setState(() {
                historyController.visibleItemCount = 5;
                historyController.submitData();
              });
            },
            child: ListView(
              children: [
                searchDocument(),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }

  searchField({
    required Function() action,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: historyController.searchTextField,
              focusNode: historyController.searchFocusNode,
              obscureText: false,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: newKey == historyController.search[0]
                    ? 'Search document number...'
                    : newKey == historyController.search[1]
                        ? 'Search document title...'
                        : newKey == historyController.search[2]
                            ? 'Search release place...'
                            : 'Search document number...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primaryText,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: AppColor().info,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColor().primary,
                ),
                suffixIcon: historyController.searchTextField.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColor().primary,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            historyController.searchTextField.clear();
                          });
                        },
                      )
                    : null,
              ),
              onFieldSubmitted: (value) {
                action.call();
              },
            ),
          ),
          const SizedBox(width: 8),
          AppWidget().shortButtonWidget(
            text: 'Search',
            fontColor: AppColor().info,
            color: AppColor().primary,
            icon: Icon(
              Icons.search_rounded,
              color: AppColor().info,
            ),
            borderColor: AppColor().info,
            action: () {
              action.call();
            },
          ),
        ],
      ),
    );
  }

  date({BuildContext? context}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textLargeTitle(
                  title: 'Date',
                  color: AppColor().info,
                ),
                AppWidget().shortButtonWidget(
                  text: 'Select Date >>',
                  fontColor: AppColor().info,
                  color: AppColor().accent2,
                  fontSize: 12,
                  radius: 20,
                  borderColor: AppColor().info,
                  action: () {
                    return AppWidget().customPopup(
                        context: context!,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const DateRangePicker(),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(1.00, 0.00),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: AppWidget().shortButtonWidget(
                                        text: 'Last Week',
                                        fontColor: AppColor().primary,
                                        color: AppColor().info,
                                        borderColor: AppColor().primary,
                                        rippleColor: Colors.black26,
                                        action: () {
                                          historyController.formatDateTime(
                                            dateTime: historyController
                                                    .datePickerValue[0] =
                                                DateTime.now().subtract(
                                              const Duration(days: 7),
                                            ),
                                          );
                                          historyController.formatDateTime(
                                            dateTime: historyController
                                                    .datePickerValue[1] =
                                                DateTime.now(),
                                          );
                                          setState(() {
                                            historyController.searchByDate();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(1.00, 0.00),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: AppWidget().shortButtonWidget(
                                        text: 'Last Month',
                                        fontColor: AppColor().primary,
                                        color: AppColor().info,
                                        borderColor: AppColor().primary,
                                        rippleColor: Colors.black26,
                                        topPad: 6,
                                        action: () {
                                          historyController.formatDateTime(
                                            dateTime: historyController
                                                    .datePickerValue[0] =
                                                DateTime.now().subtract(
                                              const Duration(days: 31),
                                            ),
                                          );
                                          historyController.formatDateTime(
                                            dateTime: historyController
                                                    .datePickerValue[1] =
                                                DateTime.now(),
                                          );
                                          setState(() {
                                            historyController.searchByDate();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppWidget().shortButtonWidget(
                              text: 'Last Year',
                              fontColor: AppColor().primary,
                              color: AppColor().info,
                              borderColor: AppColor().primary,
                              rippleColor: Colors.black26,
                              action: () {
                                historyController.formatDateTime(
                                  dateTime:
                                      historyController.datePickerValue[0] =
                                          DateTime.now().subtract(
                                    const Duration(days: 365),
                                  ),
                                );
                                historyController.formatDateTime(
                                  dateTime: historyController
                                      .datePickerValue[1] = DateTime.now(),
                                );
                                setState(() {
                                  historyController.searchByDate();
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        actionTitle: 'Okay',
                        action: () {
                          setState(() {
                            historyController.searchByDate();
                          });
                        });
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppWidget().textNormal(
                        title: 'From :',
                        size: 13.5,
                        color: AppColor().info,
                      ),
                      const SizedBox(width: 8),
                      AppWidget().textTitle(
                        title: historyController.formatDateTime(
                          dateTime: historyController.datePickerValue[0],
                        ),
                        size: 15,
                        color: AppColor().info,
                      ),
                    ],
                  ),
                  AppWidget().iconCustom(
                    icon: Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColor().info,
                  ),
                  Row(
                    children: [
                      AppWidget().textNormal(
                        title: 'To :',
                        size: 13.5,
                        color: AppColor().info,
                      ),
                      const SizedBox(width: 8),
                      AppWidget().textTitle(
                        title: historyController.datePickerValue.length == 1
                            ? historyController.formatDateTime(
                                dateTime: historyController.datePickerValue[0],
                              )
                            : historyController.formatDateTime(
                                dateTime: historyController.datePickerValue[1],
                              ),
                        size: 15,
                        color: AppColor().info,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  searchDocument() {
    final item = historyController.historyResModel;

    return Obx(
      () {
        return Get.find<HistoryController>().historyResModel.value.errorCode ==
                null
            ? AppWidget().loadingIndicator()
            : item.value.document == null
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: AppWidget().textLargeTitle(
                      title: 'No Document',
                      color: AppColor().info,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.value.document == null
                          ? Container()
                          : ListView.builder(
                              itemCount: min(historyController.visibleItemCount,
                                  item.value.document!.length),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AppWidget().historyDocItem(
                                    context: context,
                                    docNumber:
                                        '${item.value.document![index].documentNumber}',
                                    docTitle:
                                        '${item.value.document![index].documentTitle}',
                                    date:
                                        '${item.value.document![index].submissionDateTime}',
                                    from:
                                        '${item.value.document![index].documentReleasePlace}',
                                    action: () => Get.to(
                                      () => CommentScreen(),
                                      arguments: {
                                        'docID':
                                            '${item.value.document![index].documentId}',
                                        'documentType': 'search',
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 12),
                      item.value.document == null
                          ? Container()
                          : historyController.visibleItemCount <
                                  item.value.document!.length
                              ? GestureDetector(
                                  onTap: () {
                                    EasyLoading.show(status: 'Loading...');

                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        historyController.loadMoreItems(
                                            item.value.document!.length);
                                      });
                                      EasyLoading.dismiss();
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppWidget().textNormal(
                                        title: 'See more',
                                        color: AppColor().info,
                                        size: 15,
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 32,
                                        color: AppColor().info,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                    ],
                  );
      },
    );
  }
}

// ignore_for_file: must_be_immutable, unnecessary_null_comparison, prefer_const_constructors

import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/bom_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/director_controller.dart';
import '../../controllers/staff_controller.dart';
import '../../controllers/task_detail_controller.dart';
import '../../controllers/update_info_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/single_date_picker.dart';
import 'view_pdf.dart';

class UpdateInfoScreen extends StatefulWidget {
  const UpdateInfoScreen({super.key});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  final CommentController commentController = Get.put(CommentController(
    documentID: Get.arguments['docID'],
  ));
  final TaskDetailController taskDetailController = Get.put(
    TaskDetailController(assignmentID: Get.arguments['assignmentId']),
  );
  final BOMController bomController = Get.put(BOMController());
  final DirectorController directorController = Get.put(DirectorController());
  final StaffController staffController = Get.put(StaffController());
  final UpdateInfoController updateInfoController = Get.put(
    UpdateInfoController(assignedmentId: Get.arguments['assignmentId']),
  );

  @override
  Widget build(BuildContext context) {
    final item = commentController.documentDetailResModel;

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: ListView(
            children: [
              AppWidget().newAppBar(
                title: 'Update',
                context: context,
              ),
              Obx(() {
                return Get.find<CommentController>()
                            .documentDetailResModel
                            .value
                            .errorCode ==
                        null
                    ? AppWidget().loadingIndicator()
                    : AppWidget().detailInfo(
                        symbol: '${item.value.documentInfo!.documentNumber}',
                        issueDate: '${item.value.documentInfo!.documentDate}',
                        from:
                            '${item.value.documentInfo!.documentReleasePlace}',
                        type: '${item.value.documentInfo!.documentType}',
                        receiveDate:
                            '${item.value.documentInfo!.submissionDateTime}',
                        title: '${item.value.documentInfo!.documentTitle}');
              }),
              assignTo(
                context,
              ),
              const SizedBox(height: 16),
              getStorage.read('roleId') == 'Director'
                  ? commentSubTask()
                  : commentTask(),
              const SizedBox(height: 16),
              AppWidget().buttonWidget(
                text: 'Update',
                fontColor: AppColor().info,
                color: AppColor().secondary,
                borderColor: AppColor().info,
                action: () {
                  getStorage.read('roleId') == 'Director'
                      ? updateForDept()
                      : updateForBOM();
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  document() {
    final item = commentController.documentDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Document',
              color: AppColor().info,
            ),
          ),
          Obx(
            () {
              return Get.find<CommentController>()
                          .documentDetailResModel
                          .value
                          .errorCode ==
                      null
                  ? AppWidget().loadingIndicator()
                  : item.value.documentInfo!.listOfFiles == null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: AppWidget().textTitle(
                            title: 'No Document',
                            color: AppColor().info,
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              item.value.documentInfo!.listOfFiles!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8),
                              margin: EdgeInsets.only(top: index == 0 ? 4 : 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidget().textTitle(
                                    title:
                                        '${item.value.documentInfo!.listOfFiles![index].fileName}',
                                    size: 14,
                                    color: AppColor().info,
                                  ),
                                  const SizedBox(height: 4),
                                  AppWidget().shortButtonWidget(
                                    text: 'View',
                                    fontSize: 12,
                                    fontColor: AppColor().info,
                                    color: AppColor().secondary,
                                    borderColor: AppColor().info,
                                    icon: AppWidget().faIconCustom(
                                      icon: FontAwesomeIcons.eye,
                                      size: 14,
                                    ),
                                    action: () {
                                      Get.to(
                                        () => ViewPdfScreen(),
                                        arguments: {
                                          'fileID':
                                              '${item.value.documentInfo!.listOfFiles![index].fileId}',
                                          'fileName':
                                              '${item.value.documentInfo!.listOfFiles![index].fileName}',
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
            },
          ),
        ],
      ),
    );
  }

  assignTo(BuildContext context) {
    final bomItems = bomController.bomResModel;
    final directorItems = directorController.directorResModel;
    final staffItems = staffController.staffResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Assign To',
              color: AppColor().info,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getStorage.read('roleId') == 'Director'
                    ? Obx(() {
                        return Get.find<TaskDetailController>()
                                    .taskDetailResModel
                                    .value
                                    .errorCode ==
                                null
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: AppColor().accent2,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SmartSelect.multiple(
                                  title: 'Assign Staffs',
                                  selectedValue:
                                      updateInfoController.assigneeId,
                                  onChange: (selected) {
                                    setState(() {
                                      updateInfoController.assigneeId =
                                          selected.value;
                                      if (selected.title != null) {
                                        updateInfoController.assigneename =
                                            selected.title!;
                                      }
                                    });
                                  },
                                  choiceType: S2ChoiceType.chips,
                                  choiceItems: S2Choice.listFrom(
                                    source: staffItems.value.staff!,
                                    value: (index, staffItem) =>
                                        '${staffItem.username}',
                                    title: (index, staffItem) =>
                                        '${staffItem.firstName} ${staffItem.lastName}',
                                  ),
                                  choiceStyle:
                                      const S2ChoiceStyle(outlined: true),
                                  choiceActiveStyle: S2ChoiceStyle(
                                    outlined: false,
                                    color: AppColor().primary,
                                  ),
                                  modalConfig: const S2ModalConfig(
                                    type: S2ModalType.bottomSheet,
                                    useFilter: true,
                                    maxHeightFactor: .7,
                                    useConfirm: true,
                                    confirmLabel: Text('Confirm'),
                                  ),
                                  tileBuilder: (context, state) {
                                    return S2Tile.fromState(
                                      state,
                                      isTwoLine: true,
                                      leading: Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        width: 80,
                                        child: AppWidget().textTitle(
                                          title: 'Staff * :',
                                          size: 12,
                                          color: AppColor().info,
                                        ),
                                      ),
                                      title: AppWidget().textNormal(
                                        title: 'Select Staff',
                                        size: 15,
                                        color: AppColor().info,
                                      ),
                                      value: AppWidget().textNormal(
                                        title: updateInfoController
                                                .assigneeId.isEmpty
                                            ? 'No Staff\'s assign'
                                            : updateInfoController
                                                        .assigneeId.length ==
                                                    1
                                                ? '${updateInfoController.assigneeId.length} Staff'
                                                : '${updateInfoController.assigneeId.length} Staffs',
                                        size: 13,
                                        color: AppColor().accent1,
                                      ),
                                    );
                                  },
                                ),
                              );
                      })
                    : Obx(
                        () => Get.find<CommentController>()
                                    .documentDetailResModel
                                    .value
                                    .errorCode ==
                                null
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getStorage.read('username') ==
                                          commentController
                                              .documentDetailResModel
                                              .value
                                              .documentInfo!
                                              .submisssionToBOM
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 12),
                                          child: AppWidget().textTitle(
                                            title: 'Board of Manager',
                                            size: 15,
                                            color: AppColor().info,
                                          ),
                                        )
                                      : Container(),
                                  getStorage.read('username') ==
                                          commentController
                                              .documentDetailResModel
                                              .value
                                              .documentInfo!
                                              .submisssionToBOM
                                      ? Get.arguments['icBOM'] ==
                                                  getStorage.read('username') ||
                                              getStorage.read('roleId') == 'BOM'
                                          ? Container()
                                          : Obx(() {
                                              return Get.find<BOMController>()
                                                          .bomResModel
                                                          .value
                                                          .errorCode ==
                                                      null
                                                  ? Container()
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColor().accent2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: SmartSelect<
                                                          String?>.single(
                                                        title:
                                                            'Assign In Charge BOM',
                                                        selectedValue:
                                                            updateInfoController
                                                                .vicePresidentId,
                                                        choiceItems:
                                                            S2Choice.listFrom(
                                                          source: bomItems
                                                              .value.bOM!,
                                                          value: (index,
                                                                  bomItem) =>
                                                              '${bomItem.bomID}',
                                                          title: (index,
                                                                  bomItem) =>
                                                              '${bomItem.bomName}',
                                                        ),
                                                        modalType: S2ModalType
                                                            .bottomSheet,
                                                        modalConfig:
                                                            const S2ModalConfig(
                                                          type: S2ModalType
                                                              .bottomSheet,
                                                          useFilter: true,
                                                          maxHeightFactor: .7,
                                                        ),
                                                        onChange: (selected) {
                                                          setState(() {
                                                            updateInfoController
                                                                    .vicePresidentId =
                                                                selected.value!;
                                                            updateInfoController
                                                                    .vicePresidentName =
                                                                selected.choice!
                                                                    .title!;
                                                          });
                                                        },
                                                        tileBuilder:
                                                            (context, state) {
                                                          return S2Tile
                                                              .fromState(
                                                            state,
                                                            isTwoLine: true,
                                                            leading: Container(
                                                              width: 105,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 3.5),
                                                              child: AppWidget()
                                                                  .textTitle(
                                                                title:
                                                                    'In Charge BOM :',
                                                                size: 13,
                                                                color:
                                                                    AppColor()
                                                                        .info,
                                                              ),
                                                            ),
                                                            title: AppWidget()
                                                                .textNormal(
                                                              title:
                                                                  'Select BOM',
                                                              size: 15,
                                                              color: AppColor()
                                                                  .info,
                                                            ),
                                                            value: AppWidget()
                                                                .textNormal(
                                                              title: updateInfoController
                                                                      .vicePresidentName
                                                                      .isEmpty
                                                                  ? 'No BOM\'s assign'
                                                                  : updateInfoController
                                                                      .vicePresidentName,
                                                              size: 13,
                                                              color: AppColor()
                                                                  .accent1,
                                                            ),
                                                            trailing:
                                                                updateInfoController
                                                                        .vicePresidentId
                                                                        .isEmpty
                                                                    ? Icon(
                                                                        CupertinoIcons
                                                                            .forward,
                                                                        color: Colors
                                                                            .grey,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            updateInfoController.vicePresidentId =
                                                                                '';
                                                                            updateInfoController.vicePresidentName =
                                                                                '';
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .clear_rounded,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                            })
                                      : Container(),
                                  getStorage.read('roleId') == 'BOM'
                                      ? Container()
                                      : Obx(() {
                                          return Get.find<BOMController>()
                                                      .bomResModel
                                                      .value
                                                      .errorCode ==
                                                  null
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 12),
                                                  decoration: BoxDecoration(
                                                    color: AppColor().accent2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: SmartSelect.multiple(
                                                    title:
                                                        'Assign Coordinate BOM',
                                                    selectedValue:
                                                        updateInfoController
                                                            .coorVicePresident,
                                                    onChange: (selected) {
                                                      setState(() {
                                                        updateInfoController
                                                                .coorVicePresident =
                                                            selected.value;
                                                        if (selected.title !=
                                                            null) {
                                                          updateInfoController
                                                                  .coorVicePresidentName =
                                                              selected.title!;
                                                        }
                                                      });
                                                    },
                                                    choiceType:
                                                        S2ChoiceType.chips,
                                                    choiceItems:
                                                        S2Choice.listFrom(
                                                      source:
                                                          bomItems.value.bOM!,
                                                      value: (index, bomItem) =>
                                                          '${bomItem.bomID}',
                                                      title: (index, bomItem) =>
                                                          '${bomItem.bomName}',
                                                    ),
                                                    choiceStyle:
                                                        const S2ChoiceStyle(
                                                            outlined: true),
                                                    choiceActiveStyle:
                                                        S2ChoiceStyle(
                                                      outlined: false,
                                                      color: AppColor().primary,
                                                    ),
                                                    modalConfig:
                                                        const S2ModalConfig(
                                                      type: S2ModalType
                                                          .bottomSheet,
                                                      useFilter: true,
                                                      maxHeightFactor: .7,
                                                      useConfirm: true,
                                                      confirmLabel:
                                                          Text('Confirm'),
                                                    ),
                                                    tileBuilder:
                                                        (context, state) {
                                                      return S2Tile.fromState(
                                                        state,
                                                        isTwoLine: true,
                                                        leading: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          width: 105,
                                                          child: AppWidget()
                                                              .textTitle(
                                                            title:
                                                                'Coordinate BOM :',
                                                            size: 12,
                                                            color:
                                                                AppColor().info,
                                                          ),
                                                        ),
                                                        title: AppWidget()
                                                            .textNormal(
                                                          title: 'Select BOM',
                                                          size: 15,
                                                          color:
                                                              AppColor().info,
                                                        ),
                                                        value: AppWidget()
                                                            .textNormal(
                                                          title: updateInfoController
                                                                  .coorVicePresident
                                                                  .isEmpty
                                                              ? 'No BOM\'s assign'
                                                              : updateInfoController
                                                                          .coorVicePresident
                                                                          .length ==
                                                                      1
                                                                  ? '${updateInfoController.coorVicePresident.length} Member'
                                                                  : '${updateInfoController.coorVicePresident.length} Members',
                                                          size: 13,
                                                          color: AppColor()
                                                              .accent1,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                        }),
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    child: AppWidget().textTitle(
                                      title: 'Department / Branch',
                                      size: 15,
                                      color: AppColor().info,
                                    ),
                                  ),
                                  Obx(() {
                                    return Get.find<DirectorController>()
                                                .directorResModel
                                                .value
                                                .errorCode ==
                                            null
                                        ? Container()
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(top: 12),
                                            decoration: BoxDecoration(
                                              color: AppColor().accent2,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: SmartSelect.multiple(
                                              title:
                                                  'Assign In Charge Dept/Branch',
                                              selectedValue:
                                                  updateInfoController
                                                      .departmentId,
                                              onChange: (selected) {
                                                setState(() {
                                                  updateInfoController
                                                          .departmentId =
                                                      selected.value;
                                                  if (selected.title != null) {
                                                    updateInfoController
                                                            .departmentname =
                                                        selected.title!;
                                                  }
                                                });
                                              },
                                              choiceType: S2ChoiceType.chips,
                                              choiceItems: S2Choice.listFrom(
                                                source:
                                                    directorItems.value.unit!,
                                                value: (index, directorItem) =>
                                                    '${directorItem.unitID}',
                                                title: (index, directorItem) =>
                                                    '${directorItem.unitName}',
                                              ),
                                              choiceStyle: const S2ChoiceStyle(
                                                  outlined: true),
                                              choiceActiveStyle: S2ChoiceStyle(
                                                outlined: false,
                                                color: AppColor().primary,
                                              ),
                                              modalConfig: const S2ModalConfig(
                                                type: S2ModalType.bottomSheet,
                                                useFilter: true,
                                                maxHeightFactor: .7,
                                                useConfirm: true,
                                                confirmLabel: Text('Confirm'),
                                              ),
                                              tileBuilder: (context, state) {
                                                return S2Tile.fromState(
                                                  state,
                                                  isTwoLine: true,
                                                  leading: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    width: 105,
                                                    child:
                                                        AppWidget().textTitle(
                                                      title:
                                                          'In Charge Dept/Branch * :',
                                                      size: 12,
                                                      color: AppColor().info,
                                                    ),
                                                  ),
                                                  title: AppWidget().textNormal(
                                                    title: 'Select Dept/Branch',
                                                    size: 15,
                                                    color: AppColor().info,
                                                  ),
                                                  value: AppWidget().textNormal(
                                                    title: updateInfoController
                                                            .departmentId
                                                            .isEmpty
                                                        ? 'No dept/branch assign'
                                                        : updateInfoController
                                                                    .departmentId
                                                                    .length ==
                                                                1
                                                            ? '${updateInfoController.departmentId.length} Dept/Branch'
                                                            : '${updateInfoController.departmentId.length} Depts/Branches',
                                                    size: 13,
                                                    color: AppColor().accent1,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                  }),
                                  Obx(() {
                                    return Get.find<DirectorController>()
                                                .directorResModel
                                                .value
                                                .errorCode ==
                                            null
                                        ? Container()
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(top: 12),
                                            decoration: BoxDecoration(
                                              color: AppColor().accent2,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: SmartSelect.multiple(
                                              title:
                                                  'Assign Coordinate Dept/Branch',
                                              selectedValue:
                                                  updateInfoController
                                                      .coorDepartmentId,
                                              onChange: (selected) {
                                                setState(() {
                                                  updateInfoController
                                                          .coorDepartmentId =
                                                      selected.value;
                                                  if (selected.title != null) {
                                                    updateInfoController
                                                            .coorDepartmentName =
                                                        selected.title!;
                                                  }
                                                });
                                              },
                                              choiceType: S2ChoiceType.chips,
                                              choiceItems: S2Choice.listFrom(
                                                source:
                                                    directorItems.value.unit!,
                                                value: (index, directorItem) =>
                                                    '${directorItem.unitID}',
                                                title: (index, directorItem) =>
                                                    '${directorItem.unitName}',
                                              ),
                                              choiceStyle: const S2ChoiceStyle(
                                                  outlined: true),
                                              choiceActiveStyle: S2ChoiceStyle(
                                                outlined: false,
                                                color: AppColor().primary,
                                              ),
                                              modalConfig: const S2ModalConfig(
                                                type: S2ModalType.bottomSheet,
                                                useFilter: true,
                                                maxHeightFactor: .7,
                                                useConfirm: true,
                                                confirmLabel: Text('Confirm'),
                                              ),
                                              tileBuilder: (context, state) {
                                                return S2Tile.fromState(
                                                  state,
                                                  isTwoLine: true,
                                                  leading: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    width: 105,
                                                    child:
                                                        AppWidget().textTitle(
                                                      title:
                                                          'Coordinate Dept/Branch :',
                                                      size: 12,
                                                      color: AppColor().info,
                                                    ),
                                                  ),
                                                  title: AppWidget().textNormal(
                                                    title: 'Select Dept/Branch',
                                                    size: 15,
                                                    color: AppColor().info,
                                                  ),
                                                  value: AppWidget().textNormal(
                                                    title: updateInfoController
                                                            .coorDepartmentId
                                                            .isEmpty
                                                        ? 'No dept/branch assign'
                                                        : updateInfoController
                                                                    .coorDepartmentId
                                                                    .length ==
                                                                1
                                                            ? '${updateInfoController.coorDepartmentId.length} Dept/Branch'
                                                            : '${updateInfoController.coorDepartmentId.length} Depts/Branches',
                                                    size: 13,
                                                    color: AppColor().accent1,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                  }),
                                ],
                              ),
                      ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: AppWidget().textTitle(
                    title: 'Report',
                    size: 15,
                    color: AppColor().info,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 105,
                        child: AppWidget().textTitle(
                          title: 'Report Date :',
                          size: 12,
                          color: AppColor().info,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AppWidget().textNormal(
                                title: commentController.dateValue[0] == null
                                    ? 'Select date'
                                    : commentController.formatDateTime(
                                        commentController.dateValue[0]!,
                                      ),
                                size: 14,
                                color: AppColor().info,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AppWidget().shortButtonWidget(
                              text: 'Select Date >>',
                              fontColor: AppColor().info,
                              color: AppColor().accent2,
                              fontSize: 12,
                              radius: 20,
                              borderColor: AppColor().info,
                              action: () {
                                return AppWidget().customPopup(
                                  context: context,
                                  widget: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DateSinglePicker(),
                                    ],
                                  ),
                                  actionTitle: 'Okay',
                                  action: () {
                                    Get.back();
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      setState(() {
                                        commentController.getValueText(
                                          commentController.config.calendarType,
                                          commentController.dateValue,
                                        );
                                        commentController.submitData();
                                      });
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  commentTask() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Comment',
              color: AppColor().info,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              controller: updateInfoController.commentTaskTextField,
              obscureText: false,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Comment here...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primaryText,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: AppColor().info,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 10,
              minLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  commentSubTask() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Comment',
              color: AppColor().info,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              controller: updateInfoController.commentSubTaskTextField,
              obscureText: false,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Comment here...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primaryText,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: AppColor().info,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 10,
              minLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  updateForDept() {
    if (updateInfoController.assigneeId.isEmpty) {
      EasyLoading.show(status: 'loading...');

      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.showError(
          'Missing required field (*).',
          duration: const Duration(seconds: 2),
        );
        AppWidget().errorScackbar(
          title: 'Required',
          message: 'Missing required field (*).',
        );
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.show(status: 'loading...');
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          EasyLoading.dismiss();
          updateInfoController.assignedmentId = Get.arguments['assignmentId'];

          if (commentController.dateValue[0] != null) {
            updateInfoController.reportDateSubTask =
                commentController.formatDateTime(
              commentController.dateValue[0]!,
            );
          } else {
            updateInfoController.reportDateSubTask = '';
          }

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                content: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColor().primary,
                          ),
                          const SizedBox(width: 4),
                          AppWidget().textTitle(
                            title: 'Confirmation',
                            size: 18,
                            color: AppColor().primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: AppWidget().textNormal(
                          title:
                              'Please confirm your acceptance of the update assigned task.',
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  AppWidget().shortButtonWidget(
                    text: 'Cancel',
                    fontColor: AppColor().primary,
                    color: AppColor().info,
                    borderColor: AppColor().primary,
                    topPad: 10,
                    bottomPad: 10,
                    rightPad: 22,
                    leftPad: 18,
                    action: () {
                      Get.back();
                    },
                  ),
                  AppWidget().shortButtonWidget(
                    text: 'Submit',
                    fontColor: AppColor().info,
                    color: AppColor().primary,
                    topPad: 10,
                    bottomPad: 10,
                    rightPad: 22,
                    leftPad: 18,
                    action: () {
                      updateInfoController.submitSubTaskData();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  updateForBOM() {
    if (updateInfoController.departmentId.isEmpty) {
      EasyLoading.show(status: 'loading...');

      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.showError(
          'Missing required field (*).',
          duration: const Duration(seconds: 2),
        );
        AppWidget().errorScackbar(
          title: 'Required',
          message: 'Missing required field (*).',
        );
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.show(status: 'loading...');
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          EasyLoading.dismiss();
          updateInfoController.assignedmentId = Get.arguments['assignmentId'];

          if (commentController.dateValue[0] != null) {
            updateInfoController.reportDateTask =
                commentController.formatDateTime(
              commentController.dateValue[0]!,
            );
          } else {
            updateInfoController.reportDateTask = '';
          }

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                content: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColor().primary,
                          ),
                          const SizedBox(width: 4),
                          AppWidget().textTitle(
                            title: 'Confirmation',
                            size: 18,
                            color: AppColor().primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: AppWidget().textNormal(
                          title:
                              'Please confirm your acceptance of the update assigned task.',
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  AppWidget().shortButtonWidget(
                    text: 'Cancel',
                    fontColor: AppColor().primary,
                    color: AppColor().info,
                    borderColor: AppColor().primary,
                    topPad: 10,
                    bottomPad: 10,
                    rightPad: 22,
                    leftPad: 18,
                    action: () {
                      Get.back();
                    },
                  ),
                  AppWidget().shortButtonWidget(
                    text: 'Submit',
                    fontColor: AppColor().info,
                    color: AppColor().primary,
                    topPad: 10,
                    bottomPad: 10,
                    rightPad: 22,
                    leftPad: 18,
                    action: () {
                      updateInfoController.submitTaskData();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }
}

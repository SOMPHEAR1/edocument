// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/proposal_detail_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import 'view_pdf.dart';

class ProposalDetailScreen extends StatefulWidget {
  ProposalDetailScreen({super.key});

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends State<ProposalDetailScreen> {
  final ProposalDetailController proposalDetailController =
      Get.put(ProposalDetailController(documentID: Get.arguments['docID']));

  @override
  Widget build(BuildContext context) {
    final item = proposalDetailController.proposalDetailResModel;

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: ListView(
            children: [
              AppWidget().newAppBar(
                title: 'Document Detail',
                context: context,
              ),
              Obx(() {
                return Get.find<ProposalDetailController>()
                            .proposalDetailResModel
                            .value
                            .documentInfo ==
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
                        title: '${item.value.documentInfo!.documentTitle}',
                      );
              }),
              document(),
              const SizedBox(height: 16),
              AppWidget().buttonWidget(
                text: 'Okay',
                fontColor: AppColor().info,
                color: AppColor().secondary,
                borderColor: AppColor().info,
                action: () => Navigator.pop(context),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  document() {
    final item = proposalDetailController.proposalDetailResModel;

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
              return Get.find<ProposalDetailController>()
                          .proposalDetailResModel
                          .value
                          .documentInfo ==
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
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
                                    action: () async {
                                      var dir =
                                          await getApplicationDocumentsDirectory();
                                      Get.to(
                                        () => ViewPdfScreen( ),
                                        arguments: {
                                          'fileID':
                                              '${item.value.documentInfo!.listOfFiles![index].fileId}',
                                          'fileName':
                                              '${File("${dir.path}/${item.value.documentInfo!.listOfFiles![index].fileName}")}',
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
}

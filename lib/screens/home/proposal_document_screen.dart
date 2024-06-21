// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/proposal_document_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import 'comment_screen.dart';

class ProposalDocumentScreen extends StatefulWidget {
  ProposalDocumentScreen({super.key});

  @override
  State<ProposalDocumentScreen> createState() => _ProposalDocumentScreenState();
}

class _ProposalDocumentScreenState extends State<ProposalDocumentScreen> {
  final ProposalDocumentController proposalDocumentController =
      Get.put(ProposalDocumentController(
    issuePlace: Get.arguments['issuePlace'],
  ));

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: Scaffold(
        backgroundColor: AppColor().primary.withOpacity(0.85),
        appBar: AppWidget().customAppBar(),
        body: AppWidget().pullRefresh(
          action: () {
            setState(() {
              proposalDocumentController.submitProposalData();
            });
          },
          child: ListView(
            children: [
              AppWidget().newAppBar(
                title: 'Released by ${proposalDocumentController.issuePlace}',
                context: context,
              ),
              Get.arguments['documentType'] == 'Task'
                  ? Container()
                  : newDocument(),
              assigned(),
            ],
          ),
        ),
      ),
    );
  }

  newDocument() {
    final item = proposalDocumentController.proposalDocumentResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'New',
              color: AppColor().info,
            ),
          ),
          Obx(() {
            return Get.find<ProposalDocumentController>()
                        .proposalDocumentResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : item.value.newDocument == null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: AppWidget().textTitle(
                          title: 'No Document',
                          color: AppColor().info,
                        ),
                      )
                    : SizedBox(
                        height: 250,
                        width: Get.width,
                        child: ListView.builder(
                          itemCount: item.value.newDocument!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: index == 0 ? 15 : 0),
                              child: AppWidget().newDocItem(
                                context: context,
                                title: proposalDocumentController.issuePlace,
                                docTitle:
                                    '${item.value.newDocument![index].documentTitle}',
                                docNumber:
                                    '${item.value.newDocument![index].documentNumber}',
                                countFile: int.parse(
                                    '${item.value.newDocument![index].noOfFiles}'),
                                date:
                                    '${item.value.newDocument![index].submissionDateTime}',
                                action: () => Get.to(
                                  () => CommentScreen(),
                                  arguments: {
                                    'docID':
                                        '${item.value.newDocument![index].documentId}',
                                    'documentType': 'new',
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
          })
        ],
      ),
    );
  }

  assigned() {
    final proposalItem = proposalDocumentController.proposalDocumentResModel;

    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: AppWidget().textLargeTitle(
                title: 'Assigned',
                color: AppColor().info,
              ),
            ),
            Get.find<ProposalDocumentController>()
                        .proposalDocumentResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : proposalItem.value.assignedDocument == null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 12),
                        child: AppWidget().textTitle(
                          title: 'No Document',
                          color: AppColor().info,
                        ),
                      )
                    : ListView.builder(
                        itemCount: min(
                            proposalDocumentController.visibleItemCount,
                            proposalItem.value.assignedDocument!.length),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AppWidget().assignDocItem(
                                context: context,
                                docNumber:
                                    '${proposalItem.value.assignedDocument![index].documentNumber}',
                                docTitle:
                                    '${proposalItem.value.assignedDocument![index].documentTitle}',
                                assignDate:
                                    '${proposalItem.value.assignedDocument![index].submissionDateTime}',
                                action: () {
                                  return Get.to(
                                    () => CommentScreen(),
                                    arguments: {
                                      'docID':
                                          '${proposalItem.value.assignedDocument![index].documentId}',
                                      'documentType': 'assigned',
                                    },
                                  );
                                }),
                          );
                        },
                      ),
            proposalItem.value.assignedDocument == null
                ? Container()
                : proposalDocumentController.visibleItemCount <
                        proposalItem.value.assignedDocument!.length
                    ? GestureDetector(
                        onTap: () {
                          EasyLoading.show(status: 'Loading...');

                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              proposalDocumentController.loadMoreItems(
                                  proposalItem.value.assignedDocument!.length);
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
        ),
      );
    });
  }
}

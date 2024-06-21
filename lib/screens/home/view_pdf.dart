// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:e_document_app/services/file_manager/open_file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/view_pdf_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/color.dart';

class ViewPdfScreen extends StatefulWidget {
  final String? path;

  const ViewPdfScreen({Key? key, this.path}) : super(key: key);

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen>
    with WidgetsBindingObserver {
  final Completer<PDFViewController> controller =
      Completer<PDFViewController>();

  ViewPDFController viewPDFController = Get.put(
    ViewPDFController(
      fileId: Get.arguments['fileID'],
      fileName: Get.arguments['fileName'],
    ),
  );

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = true;
  String errorMessage = '';
  String? filePath;

  @override
  void dispose() {
    super.dispose();
    // Clean up resources if needed
  }

  @override
  void initState() {
    super.initState();
    _loadFilePath();
  }

  Future<void> _loadFilePath() async {
    try {
      var dir = '';
      if (Platform.isAndroid) {
        dir = (await DownloadsPath.downloadsDirectory())?.path ??
            "Downloads path doesn't exist";
      } else if (Platform.isIOS) {
        dir = (await getApplicationDocumentsDirectory()).path;
      }
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      var bytes = await viewPDFController.fetchFileBytes();
      var file_name = "";
      if(Platform.isAndroid){
        file_name = generateUniqueFileName(dir.toString(), viewPDFController.fileName);
      }else{
        file_name = "${dir.toString()}/${viewPDFController.fileName}";
      }
      File file = File(file_name);
      // Use await to ensure that the file write operation completes before moving forward
      await file.writeAsBytes(bytes, flush: true);
      if (Platform.isAndroid) {
        if (await file.exists()) {
          openFileManager();
        }
      }
      if (Platform.isIOS) {
        if (await file.exists()) {
          await OpenFile.open(file.path);
        }
      }
      Get.back();
    } catch (e) {
      log('Error loading file path: $e');
    }
  }
  String generateUniqueFileName(String dir, String fileName) {
    var baseName = fileName;
    var counter = 0;
    while (File('${dir.toString()}/$baseName').existsSync()) {
      counter++;
      baseName = '($counter)$fileName';
    }
    if(counter == 0){
      baseName = fileName;
    }
    return '${dir.toString()}/$baseName';
  }

  Future<String> getFilePath() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      if (viewPDFController.fileName != '') {
        // Replace this line with the actual logic to fetch file bytes
        var bytes = await viewPDFController.fetchFileBytes();

        File file = File("${dir.path}/${viewPDFController.fileName}");

        // Use await to ensure that the file write operation completes before moving forward
        await file.writeAsBytes(bytes, flush: true);

        return file.path;
      } else {
        return "";
      }
    } catch (e) {
      log('Error getting file path: $e');
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    log('$filePath');

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: filePath != null
                    ? viewPDFController.fileName
                                .split('.')
                                .last
                                .toLowerCase() ==
                            'pdf'
                        ? PDFView(
                            filePath: filePath,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: true,
                            pageSnap: true,
                            defaultPage: currentPage!,
                            fitPolicy: FitPolicy.BOTH,
                            preventLinkNavigation: false,
                            onRender: (_pages) {
                              log('onRender: ${widget.path}');
                              setState(() {
                                pages = _pages;
                                isReady = true;
                              });
                            },
                            onError: (error) {
                              log('onError: ${widget.path}');
                              setState(() {
                                errorMessage = error.toString();
                              });
                              log('Error: ${error.toString()}');
                            },
                            onPageError: (page, error) {
                              log('onPageError: ${widget.path}');
                              setState(() {
                                errorMessage = '$page: ${error.toString()}';
                              });
                              log('$page: ${error.toString()}');
                            },
                            onViewCreated:
                                (PDFViewController pdfViewController) {
                              log('onViewCreated: ${widget.path}');
                              controller.complete(pdfViewController);
                            },
                            onLinkHandler: (String? uri) {
                              log('goto uri: $uri');
                            },
                            onPageChanged: (int? page, int? total) {
                              log('page change: $page/$total');
                              setState(() {
                                currentPage = page;
                              });
                            },
                          )
                        : SizedBox(
                            width: Get.width,
                            child:
                                filePath != null && File(filePath!).existsSync()
                                    ? Image.file(
                                        File('$filePath'),
                                        fit: BoxFit.contain,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          // Handle the error here
                                          log('Error loading image: $error');
                                          // Display a placeholder image or an error message for invalid image data
                                          return Image.asset(
                                            'assets/invalid_image.png', // Replace with your placeholder image for invalid data
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      )
                                    : const Text('File not found'),
                          )
                    : AppWidget().loadingIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

class TicketOverviewViewModel extends ChangeNotifier {
  String? filePath;
  bool isImageAvailable = false;
  bool isImageProcessing = false;
  Uint8List? imageBytes;
  double? prevBrightness;

  Future init() async {
    if (imageBytes == null) {
      isImageProcessing = true;
      filePath = await getApplicationDocumentsDirectory()
          .then((dir) => "${dir.path}/semester_ticket.dat");
      isImageAvailable = await getIsImageAvailable();

      if (isImageAvailable) {
        await loadImageData();
      }

      isImageProcessing = false;
      notifyListeners();
      return true;
    }
  }

  Future loadImageData() {
    if (filePath != null) {
      return File(filePath!).readAsBytes().then((data) {
        imageBytes = data;
        isImageAvailable = true;
        notifyListeners();
      });
    }

    return Future.value();
  }

  Future<bool> getIsImageAvailable() {
    if (filePath != null) {
      return File(filePath!).exists();
    }

    return Future.value(false);
  }

  Future extractImageFromPdf(String pdfPath) async {
    isImageProcessing = true;
    notifyListeners();

    final rawImageBytes = await PdfDocument.openFile(pdfPath).then((file) {
      return file.getPage(1).then((page) {
        return page
            .render(
                x: 400,
                y: 200,
                width: 1800,
                height: 1300,
                fullHeight: 5656,
                fullWidth: 4000)
            .then((fragment) {
          return fragment
              .createImageIfNotAvailable()
              .then((image) => image.toByteData(format: ImageByteFormat.png));
        });
      });
    });

    getApplicationDocumentsDirectory().then((directory) {
      File("${directory.path}/semester_ticket.dat")
          .writeAsBytes(rawImageBytes!.buffer.asUint8List(
              rawImageBytes.offsetInBytes, rawImageBytes.lengthInBytes))
          .then((result) {
        loadImageData();
        isImageProcessing = false;
      });
    });
  }

  Future deleteTicket() {
    if (isImageAvailable) {
      return File(filePath!).delete().then((result) {
        isImageAvailable = false;
        notifyListeners();
      });
    }

    return Future.value();
  }
}

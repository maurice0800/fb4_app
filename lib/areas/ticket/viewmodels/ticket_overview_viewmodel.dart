import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fb4_app/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketOverviewViewModel extends ChangeNotifier {
  String filePath;
  bool isImageAvailable = false;
  bool isImageProcessing = false;
  Uint8List imageBytes;

  Future<bool> init() async {
    isImageProcessing = true;
    filePath = await getApplicationDocumentsDirectory()
        .then((dir) => dir.path + "/semester_ticket.dat");
    isImageAvailable = await getIsImageAvailable();

    if (isImageAvailable) {
      await loadImageData();
    }

    isImageProcessing = false;
    return true;
  }

  Future loadImageData() {
    return File(filePath).readAsBytes().then((data) {
      imageBytes = data;
      isImageAvailable = true;
      notifyListeners();

      SharedPreferences.getInstance().then((s) {
        if (s.getBool(
            AppConstants.settingsIncreaseDisplayBrightnessInTicketview)) {
          Screen.setBrightness(100);
        }
      });
    });
  }

  Future<bool> getIsImageAvailable() {
    return File(filePath).exists();
  }

  Future extractImageFromPdf(String pdfPath) async {
    isImageProcessing = true;
    notifyListeners();

    var rawImageBytes = await PdfDocument.openFile(pdfPath).then((file) {
      return file.getPage(1).then((page) {
        return page
            .render(
                x: 360,
                y: 120,
                width: 2000,
                height: 2800,
                fullWidth: 4800,
                fullHeight: 6000)
            .then((fragment) {
          return fragment
              .createImageIfNotAvailable()
              .then((image) => image.toByteData(format: ImageByteFormat.png));
        });
      });
    });

    getApplicationDocumentsDirectory().then((directory) {
      File(directory.path + "/semester_ticket.dat")
          .writeAsBytes(rawImageBytes.buffer.asUint8List(
              rawImageBytes.offsetInBytes, rawImageBytes.lengthInBytes))
          .then((result) {
        loadImageData();
        isImageProcessing = false;
      });
    });
  }

  Future deleteTicket() {
    return File(filePath).delete().then((result) {
      isImageAvailable = false;
      notifyListeners();
    });
  }
}

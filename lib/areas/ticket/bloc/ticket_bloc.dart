import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

part 'ticket_state.dart';
part 'ticket_event.dart';

class TicketBloc extends Bloc<TicketBlocEvent, TicketBlocState> {
  String filePath;
  TicketBloc() : super(TicketInitialState());

  Future init() async {
    filePath = await getApplicationDocumentsDirectory()
        .then((dir) => dir.path + "/semester_ticket.dat");
  }

  @override
  Stream<TicketBlocState> mapEventToState(
    TicketBlocEvent event,
  ) async* {
    if (event is GetTicketEvent) {
      // Load existing ticket
      yield TicketLoadingState();

      // File(filePath).deleteSync();
      var exists = await File(filePath).exists();

      if (exists) {
        var fileContent = await File(filePath).readAsBytes();
        yield TicketLoadedState(fileContent);
      } else {
        yield TicketNotFoundState();
      }
    } else if (event is AddNewTicketEvent) {
      // Save new ticket
      var rawImageBytes =
          await PdfDocument.openFile(event.filePath).then((file) {
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

      await getApplicationDocumentsDirectory().then((directory) {
        File(directory.path + "/semester_ticket.dat")
            .writeAsBytes(rawImageBytes.buffer.asUint8List(
                rawImageBytes.offsetInBytes, rawImageBytes.lengthInBytes))
            .then((file) => print("[DEBUG] Ticket saved with a size of: " +
                file.lengthSync().toString() +
                " bytes"));
      });

      yield TicketSavedState();
    } else if (event is DeleteTicketEvent) {
      if (await File(filePath).exists()) {
        await File(filePath).delete();
        yield TicketDeletedState();
      }
    }
  }
}

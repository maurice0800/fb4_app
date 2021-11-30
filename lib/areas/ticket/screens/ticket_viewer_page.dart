import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class TicketViewerPage extends StatefulWidget {
  @override
  State<TicketViewerPage> createState() => _TicketViewerPageState();
}

class _TicketViewerPageState extends State<TicketViewerPage> {
  final TransformationController _transformationController =
      TransformationController();

  late TapDownDetails? _tapDownDetails;

  bool _isZoomed = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ColorConsts.mainOrange,
        middle: Text("Semesterticket",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
      ),
      child: SafeArea(
        child: buildTicketView(context),
      ),
    );
  }

  Widget buildSelectTicket(
      BuildContext context, TicketOverviewViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Du hast noch kein Ticket ausgewählt.",
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
          const SizedBox(height: 20),
          CupertinoButton.filled(
              child: const Text("Ticket wählen",
                  style: TextStyle(color: CupertinoColors.white)),
              onPressed: () {
                FilePicker.platform.pickFiles().then((result) => {
                      if (result != null)
                        {
                          viewModel
                              .extractImageFromPdf(result.files.first.path!),
                        }
                    });
              })
        ],
      ),
    );
  }

  Widget buildTicketView(BuildContext context) {
    return BaseView<TicketOverviewViewModel>(
        onViewModelCreated: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) {
          if (viewModel.isImageProcessing) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (viewModel.isImageAvailable) {
            return Center(
              child: GestureDetector(
                onDoubleTap: _handleDoubleTap,
                onDoubleTapDown: (details) => _tapDownDetails = details,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 1000),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    child: Image.memory(viewModel.imageBytes!),
                  ),
                ),
              ),
            );
          }

          return buildSelectTicket(context, viewModel);
        });
  }

  void _handleDoubleTap() {
    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();
      _isZoomed = false;
    } else {
      _transformationController.value = Matrix4.identity()
        ..translate(-_tapDownDetails!.localPosition.dx,
            -_tapDownDetails!.localPosition.dy)
        ..scale(2.2);
      _isZoomed = true;
    }
  }
}

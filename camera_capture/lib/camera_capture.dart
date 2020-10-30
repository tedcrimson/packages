library camera_capture;

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_previewer/gallery_previewer.dart';
import 'package:path_provider/path_provider.dart';

typedef Future<List<Uint8List>> SelectPicture(BuildContext context, List<Uint8List> images);

class CameraPage extends StatefulWidget {
  final int cameraIndex;
  final bool multiSelect;
  final Widget overlay;
  final SelectPicture onSelectImages;

  CameraPage({this.cameraIndex = 0, this.multiSelect = true, this.overlay, this.onSelectImages});

  @override
  _CameraPageState createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController controller;
  String imagePath;
  int cameraIndex;
  List<CameraDescription> cameras = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    cameraIndex = widget.cameraIndex;
    availableCameras().then((c) {
      cameras = c;
      if (cameras != null && cameras.length > 0) onNewCameraSelected(cameras[cameraIndex]);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          _cameraPreviewWidget(),
          if (widget.overlay != null) widget.overlay,
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.switch_camera,
                        size: 36,
                        color: Colors.white,
                      ),
                      onPressed: controller == null
                          ? null
                          : () {
                              cameraIndex = cameraIndex == 0 ? 1 : 0;
                              onNewCameraSelected(cameras[cameraIndex]);
                            },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 4),
                            shape: BoxShape.circle,
                            color: Colors.transparent),
                        child: Container(
                          // padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        ),
                      ),
                      onTap: controller == null ? null : onTakePictureButtonPressed,
                    ),
                  ),
                  // Spacer(),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // NavigatorManager.showBottomPanel(context, _getUpperLayer());
                          scaffoldKey.currentState.showBottomSheet((_) => _getUpperLayer());
                        }),
                  ),
                ],
              ),
            ),
          ),
          // RubberBottomSheet(
          //   scrollController: _scrollController,
          //   lowerLayer: Container(
          //       // color: Colors.blue,
          //       ),
          //   header: Container(
          //     height: 40,
          //     color: Colors.white10,
          //     child: Row(
          //       children: <Widget>[
          //         Spacer(
          //           flex: 4,
          //         ),
          //         Expanded(
          //           flex: 2,
          //           child: Image.asset(
          //             'assets/scroll.png',
          //             // width: 60,
          //             height: 20,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //         Spacer(
          //           flex: 4,
          //         ),
          //       ],
          //     ),
          //   ),
          //   headerHeight: 40,
          //   upperLayer: _getUpperLayer(),
          //   animationController: _controller,
          // ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Container(
            width: controller.value.previewSize.height,
            height: controller.value.previewSize.width,
            // constraints: BoxConstraints.loose(controller.value.previewSize),
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    print(message);
    return;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high, enableAudio: false);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
      File file = File(filePath);
      List<Uint8List> images = [file.readAsBytesSync()];
      if (widget.onSelectImages != null) {
        images = await widget.onSelectImages(context, images);
      } else {
        Navigator.of(context).pop(images);
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    print(e.code + " " + e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  _getUpperLayer() {
    return DraggableScrollableSheet(
      maxChildSize: 0.8,
      initialChildSize: 0.8,
      minChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) => Container(
        color: Colors.white10,
        alignment: Alignment.topCenter,
        child: GalleryPreviewer(
            // controller: _scrollController,
            height: double.infinity,
            // controller: scrollController,
            physics: NeverScrollableScrollPhysics(),
            onTap: (List<Uint8List> images) async {
              Navigator.of(context).pop();
              var _images = images;

              if (widget.onSelectImages != null) {
                _images = await widget.onSelectImages(context, _images);
              } else {}
              Navigator.of(context).pop(_images);
            },
            collapsed: false,
            multiSelect: widget.multiSelect),
      ),
    );
  }
}

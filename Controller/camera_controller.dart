import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import 'package:file_picker/file_picker.dart';
import '../export.dart';

typedef OnRotatedOverLayer = Widget Function(bool isPortrait);

/// Convenience Image Picker.
Future<File?> showImagePicker(BuildContext context, {bool customCamera = true, bool includedFilePicker = false}) async {
  int? index;
  if (Platform.isIOS) {
    index = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: Text('\nWhere would you like your image picked?\n'),
              //message: Text('options:'),
              actions: [
                CupertinoActionSheetAction(
                    child: Text('Camera'),
                    onPressed: () {
                      Get.back(result: 1);
                    }),
                CupertinoActionSheetAction(
                    child: Text('Photo Gallery'),
                    onPressed: () {
                      Get.back(result: 2);
                    }),
                if (includedFilePicker)
                  CupertinoActionSheetAction(
                      child: Text('File Picker'),
                      onPressed: () {
                        Get.back(result: 3);
                      }),
              ],
              cancelButton: CupertinoActionSheetAction(onPressed: Get.back, child: Text('Cancel')));
        });
  } else {
    index = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 8, bottom: 5),
                child: Text('\nWhere would you like your image picked?\n', style: TextStyle(fontSize: 15)),
              ),
              line(horizontal: 10),
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Get.back(result: 1);
                  }),
              ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Photo Gallery'),
                  onTap: () {
                    Get.back(result: 2);
                  }),
              if (includedFilePicker)
                ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: Text('File Picker'),
                    onTap: () {
                      Get.back(result: 3);
                    }),
              line(horizontal: 10),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: Get.back,
              ),
            ],
          );
        });
  }
  File? pickedFile;
  switch (index) {
    case 1:
      if (customCamera) {
        pickedFile = await showCameraController();
      } else {
        XFile? xFile = await ImagePicker().pickImage(source: img_picker.ImageSource.camera);
        pickedFile = (xFile == null) ? null : File(xFile.path);
      }
      break;
    case 2:
      try {
        XFile? xFile = await ImagePicker().pickImage(source: img_picker.ImageSource.gallery);
        pickedFile = (xFile == null) ? null : File(xFile.path);
      } catch (error) {
        print('Error: ${error.toString()}');
      }
      break;
    case 3:
      FilePickerResult? xFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );
      if (xFile != null) pickedFile = File(xFile.files.single.path ?? '');
      break;
    default:
      break;
  }
  return pickedFile;
}


/// ProX Custom Camera Controller.
/// [addFrontLayer] Return true if orientation is portrait mode, else false.
Future<File?> showCameraController({CameraLensDirection? lensDirection, OnRotatedOverLayer? addFrontLayer}) {
  return Get.to(CameraProXPage(),
      binding: CameraProXBinding(lensDirection ?? CameraLensDirection.back, addFrontLayer))!;
}

/*
// Example:
File file = await showCameraController(addFrontLayer: (isPortrait) {
                    return Container(
                        child: Column(
                      children: [
                        Expanded(
                            flex: isPortrait ? 6 : 3,
                            child: Row(children: [
                              Expanded(child: Container(color: Colors.black45))
                            ])),
                        Expanded(
                            flex: isPortrait ? 5 : 7,
                            child: Row(children: [
                              Container(
                                  width: isPortrait ? 30 : 60,
                                  color: Colors.black45),
                              Expanded(child: Center()),
                              Container(
                                  width: isPortrait ? 30 : 60,
                                  color: Colors.black45),
                            ])),
                        Expanded(
                            flex: isPortrait ? 6 : 3,
                            child: Row(children: [
                              Expanded(child: Container(color: Colors.black45))
                            ])),
                      ],
                    ));
                  });

*/

class CameraProXBinding extends Bindings {
  final CameraLensDirection lensDirection;
  final OnRotatedOverLayer? addFrontLayer;
  CameraProXBinding(this.lensDirection, this.addFrontLayer);

  @override
  void dependencies() {
    Get.put(CameraProXController(lensDirection, addFrontLayer));
  }
}

class CameraProXController extends ProXController<CameraProXPage> with GetSingleTickerProviderStateMixin {
  final CameraLensDirection preferLensDirection;
  final OnRotatedOverLayer? extraLayout;
  AnimationController? lottieCtrl;
  Duration animateDuration = Duration(milliseconds: 1000);

  CameraProXController(this.preferLensDirection, this.extraLayout);

  List<CameraDescription> cameras = [];
  CameraController? controller;
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double currentScale = 1.0;
  double baseScale = 1.0;
  int pointers = 0;

  File? imageFile;
  String? error;

  CameraDescription? backLens;
  CameraDescription? frontLens;
  CameraDescription? externalLens;
  bool get haveBackLens => backLens != null;
  bool get haveFrontLens => frontLens != null;
  bool get haveExternalLens => externalLens != null;

  // Check is camera is bigger then screen.
  bool get cameraOverSized => Get.width / Get.height < 9 / 16;

  // Use when camera is bigger then screen.
  double get sizeToReduce => ((Get.height * 9 / 16) - Get.width) / 2;

  // Use when camera is smaller then screen.
  double get sizeToIncrease => (Get.width - (Get.height * 9 / 16)) / 2;

  @override
  void onInit() async {
    lottieCtrl = AnimationController(vsync: this);
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        backLens = cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.back,
            orElse: () =>
                CameraDescription(name: 'null', lensDirection: CameraLensDirection.back, sensorOrientation: 0));
        if (backLens!.name == 'null') backLens = null;
        frontLens = cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front,
            orElse: () =>
                CameraDescription(name: 'null', lensDirection: CameraLensDirection.front, sensorOrientation: 0));
        if (frontLens!.name == 'null') frontLens = null;
        externalLens = cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.external,
            orElse: () =>
                CameraDescription(name: 'null', lensDirection: CameraLensDirection.external, sensorOrientation: 0));
        if (externalLens!.name == 'null') externalLens = null;
        CameraDescription? preferredLens = cameras.firstWhere((e) => e.lensDirection == preferLensDirection,
            orElse: () => CameraDescription(name: 'null', lensDirection: preferLensDirection, sensorOrientation: 0));
        if (preferredLens.name == 'null') preferredLens = null;
        if (preferredLens != null) {
          onSelectNewCamera(preferredLens);
        } else if (haveBackLens) {
          onSelectNewCamera(backLens!);
        } else if (haveFrontLens) {
          onSelectNewCamera(frontLens!);
        } else {
          onSelectNewCamera(externalLens!);
        }
      } else {
        error = 'No camera found.';
        update();
      }
    } on CameraException catch (e) {
      logError(e.code, e.description ?? 'Unknown Camera Error 122');
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    controller?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onSelectNewCamera(controller!.description);
    }
  }

  void onSelectNewCamera(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
    );
    controller?.addListener(update);
    try {
      await controller?.initialize();
      List<Future> setting = [
        controller!.lockCaptureOrientation(DeviceOrientation.portraitUp),
        controller!.getMaxZoomLevel().then((value) => maxAvailableZoom = value),
        controller!.getMinZoomLevel().then((value) => minAvailableZoom = value),
      ];
      if (cameraDescription == backLens) setting.add(controller!.setFlashMode(FlashMode.off));
      await Future.wait(setting);
    } on CameraException catch (e) {
      logError(e.code, e.description ?? 'Unknown Camera Error 171');
    }
    didInit();
    update();
  }

  void onTakePictureButtonPressed(NativeDeviceOrientation orientation) {
    isLoading(true);
    _takePicture().then((XFile? file) async {
      final img.Image? capturedImage = img.decodeImage(await File(file!.path).readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      File _file = await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
      print('_file.path: ${_file.path}');
      ImageEditorOption editOption = ImageEditorOption();
      if (controller?.description.lensDirection == CameraLensDirection.front) {
        editOption.addOption(FlipOption(horizontal: true));
        editOption.addOption(RotateOption(getDegreeToRotate(orientation, isBackLens: Platform.isIOS)));
      } else {
        editOption.addOption(RotateOption(getDegreeToRotate(orientation, isBackLens: true)));
      }
      Uint8List? result = await ImageEditor.editFileImage(file: _file, imageEditorOption: editOption);
      img.Image? _image = img.decodeImage(result!);
      _file = await File(file.path).writeAsBytes(img.encodeJpg(_image!));
      print('imageFile.path: ${_file.path}');
      imageFile = _file;
      print('Image saved to ${imageFile?.path}');
      update();
      isLoading(false);
    });
  }

  Future<XFile?> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Error! Please select a camera first.');
      return null;
    }

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      print('CameraException: ${e.toString()}');
      logError(e.code, e.description ?? 'Unknown Camera Error 217');
      return null;
    }
  }

  Widget switchCameraWidget(NativeDeviceOrientation orientation) {
    return InkWell(
      child: Container(
          width: 80,
          height: 80,
          //padding: EdgeInsets.all(5),
          child: AnimatedAlignPositioned(
              duration: Duration(milliseconds: 350),
              alignment: Alignment.center,
              rotateDegrees: getDegreeToRotate(orientation).toDouble(),
              child:
                  /*Icon(
              Icons.switch_camera,
              size: 50,
              color: Colors.white,
            ),*/
                  Transform.scale(
                scale: 3.5,
                child: Lottie.asset('lib/ProX/Assets/lottie/switch_camera.json',
                    controller: lottieCtrl, repeat: false, animate: false, onLoaded: (composition) {
                  if (isInited) return;
                  didInit();
                  if (controller?.description == backLens && preferLensDirection == CameraLensDirection.front) {
                    lottieCtrl?.animateTo(0.5, duration: animateDuration);
                  }
                }),
              ))),
      onTap: () {
        CameraDescription? lens;
        if (controller?.description == backLens) {
          lens = haveFrontLens
              ? frontLens
              : haveExternalLens
                  ? externalLens
                  : null;
          if (haveFrontLens) lottieCtrl?.animateTo(0.5, duration: animateDuration);
        } else if (controller?.description == frontLens) {
          lens = haveExternalLens
              ? externalLens
              : haveBackLens
                  ? backLens
                  : null;
          if (lens != null) {
            lottieCtrl?.animateTo(1, duration: animateDuration).whenComplete(() => lottieCtrl?.reset());
          }
        } else if (controller?.description == externalLens) {
          lens = haveBackLens
              ? backLens
              : haveFrontLens
                  ? frontLens
                  : null;
          if (!haveBackLens && lens != null) lottieCtrl?.animateTo(0.5, duration: animateDuration);
        }
        if (lens != null) {
          onSelectNewCamera(lens);
        } else {
          print('No camera switchable');
        }
      },
    );
  }

  /*Widget flashLightWidget(NativeDeviceOrientation orientation) {
    return InkWell(
      child: Container(
          width: 60,
          height: 60,
          padding: EdgeInsets.all(5),
          child: AnimatedAlignPositioned(
            duration: Duration(milliseconds: 350),
            alignment: Alignment.center,
            rotateDegrees: getDegreeToRotate(orientation).toDouble(),
            child: Icon(
              getFlashIconByFlashMode(controller?.value?.flashMode),
              size: 50,
              color: Colors.white,
            ),
          )),
      onTap: () {
        if (controller?.value?.flashMode == )
        onSetFlashModeButtonPressed(FlashMode);
      },
    );
  }*/

  int getDegreeToRotate(NativeDeviceOrientation orientation, {bool isBackLens = false}) {
    switch (orientation) {
      case NativeDeviceOrientation.portraitUp:
      case NativeDeviceOrientation.portraitDown:
        return 0;
      case NativeDeviceOrientation.landscapeLeft:
        return isBackLens ? -90 : 90;
      case NativeDeviceOrientation.landscapeRight:
        return isBackLens ? 90 : -90;
      default:
        return 0;
    }
  }

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.switch_camera;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  IconData getFlashIconByFlashMode(FlashMode flashMode) {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
      default:
        return Icons.flash_auto;
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    controller?.setFlashMode(mode).then((_) {
      update();
      print('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void handleScaleStart(ScaleStartDetails details) {
    baseScale = currentScale;
    update();
  }

  Future<void> handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || pointers != 2) {
      return;
    }

    currentScale = (baseScale * details.scale).clamp(minAvailableZoom, maxAvailableZoom);

    await controller?.setZoomLevel(currentScale);
    update();
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller?.setExposurePoint(offset);
    controller?.setFocusPoint(offset);
    update();
  }

  void onDone() {
    Get.back(result: imageFile);
  }

  void onRetake() {
    imageFile = null;
    update();
  }
}

class CameraProXPage extends ProXWidget<CameraProXController> {

  @override
  String get routeName => '/CameraProXPage';

  @override
  Widget build(BuildContext context) {
    return ProXScaffold<CameraProXController>(
        builder: (ctrl) {
          return Container(
              color: Colors.black,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      //left: ctrl.imageFile == null ? null : 0,
                      //right: ctrl.imageFile == null ? null : 0,
                      left: c.imageFile == null
                          ? c.cameraOverSized
                              ? -c.sizeToReduce
                              : 0
                          : 0,
                      right: c.imageFile == null
                          ? c.cameraOverSized
                              ? -c.sizeToReduce
                              : 0
                          : 0,
                      child: c.imageFile == null
                          ? Center(child: cameraPreviewWidget(ctrl))
                          : PinchZoom(
                              resetDuration: Duration(milliseconds: 100),
                              maxScale: 2.5,
                              child: Image.file(c.imageFile!, fit: BoxFit.contain),
                            )),
                  c.extraLayout == null || c.imageFile != null
                      ? Center()
                      : Positioned.fill(
                          child: NativeDeviceOrientationReader(
                              useSensor: true,
                              builder: (context) {
                                NativeDeviceOrientation orientation = NativeDeviceOrientationReader.orientation(context);
                                bool isPortrait = (orientation == NativeDeviceOrientation.portraitUp) ||
                                    (orientation == NativeDeviceOrientation.portraitDown);
                                return c.extraLayout!(isPortrait);
                              })),
                  Positioned(
                      //left: 20,
                      //right: 20,
                      //top: 20 + (Sizer.topSafeAreaHeight / 2),
                      left: c.cameraOverSized ? 18 : c.sizeToIncrease + 18,
                      top: 18 + (Sizer.topSafeAreaHeight / 2),
                      child: Row(
                        children: [
                          c.imageFile == null
                              ? InkWell(
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(Icons.close_rounded, size: 36, color: Colors.white)),
                                  onTap: () {
                                    Get.back();
                                  },
                                )
                              : Center()
                        ],
                      )),
                  Positioned(
                      left: 40,
                      right: 40,
                      bottom: 30,
                      child: NativeDeviceOrientationReader(
                        useSensor: true,
                        builder: (context) {
                          NativeDeviceOrientation orientation = NativeDeviceOrientationReader.orientation(context);
                          return Row(
                              children: c.imageFile == null
                                  ? [
                                      Expanded(child: Center()),
                                      InkWell(
                                          child: Container(
                                              height: 60,
                                              width: 60,
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white, borderRadius: BorderRadius.circular(25)))),
                                          onTap: () {
                                            c.onTakePictureButtonPressed(orientation);
                                          }),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [c.switchCameraWidget(orientation)],
                                      )),
                                    ]
                                  : [
                                      roundedButton(Icons.close_rounded, Colors.red, () {
                                        c.onRetake();
                                      }),
                                      Expanded(child: Center()),
                                      roundedButton(Icons.check_rounded, Colors.green, () {
                                        c.onDone();
                                      })
                                    ]);
                        },
                      ))
                ],
              ));
        }
    );
  }

  Widget roundedButton(IconData icon, Color color, Function() callback) {
    return InkWell(
      child: ClipOval(
        child: Container(padding: EdgeInsets.all(10), color: color, child: Icon(icon, size: 36, color: Colors.white)),
      ),
      onTap: callback,
    );
  }

  Widget cameraPreviewWidget(CameraProXController ctrl) {
    if (ctrl.controller != null && ctrl.controller!.value.isInitialized && ctrl.isInited) {
      return Listener(
        onPointerDown: (_) => ctrl.pointers++,
        onPointerUp: (_) => ctrl.pointers--,
        child: CameraPreview(
          ctrl.controller!,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: ctrl.handleScaleStart,
              onScaleUpdate: ctrl.handleScaleUpdate,
              onTapDown: (details) => ctrl.onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    } else {
      return SizedBox(
        width: Get.width,
        child: Text(
          '', //'Camera Initializing...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}

void logError(String code, String message) {
  print('Error: $code\nError Message: $message');
  Get.snackbar('Error: $code', message);
}

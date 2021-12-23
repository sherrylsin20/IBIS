import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibis/services/classifier.dart';
import 'dart:math' as math;

import 'package:ibis/services/recognition.dart';
import 'package:ibis/services/stats.dart';
import 'package:ibis/utils/isolate_utils.dart';
import 'package:ibis/widget/bounding_box.dart';
import 'package:ibis/widget/camera_view_singleton.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class CameraPage extends StatefulWidget {
  final Function(List<Recognition> recognitions) resultsCallback;
  final Function(Stats stats) statsCallback;

  const CameraPage(this.resultsCallback, this.statsCallback);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras;
  CameraController cameraController;
  bool predicting;
  Classifier classifier;
  IsolateUtils isolateUtils;
  List<Recognition> results;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    }
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = cameraController.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        OverflowBox(
          maxHeight: screenRatio > previewRatio
              ? screenH
              : screenW / previewW * previewH,
          maxWidth: screenRatio > previewRatio
              ? screenH / previewH * previewW
              : screenW,
          child: CameraPreview(cameraController),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: _toggleCamera,
              icon: Icon(Icons.cameraswitch_rounded),
              iconSize: 32,
              color: Colors.white,
            ),
            Text('Switch camera',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.help_rounded),
            iconSize: 32,
            color: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(
                          'Deteksi gestur yang didukung',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        content: Text(
                            'Aku, B, Bayar, Cinta, Doa, G, K, L, O, Pikir, Rumah, T, Takut, Telepon, Uang',
                            style: Theme.of(context).textTheme.subtitle1),
                      ));
            },
          ),
        ),
        boundingBoxes(results),
      ],
    );
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils.start();

    initializeCamera();

    classifier = Classifier();
    predicting = false;
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium,
        enableAudio: false);

    cameraController.initialize().then((_) async {
      await cameraController.startImageStream(onLatestImageAvailable);
      Size previewSize = cameraController.value.previewSize;
      CameraViewSingleton.inputImageSize = previewSize;
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = screenSize.width / previewSize.height;
    });
  }

  onLatestImageAvailable(CameraImage cameraImage) async {
    if (classifier.interpreter != null && classifier.labels != null) {
      // If previous inference has not completed then return
      if (predicting) {
        return;
      }

      setState(() {
        predicting = true;
      });

      var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;
      var isolateData = IsolateData(
          cameraImage, classifier.interpreter.address, classifier.labels);
      Map<String, dynamic> inferenceResults = await inference(isolateData);

      var uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;
      widget.resultsCallback(inferenceResults["recognitions"]);
      widget.statsCallback((inferenceResults["stats"] as Stats)
        ..totalElapsedTime = uiThreadInferenceElapsedTime);

      setState(() {
        predicting = false;
      });
    }
  }

  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  Future<void> _toggleCamera() async {
    final CameraDescription cameraDescription =
        (cameraController.description == cameras[0]) ? cameras[1] : cameras[0];
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize().then((_) async {
        await cameraController.startImageStream(onLatestImageAvailable);
        Size previewSize = cameraController.value.previewSize;
        CameraViewSingleton.inputImageSize = previewSize;
        Size screenSize = MediaQuery.of(context).size;
        CameraViewSingleton.screenSize = screenSize;
        CameraViewSingleton.ratio = screenSize.width / previewSize.height;
      });
      ;
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }
}

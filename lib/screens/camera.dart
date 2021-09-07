import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  int selected = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'KAMERA',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _cameraController != null
                  ? (_cameraController.value.isInitialized
                      ? new Container()
                      : Center(
                          child: CircularProgressIndicator(),
                        ))
                  : null,
              _cameraController.value.isInitialized
                  ? new Container()
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              cameraPrev(),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: _toggleCamera,
                      icon: Icon(Icons.cameraswitch_rounded),
                      iconSize: 32,
                      color: Color(0xFF868686),
                    ),
                    Text('Switch camera',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF868686),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget cameraPrev() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
                height: MediaQuery.of(context).size.width /
                    _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController)),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleCamera() async {
    final CameraDescription cameraDescription =
        (_cameraController.description == _cameras[0])
            ? _cameras[1]
            : _cameras[0];
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

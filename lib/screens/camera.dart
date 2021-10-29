import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  // Camera
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  int selected = 0;

  // Text editing controller
  TextEditingController _textEditingController;

  // Text array
  List<String> translationText = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textEditingController?.dispose();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              cameraPrev(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                'Hasil terjemahan',
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,

                    // Text field for collecting results from prediction
                    child: TextField(
                      enabled: false,
                      style: Theme.of(context).textTheme.subtitle1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text-to-speech button
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Color(0xFF6597AF),
                                          width: 0.5))),
                            ),
                            child: Text('Text-to-speech',
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),

                          // Clear text button
                          TextButton(
                            onPressed: () {
                              _textEditingController?.clear();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF6597AF)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: Text('Bersihkan teks',
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Camera widget
  Widget cameraPrev() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
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
      ],
    );
  }

  // Initialize camera
  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Function for switching camera
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

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;

  Future<void> _initCams() async {
    final cameras = await availableCameras();
    final cam = cameras.first;
    _controller =
        CameraController(cam, ResolutionPreset.medium, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null;
    }
  }

  void onCaptureButtonPressed() async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        'productPic${DateTime.now()}.png',
      );
      ImagePath = path;
      await _controller.takePicture(path); //take photo

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initCams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: AspectRatio(
                    child: CameraPreview(_controller),
                    aspectRatio: _controller.value.aspectRatio,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.photo_album,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
              child:
                  CircularProgressIndicator()); // Otherwise, display a loading indicator.
        }
      },
    );
  }
}

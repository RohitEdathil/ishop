import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart' as galleryPicker;

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;

  var imagePath;

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
          // ignore: unnecessary_statements
          : null;
    }
  }

  void takePhoto(context) async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        'productPic${DateTime.now()}.png',
      );
      imagePath = path;
      await _controller.takePicture(path); //take photo
      cropAndPass(imagePath, context);
    } catch (e) {
      print(e);
    }
  }

  void cropAndPass(String imagePath, context) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imagePath,
        maxHeight: 300,
        maxWidth: 300,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          hideBottomControls: true,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        aspectRatio: CropAspectRatio(ratioX: 200, ratioY: 200));

    if (croppedImage != null) {
      Navigator.pop(context, croppedImage.path);
    }
  }

  void chooseFrmGallery(context) async {
    final picker = galleryPicker.ImagePicker();

    galleryPicker.PickedFile result = await picker.getImage(
        source: galleryPicker.ImageSource.gallery, imageQuality: 100);
    cropAndPass(result.path, context);
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton.icon(
                          onPressed: () {
                            chooseFrmGallery(context);
                          },
                          textColor: Colors.white,
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                          ),
                          label: Text('Gallery')),
                      GestureDetector(
                          onTap: () {
                            takePhoto(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            height: 60,
                            width: 60,
                          )),
                      FlatButton.icon(
                          onPressed: () {
                            Navigator.pop(context, null);
                          },
                          textColor: Colors.white,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          label: Text('Cancel')),
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

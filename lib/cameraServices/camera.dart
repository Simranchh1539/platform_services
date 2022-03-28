import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googlemapapi/homeScreen/homepage.dart';
import 'package:image_picker/image_picker.dart';

class CameraCheck extends StatefulWidget {
  @override
  State<CameraCheck> createState() => _CameraCheckState();
}

class _CameraCheckState extends State<CameraCheck> {
  File _image;
  final _imagepicker = ImagePicker();

  Future getImage() async {
    final image = await _imagepicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            ),
          ),
        ),
        body: Center(
          child:
              _image == null ? Text("No Image Selected") : Image.file(_image),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.camera_alt,
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerContainer extends StatefulWidget {
  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Stack(
        children: [
          Center(
            child: CupertinoButton(
              child: Icon(Icons.add_a_photo, color: Colors.white, size: 32),
              onPressed: getImage,
            ),
          ),
          if (_image != null)
            Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_image, fit: BoxFit.cover),
                ],
              ),
            ),
          if (_image != null)
          Align(
            alignment: Alignment.topRight,
            child: CupertinoButton(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _image = null;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
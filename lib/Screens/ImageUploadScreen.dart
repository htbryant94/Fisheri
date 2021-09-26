import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/models/fisheri_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../design_system.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key, this.initialImages}) : super(key: key);

  final List<FisheriImage>? initialImages;

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<_UploadImage> _images = [];
  List<FisheriImage> _uploadedImages = [];

  @override
  void initState() {
    _uploadedImages = widget.initialImages ?? [];
    _images = widget.initialImages?.map((fisheriImage) =>
        _UploadImage(
            image: CachedNetworkImage(
              imageUrl: fisheriImage.url,
              placeholder: (context, url) => DSComponents.progressIndicator()
            ),
            isUploading: false
        )
    ).toList() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16
            ),
            itemCount: _images.length + 1,
            itemBuilder: (context, index) {
              if (index < _images.length) {
                return _addedImageCell(index);
              } else {
                return _addImageCell(index);
              }
            }
        ),
      ),
    );
  }

  Widget _addedImageCell(int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _images[index].image
          ),
          if (_images[index].isUploading)
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black87
                ),
                child: DSComponents.progressIndicator(isOverlay: true),
              ),
            ),
          if (!_images[index].isUploading)
            Positioned(
              bottom: 16,
              right: 16,
              child: FisheriIconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onTap: () {
                  _deleteFromStorage(_uploadedImages[index].url, index)
                      .whenComplete(() {
                    setState(() {
                      _uploadedImages.removeAt(index);
                      _images.removeAt(index);
                    });
                    _updateDatabaseEntry(_uploadedImages);
                  });
                },
              ),
            )
        ],
      ),
    );
  }

  _AddImageCell _addImageCell(int index) {
    return _AddImageCell(
        onImageSelected: (file) {
          final uploadImage = _UploadImage(
              image: Image.asset(file.path),
              isUploading: true
          );
          setState(() { _images.add(uploadImage); });
        },
        onUpload: (uploadedImage) {
          setState(() {
            _images[index].isUploading = false;
            _uploadedImages.add(uploadedImage);
          });
          _updateDatabaseEntry(_uploadedImages);
        }
    );
  }

  Future _deleteFromStorage(String url, int index) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  void _updateDatabaseEntry(List<FisheriImage> _uploadedImages) {
    final documentRef = FirebaseFirestore
        .instance
        .collection('test')
        .doc('RqTrbLFO5c3UYD9O2Ikw');

    if (_uploadedImages.isNotEmpty) {
      final imagesData = _uploadedImages.map((image) => image.toJson()).toList();
      documentRef.update({'images': imagesData});
    } else {
      documentRef.update({'images': null});
    }
  }
}

class _AddImageCell extends StatefulWidget {
  const _AddImageCell({
    Key? key,
    required this.onImageSelected,
    required this.onUpload
  }) : super(key: key);

  final ValueChanged<XFile> onImageSelected;
  final ValueChanged<FisheriImage> onUpload;

  @override
  _AddImageCellState createState() => _AddImageCellState();
}

class _AddImageCellState extends State<_AddImageCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15)
      ),
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image != null) {
            widget.onImageSelected(image);
            _uploadToStorage(image);
          }
        },
      ),
    );
  }

  void _uploadToStorage(XFile image) async {
    final uuid = Uuid().v1();
    final storageRef = FirebaseStorage.instance.ref().child('test/$uuid');

    await storageRef.putFile(File(image.path)).whenComplete(() async {
      await storageRef.getDownloadURL().then((fileURL) {
        widget.onUpload(FisheriImage(id: uuid, url: fileURL));
      });
    });
  }
}

class _UploadImage {
  _UploadImage({
    required this.image,
    required this.isUploading,
  });

  final Widget image;
  bool isUploading;
}

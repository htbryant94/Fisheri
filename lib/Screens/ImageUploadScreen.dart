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
  const ImageUploadScreen({
    Key? key,
    required this.documentReference,
    required this.storageReference,
    this.initialImages,
    required this.onDonePressed,
    this.onUpload,
  }) : super(key: key);

  final DocumentReference documentReference;
  final Reference storageReference;
  final List<FisheriImage>? initialImages;
  final ValueChanged<BuildContext> onDonePressed;
  final ValueChanged<List<FisheriImage>?>? onUpload;

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<_UploadImage> _images = [];
  List<FisheriImage> _uploadedImages = [];
  var _doneButtonEnabled = true;

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.only(bottom: 44 + 16 + 8, top: 16),
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
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: DSComponents.primaryButton(
                    text: 'Done',
                    onPressed: _doneButtonEnabled ? () {
                      widget.onDonePressed(context);
                    } : null
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addedImageCell(int index) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 0.2,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _images[index].image
          ),
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
                setState(() { _doneButtonEnabled = false; });
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
    );
  }

  _AddImageCell _addImageCell(int index) {
    return _AddImageCell(
        storageReference: widget.storageReference,
        onImageSelected: (file) {
          final uploadImage = _UploadImage(
              image: Image.asset(file.path),
              isUploading: true
          );
          setState(() { _images.add(uploadImage); });
        },
        onUploadComplete: (uploadedImage) {
          setState(() {
            _images[index].isUploading = false;
            _uploadedImages.add(uploadedImage);
          });
          _updateDatabaseEntry(_uploadedImages);
        },
      onUploadStarted: () {
        setState(() { _doneButtonEnabled = false; });
      }
    );
  }

  Future _deleteFromStorage(String url, int index) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  void _updateDatabaseEntry(List<FisheriImage> _uploadedImages) {
    setState(() { _doneButtonEnabled = false; });
    if (_uploadedImages.isNotEmpty) {
      final imagesData = _uploadedImages.map((image) => image.toJson()).toList();
      widget.documentReference.update({'images': imagesData})
      .whenComplete(() {
        if (widget.onUpload != null) {
          widget.onUpload!(_uploadedImages);
        }
        setState(() { _doneButtonEnabled = true; });
      });
    } else {
      widget.documentReference.update({'images': null})
          .whenComplete(() {
        if (widget.onUpload != null) {
          widget.onUpload!(null);
        }
        setState(() { _doneButtonEnabled = true; });
      });
    }
  }
}

class _AddImageCell extends StatefulWidget {
  const _AddImageCell({
    Key? key,
    required this.onImageSelected,
    required this.onUploadComplete,
    required this.onUploadStarted,
    required this.storageReference,
  }) : super(key: key);

  final ValueChanged<XFile> onImageSelected;
  final ValueChanged<FisheriImage> onUploadComplete;
  final VoidCallback onUploadStarted;
  final Reference storageReference;

  @override
  _AddImageCellState createState() => _AddImageCellState();
}

class _AddImageCellState extends State<_AddImageCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
      ),
      child: FisheriIconButton(
        icon: Icon(Icons.add, color: Colors.white),
        onTap: () async {
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
    widget.onUploadStarted();
    final uuid = Uuid().v1();
    final storageRef = widget.storageReference.child(uuid);
    // print(storageRef);

    await storageRef.putFile(File(image.path)).whenComplete(() async {
      await storageRef.getDownloadURL().then((fileURL) {
        widget.onUploadComplete(FisheriImage(id: uuid, url: fileURL));
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

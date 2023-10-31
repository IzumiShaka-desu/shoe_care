// widget for dialog uloading image with preview image,cancle and upload button
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageDialog extends StatefulWidget {
  const UploadImageDialog({
    Key? key,
    required this.onUpload,
    required this.onCancle,
  }) : super(key: key);

  final Function(String) onUpload;
  final VoidCallback onCancle;

  @override
  _UploadImageDialogState createState() => _UploadImageDialogState();
}

class _UploadImageDialogState extends State<UploadImageDialog> {
  String? selectedImagePath;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Upload gambar"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          selectedImagePath != null
              ? Image.file(File(selectedImagePath!))
              : Container(
                  height: 200,
                  width: 200,
                  child: Icon(
                    Icons.image,
                    size: 32,
                  ),
                  color: Colors.grey,
                ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () async {
              // select image from camera
              try {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    selectedImagePath = image.path;
                  });
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            leading: const Icon(Icons.camera),
            title: const Text("Camera"),
          ),
          ListTile(
            onTap: () async {
              // select image from gallery
              // Navigator.pop(context);
              try {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedImagePath = image.path;
                  });
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: selectedImagePath != null
                    ? () {
                        if (selectedImagePath != null) {
                          widget.onUpload(selectedImagePath!);
                        }
                      }
                    : null,
                child: const Text("Upload"),
              ),
              ElevatedButton(
                onPressed: widget.onCancle,
                child: const Text("Batal"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/service_type.dart';

import '../../../data/models/mitra_models.dart';
import '../../viewmodel/mitra_viewmodel.dart';

// create form form register or update mitra profile
//if initialMitraProfile is not null then update mitra profile
// if initialMitraProfile is null then create new mitra profile
enum PhotoType { url, path, none }

class MitraProfileForm extends StatefulWidget {
  const MitraProfileForm({
    Key? key,
    this.initialMitraProfile,
  }) : super(key: key);
  final Mitra? initialMitraProfile;
  @override
  _MitraProfileFormState createState() => _MitraProfileFormState();
}

class _MitraProfileFormState extends State<MitraProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _serviceList = "";
  String _photo = "";

  PhotoType get _photoType {
    if (_photo.isEmpty) return PhotoType.none;
    // check is image url with regex
    final regex = RegExp(r"^http(s)?://.*\.(?:png|jpg|jpeg|gif|png)");
    if (regex.hasMatch(_photo)) return PhotoType.url;
    return PhotoType.path;
  }

  @override
  void initState() {
    if (widget.initialMitraProfile != null) {
      _nameController.text = widget.initialMitraProfile?.mitraName ?? "";
      _addressController.text = widget.initialMitraProfile?.address ?? "";
      _serviceList = widget.initialMitraProfile?.serviceList ?? "";
      _photo = widget.initialMitraProfile!.imageUrl;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.initialMitraProfile == null
            ? const Text("Daftar Mitra")
            : const Text("Edit Mitra"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama tidak boleh kosong";
                }
              },
            ),
            // address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Alamat",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Alamat tidak boleh kosong";
                }
              },
            ),
            // servis list
            // create chip select service list
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: serviceTypeStr.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = serviceTypeStr[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: Text(item),
                            selected: _serviceList.contains(item),
                            onSelected: (value) {
                              final allItemsSelected = _serviceList.split(",");
                              if (value) {
                                allItemsSelected.add(item);
                              } else {
                                allItemsSelected.remove(item);
                              }
                              setState(
                                () {
                                  _serviceList = serviceTypeStr
                                      .where((element) =>
                                          allItemsSelected.contains(element))
                                      .join(",");
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // photo
            AspectRatio(
              // landscape photo
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Builder(
                  builder: (context) {
                    switch (_photoType) {
                      case PhotoType.url:
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                _photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _photo = "";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        );

                      case PhotoType.path:
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(
                                File(_photo),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Error");
                                },
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _photo = "";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        );
                      default:
                        return InkWell(
                          onTap: () async {
                            // show dialog to choose image from gallery or camera
                            final result = await showDialog<ImageSource>(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: const Text("Pilih Gambar"),
                                  children: [
                                    SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, ImageSource.gallery);
                                      },
                                      child: const Text("Gallery"),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, ImageSource.camera);
                                      },
                                      child: const Text("Camera"),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result != null) {
                              // call mitra viewmodel to get image from gallery or camera
                              final image =
                                  await ImagePicker().pickImage(source: result);
                              if (image != null) {
                                setState(() {
                                  _photo = image.path;
                                });
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_a_photo_outlined),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            // button submit
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _photo.isNotEmpty &&
                    _serviceList.isNotEmpty) {
                  if (widget.initialMitraProfile == null) {
                    // create new mitra profile
                    // call mitra viewmodel to create new mitra profile
                    context.read<MitraViewmodel>().createMitra(
                        name: _nameController.text,
                        address: _addressController.text,
                        servisList: _serviceList,
                        photo: _photo,
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                        },
                        onSuccess: (result) {
                          context.pop();
                        });
                    // if success then pop
                    // if error then show error message
                  } else {
                    // update mitra profile
                    // call mitra viewmodel to update mitra profile
                    context.read<MitraViewmodel>().updateMitra(
                        idMitra: widget.initialMitraProfile!.idMitra,
                        name: _nameController.text,
                        address: _addressController.text,
                        servisList: _serviceList,
                        photo: _photoType == PhotoType.url ? null : _photo,
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                        },
                        onSuccess: (result) {
                          context.pop();
                        });
                    // if success then pop
                    // if error then show error message
                  }
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

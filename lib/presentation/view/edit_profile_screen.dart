import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/data/models/user_profile_model.dart';
import 'package:shoe_care/presentation/viewmodel/auth_viewmodel.dart';

import 'admin/mitra_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.initialProfile,
  });
  final UserProfile initialProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // late final TextEditingController _emailController;
  // late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();
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
    // _emailController = TextEditingController(text: widget.initialProfile.email);
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _phoneController = TextEditingController(text: widget.initialProfile.phone);
    _addressController =
        TextEditingController(text: widget.initialProfile.address);
    _photo = widget.initialProfile.profilePhoto ?? "";

    super.initState();
  }

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 48 * 2,
                width: 48 * 2,
                child: Builder(
                  builder: (context) {
                    switch (_photoType) {
                      case PhotoType.url:
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  _photo,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
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
                              child: CircleAvatar(
                                backgroundImage: FileImage(
                                  File(_photo),
                                ),
                              ),
                            ),
                            Positioned(
                              // top: 8,
                              right: context.width * 0.35,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _photo = "";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(16),
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
                          child: CircleAvatar(
                            radius: 48,
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_a_photo_outlined),
                            ),
                          ),
                        );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Name",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Phone",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nomor telepon tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Address",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat tidak boleh kosong";
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              // TextFormField(
              //   controller: _emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     hintText: "Email",
              //   ),
              //   validator: (value) {
              //     // using regex
              //     final regex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
              //     if (value == null || value.isEmpty) {
              //       return "Email tidak boleh kosong";
              //     }
              //     if (!regex.hasMatch(value)) {
              //       return "Email tidak valid";
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthViewmodel>().updateProfile(
                          name: _nameController.text,
                          phoneNumber: _phoneController.text,
                          address: _addressController.text,
                          profilePhoto:
                              _photoType == PhotoType.path ? _photo : null,
                          // password: _passwordController.text,

                          onSuccess: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                            context.pop();
                          },
                          onError: (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err),
                              ),
                            );
                          },
                        );
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

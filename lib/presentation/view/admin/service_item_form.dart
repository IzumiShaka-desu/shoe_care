import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/data/models/mitra_service_model.dart';

import '../../viewmodel/mitra_viewmodel.dart';

class ServiceItemForm extends StatefulWidget {
  const ServiceItemForm({
    super.key,
    this.initialData,
  });
  final MitraService? initialData;

  @override
  State<ServiceItemForm> createState() => _ServiceItemFormState();
}

class _ServiceItemFormState extends State<ServiceItemForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _serviceNameController;
  late final TextEditingController _priceController;
  String _selectedType = "Deepwash";

  @override
  void initState() {
    _serviceNameController = TextEditingController(
      text: widget.initialData?.serviceName,
    );
    _priceController = TextEditingController(
      text: widget.initialData?.price.toString(),
    );
    _selectedType = widget.initialData?.serviceType ?? "Deepwash";
    super.initState();
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.initialData == null ? "Tambah Layanan" : "Edit Layanan",
                style: context.titleLarge,
              ),
            ),
            TextFormField(
              controller: _serviceNameController,
              decoration: const InputDecoration(
                labelText: "Nama Layanan",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama layanan tidak boleh kosong";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Harga tidak boleh kosong";
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              items: serviceTypeStr.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Tipe Layanan",
              ),
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.initialData == null) {
                        // add new service
                        context.read<MitraViewmodel>().createMitraService(
                              serviceName: _serviceNameController.text,
                              price: int.parse(_priceController.text),
                              serviceType: stringToServiceType(_selectedType),
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                        bottom: context.height * 0.75),
                                  ),
                                );
                              },
                              onSuccess: (p0) {
                                Navigator.pop(context);
                              },
                            );
                      } else {
                        // edit service
                        context.read<MitraViewmodel>().updateMitraService(
                              idService: widget.initialData!.idItems,
                              serviceName: _serviceNameController.text,
                              price: int.parse(_priceController.text),
                              serviceType: stringToServiceType(_selectedType),
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                        bottom: context.height * 0.75),
                                  ),
                                );
                              },
                              onSuccess: (p0) {
                                Navigator.pop(context);
                              },
                            );
                      }
                    }
                  },
                  child: const Text("Simpan"),
                ),
                SizedBox(
                  width: context.width * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Batal"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

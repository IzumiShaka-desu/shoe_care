import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/data/models/mitra_rekening_mode.dart';
import 'package:shoe_care/presentation/viewmodel/mitra_viewmodel.dart';

class AddOrEditRekeningForm extends StatefulWidget {
  const AddOrEditRekeningForm({super.key, this.initialData});
  final MitraRekening? initialData;

  @override
  State<AddOrEditRekeningForm> createState() => _AddOrEditRekeningFormState();
}

class _AddOrEditRekeningFormState extends State<AddOrEditRekeningForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bankNameController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _accountNumberController;

  @override
  void initState() {
    _bankNameController = TextEditingController(
      text: widget.initialData?.bankName,
    );
    _accountNameController = TextEditingController(
      text: widget.initialData?.accountName,
    );
    _accountNumberController = TextEditingController(
      text: widget.initialData?.accountNumber,
    );

    super.initState();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
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
                widget.initialData == null
                    ? "Tambah Rekening"
                    : "Edit Rekening",
                style: context.titleLarge,
              ),
            ),
            TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: "Nama Bank",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama bank tidak boleh kosong";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _accountNameController,
              decoration: const InputDecoration(
                labelText: "Nama Pemilik Rekening",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama pemilik rekening tidak boleh kosong";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nomor Rekening",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nomor rekening tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.initialData == null) {
                          // create
                          context.read<MitraViewmodel>().createMitraRekening(
                                bankName: _bankNameController.text,
                                accountName: _accountNameController.text,
                                accountNumber: _accountNumberController.text,
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
                          // update
                          context.read<MitraViewmodel>().updateMitraRekening(
                                idRekening: widget.initialData!.idRekening,
                                bankName: _bankNameController.text,
                                accountName: _accountNameController.text,
                                accountNumber: _accountNumberController.text,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Simpan"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

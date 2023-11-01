import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/mitra_viewmodel.dart';
import 'rekening_form.dart';

class RekeningListScreen extends StatelessWidget {
  const RekeningListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // show list item  with name of account + bank name and account number and action to edit or delete and add new service on floating button(hidden when scrolling)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekening List"),
      ),
      body: Builder(builder: (context) {
        final mitraServiceState =
            context.watch<MitraViewmodel>().mitraRekeningState;
        if (mitraServiceState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (mitraServiceState.errorMessage != null) {
          return Center(
            child: Text(mitraServiceState.errorMessage!),
          );
        }
        if (mitraServiceState.data == null) {
          return const Center(
            child: Text("Data is null"),
          );
        }

        if (mitraServiceState.data!.isEmpty) {
          return const Center(
            child: Text("Kamu belum menginput rekening"),
          );
        }

        final mitraRekening = mitraServiceState.data!;

        return ListView.builder(
          itemCount: mitraRekening.length,
          itemBuilder: (context, index) {
            final item = mitraRekening[index];
            return ListTile(
              // type + name
              title: Text(
                "${item.bankName} - ${item.accountNumber}",
              ),
              subtitle: Text("A/N: ${item.accountName}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // show bottom sheet form to edit rekening
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return AddOrEditRekeningForm(
                            initialData: item,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // confimation dialog before deleete
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah kamu yakin ingin menghapus rekening ini?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<MitraViewmodel>()
                                      .deleteMitraRekening(
                                        idRekening: item.idRekening,
                                        onError: (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(error),
                                            ),
                                          );
                                        },
                                        onSuccess: (p0) {
                                          Navigator.pop(context);
                                        },
                                      );
                                },
                                child: const Text("Hapus"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show bottom sheet form to add new rekening
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const AddOrEditRekeningForm();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/app/extension/extension.dart';

import '../../viewmodel/mitra_viewmodel.dart';
import 'service_item_form.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // show list item for current service type with name of service and price and action to edit or delete and add new service on floating button(hidden when scrolling)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service List"),
      ),
      body: Builder(builder: (context) {
        final mitraServiceState =
            context.watch<MitraViewmodel>().mitraServiceState;
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

        final mitraService = mitraServiceState.data!;

        if (mitraService.isEmpty) {
          return const Center(
            child: Text("Kamu belum menginput service"),
          );
        }

        return ListView.builder(
          itemCount: mitraService.length,
          itemBuilder: (context, index) {
            final item = mitraService[index];
            return ListTile(
              // type + name
              title: Text(
                "${item.serviceType} - ${item.serviceName}",
              ),
              subtitle: Text(item.price.asRp),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // show bottom sheet form to edit service
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ServiceItemForm(
                            initialData: item,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // show confirmation dialog to delete service
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Hapus Service"),
                            content: const Text(
                                "Apakah anda yakin ingin menghapus service ini?"),
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
                                      .deleteMitraService(
                                        idService: item.idItems,
                                        onError: (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(error),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                bottom: context.height * 0.75,
                                              ),
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
          // show bottom sheet form to add new service
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const ServiceItemForm();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

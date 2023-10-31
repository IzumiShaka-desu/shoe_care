import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/presentation/viewmodel/customer_viewmodel.dart';
import 'package:shoe_care/presentation/widgets/item_count_bar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<CustomerViewmodel>().resetRequest();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pesanan"),
        ),
        body: Builder(builder: (context) {
          final vm = context.watch<CustomerViewmodel>();
          if (vm.mitraServiceList.isEmpty) {
            return const Center(
              child: Text("Tidak ada layanan tersedia"),
            );
          }
          return ListView.builder(
            itemCount: vm.mitraServiceList.length + 1,
            itemBuilder: (context, index) {
              if (vm.mitraServiceList.length == index) {
                // textarea for notes
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Catatan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }
              // check item in this index is available
              if (vm.mitraServiceList.length <= index) {
                return SizedBox(
                  height: 64,
                  child: Text("${vm.mitraServiceList}"),
                );
              }
              final item = vm.mitraServiceList[index];
              return Card(
                child: ItemCountBar(
                  imageUrl:
                      "https://shoesandcare.com/storage/gambar_post/fileName1636296622.jpg",
                  title: item.serviceName,
                  initialCount: vm.getInitialQuantity(item.idItems),
                  onCountChanged: (value) {
                    context
                        .read<CustomerViewmodel>()
                        .setItemQuantity(item.idItems, value);
                  },
                ),
              );
            },
          );
        }),
        bottomNavigationBar: Container(
          height: 88,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Container(
                    // color: Colors.blue,
                    child: Builder(builder: (context) {
                      final isQuantityValid =
                          context.watch<CustomerViewmodel>().quantityValid;
                      return TextButton(
                        onPressed: isQuantityValid
                            ? () {
                                context.push("/customer/request-order");
                              }
                            : null,
                        style: TextButton.styleFrom(
                          backgroundColor:
                              isQuantityValid ? Colors.blue : Colors.blueGrey,
                        ),
                        child: const Text(
                          "Pesan",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

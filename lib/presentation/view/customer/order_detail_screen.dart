import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/constants.dart';
import 'package:shoe_care/data/models/delivery_type.dart';
import 'package:shoe_care/data/models/service_package.dart';

import '../../viewmodel/customer_viewmodel.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //  dropdown jenis paket layanan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<ServicePackage>(
                items: Constants.servicePackages
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                hint: const Text("Pilih jenis paket layanan"),
                onChanged: (value) {
                  if (value == null) return;
                  context.read<CustomerViewmodel>().setServicePackage(value);
                },
              ),
            ),
            // dropdown jenis delivery
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<DeliveryType>(
                items: Constants.deliveryMethods
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                hint: const Text("Pilih jenis delivery"),
                onChanged: (value) {
                  if (value == null) return;
                  context.read<CustomerViewmodel>().setDeliveryType(value);
                },
              ),
            ),
            // dropdown jenis pembayaran
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                items: Constants.paymentMethods
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  context.read<CustomerViewmodel>().setJenisPembayaran(value);
                },
                hint: const Text("Pilih jenis pembayaran"),
              ),
            ),
            // Card(
            //   child: Column(children: [
            //     AwesomeDialog(
            // context: context,
            // dialogType: DialogType.info,
            // animType: AnimType.rightSlide,,
            // title: 'Dialog Title',
            // desc: 'Dialog description here.............',
            // btnCancelOnPress: () {},
            // btnOkOnPress: () {},
            // )..show();
            //   ],),
            // )
          ],
        ),
      ),
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
                    final vm = context.watch<CustomerViewmodel>();
                    return TextButton(
                      onPressed: !vm.transactionRequest.isValid ||
                              vm.isMakingTransaction
                          ? null
                          : () async {
                              final vm = context.read<CustomerViewmodel>();
                              await vm.makeTransaction(
                                onError: (message) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Pesanan Gagal Terkirim',
                                    dismissOnTouchOutside: false,
                                    desc:
                                        'pesanan anda gagal terkirim.($message)',
                                    // btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  ).show();
                                },
                                onSuccess: (message) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Pesanan Terkirim',
                                    dismissOnTouchOutside: false,
                                    desc: 'pesanan anda telah terkirim.',
                                    // btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      vm.resetRequest();
                                      context.go("/customer/history-order");
                                    },
                                  ).show();
                                },
                              );
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: vm.transactionRequest.isValid
                            ? Colors.blue
                            : Colors.blueGrey,
                      ),
                      child: Text(
                        vm.isMakingTransaction ? "Processing..." : "Pesan",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

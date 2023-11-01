import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/order_status.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/app/extension/extension.dart';
import 'package:shoe_care/presentation/viewmodel/mitra_viewmodel.dart';
import 'package:shoe_care/presentation/widgets/step_progress_bar.dart';

import '../../widgets/order_status_bottom_sheet.dart';
import '../../widgets/upload_image_dialog.dart';

class DetailHistoryScreen extends StatelessWidget {
  const DetailHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Riwayat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            final state =
                context.watch<MitraViewmodel>().transactionDetailState;
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.isError) {
              return Center(
                child: Text(state.errorMessage ?? "Terjadi kesalahan"),
              );
            }
            if (state.data == null) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            }
            final data = state.data!;
            return ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Id Pesanan"),
                                  Text("${data.idTransaction}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Jenis Jasa"),
                                  Text(data.serviceType),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // tanggal pesanan
                            const Expanded(
                              flex: 7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Tanggal Pesanan")),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Text(data.createdAt.stringify2),
                            )
                          ],
                        ),
                        // estimasi pengambilan
                        Row(
                          children: [
                            const Expanded(
                              flex: 7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Estimasi Pengambilan")),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Text(data.estimatedFinishDate.stringify2),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Text("Status Pesanan"),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: StepProgressBar(
                                stps: orderStatusesName,
                                currentStatus:
                                    orderStatusFromStr(data.status).asName,
                              ),
                            ),
                          ],
                        ),
                        // payment info
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          children: [
                            Text("Status Pembayaran"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.lightBlue,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                child: Text(
                                  data.paymentStatus,
                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: const Text("Bukti Pembayaran"),
                            children: [
                              data.paymentProof != null
                                  ? Image.network(
                                      data.paymentProofUrl,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        // show dialog for select image from camera or gallery
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UploadImageDialog(
                                              onUpload: (imagePath) {
                                                context.pop();
                                                context
                                                    .read<MitraViewmodel>()
                                                    .uploadPaymentProof(
                                                        imagePath);
                                              },
                                              onCancle: () {
                                                context.pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 128,
                                        height: 128,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                        )),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "Upload Bukti Pembayaran",
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          children: [
                            Text("Detail Pembayaran"),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("Metode Pembayaran"),
                                  ),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(data.paymentMethod),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          children: [
                            Text("Daftar Barang"),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.items.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = data.items[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${item.serviceName} x ${item.quantity}",
                                        ),
                                      ),
                                      const Text("  "),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:
                                      Text((item.price * item.quantity).asRp),
                                )
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Jumlah")),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(data.subtotal.asRp),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                          "Biaya Tambahan (${data.servicePackage.name})")),
                                  const Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(data.additionalPrice.asRp),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Biaya Antar Jemput")),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(data.deliveryFee.asRp),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Total Pembayaran")),
                                  Text(" : "),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(data.totalPrice.asRp),
                            )
                          ],
                        ),
                        // button info tujuan transfer
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    // show OrderStatusBottomSheet
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return OrderStatusBottomSheet(
                          initialStatus: orderStatusFromStr(data.status),
                          initialPaymentStatus: data.paymentStatus,
                          onUpdateStatus: (status, paymentStatus) {
                            context
                                .read<MitraViewmodel>()
                                .updateTransactionStatus(
                                  idTransaction: data.idTransaction,
                                  status: status.name,
                                  paymentStatus: paymentStatus,
                                );
                          },
                        );
                      },
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Update Order Status"),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

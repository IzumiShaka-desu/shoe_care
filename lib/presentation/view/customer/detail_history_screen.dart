import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/order_status.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/app/extension/extension.dart';
import 'package:shoe_care/presentation/widgets/upload_image_dialog.dart';
import 'package:shoe_care/presentation/widgets/dashed_line.dart';
import 'package:shoe_care/presentation/widgets/rating_bar.dart';
import 'package:shoe_care/presentation/widgets/step_progress_bar.dart';

import '../../viewmodel/customer_viewmodel.dart';
import '../../widgets/review_dialog.dart';

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
        child: Builder(builder: (context) {
          final state =
              context.watch<CustomerViewmodel>().transactionDetailState;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      if (loadingProgress == null) return child;
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
                                                  .read<CustomerViewmodel>()
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text("Metode Pembayaran")),
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
                                            "${item.serviceName} x ${item.quantity}")),
                                    const Text("  "),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text((item.price * item.quantity).asRp),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              data.status != OrderStatus.delivered.name
                  ? ElevatedButton(
                      onPressed: () async {
                        await context
                            .read<CustomerViewmodel>()
                            .getMitraRekening();
                        // show bottom sheet to show list of MitraRekening\
                        await Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                final vm = context
                                    .watch<CustomerViewmodel>()
                                    .mitraRekeningState;
                                if (vm.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (vm.isError) {
                                  return Center(
                                    child: Text(
                                        vm.errorMessage ?? "Terjadi kesalahan"),
                                  );
                                }
                                if (vm.data == null) {
                                  return const Center(
                                    child: Text("Tidak ada rekening terdaftar"),
                                  );
                                }
                                final data = vm.data!;
                                return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Info Tujuan Transfer",
                                          style: context.titleLarge,
                                        ),
                                        ListView.builder(
                                          itemCount: data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final item = data[index];
                                            return Card(
                                              child: ListTile(
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      item.accountName,
                                                      style: context.titleLarge,
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Text(
                                                      "(${item.bankName})",
                                                      style:
                                                          context.titleMedium,
                                                    )
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  children: [
                                                    Text(
                                                      item.accountNumber,
                                                      style: context.bodyLarge,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ));
                              },
                            );
                          },
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Info Tujuan Transfer"),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(Icons.info_outline),
                        ],
                      ),
                    )
                  : data.review == null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Pesanan telah selesai"),
                            const SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // using dialog to add review
                                final result = await showDialog<ReviewForm>(
                                  context: context,
                                  builder: (context) => const ReviewDialog(),
                                );
                                if (result != null) {
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    context.read<CustomerViewmodel>().addReview(
                                      result.comment,
                                      result.rating,
                                      onError: (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              e.message,
                                            ),
                                          ),
                                        );
                                      },
                                      onSuccess: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Success add review",
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                              },
                              child: const Text("Beri Ulasan"),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Pesanan telah selesai"),
                            const SizedBox(
                              height: 8,
                            ),
                            // review saya
                            Row(
                              children: [
                                Text(
                                  "Ulasan Saya",
                                  style: context.titleLarge,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data.review!.comment,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Text(
                                              data.review!.createdAt.stringify2,
                                              style:
                                                  context.labelMedium?.copyWith(
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RatingBar(
                                              initialRating:
                                                  data.review!.rating,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ],
          );
        }),
      ),
    );
  }
}

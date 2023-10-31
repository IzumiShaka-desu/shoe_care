import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/order_status.dart';
import 'package:shoe_care/app/enum/screen_status.dart';
import 'package:shoe_care/app/extension/extension.dart';
import 'package:shoe_care/presentation/viewmodel/customer_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat"),
      ),
      body: Builder(builder: (context) {
        final state = context.watch<CustomerViewmodel>().transactionListState;
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
        if (state.screenState == ScreenStatus.initial) {
          Future.microtask(() {
            context.read<CustomerViewmodel>().getTransactionList();
          });
        }
        if (state.data == null || (state.data?.isEmpty ?? true)) {
          return const Center(
            child: Text("Tidak ada riwayat"),
          );
        }
        final data = state.data!;
        return ListView.builder(
          itemCount: data.length,
          reverse: true,
          itemBuilder: (context, index) {
            final item = data[index];
            final status = orderStatusFromStr(item.status);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  context
                      .read<CustomerViewmodel>()
                      .getTransactionDetail(item.idTransaction);
                  context.push("/customer/history-order/${item.idTransaction}");
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                            color: status.color,
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.history_outlined),
                              ),
                              Text(item.status),
                              const Spacer(),
                              Text(item.createdAt.stringify2),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text("Id Pesanan")),
                                        Text(" : "),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text("${item.idTransaction}"),
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
                                        Expanded(child: Text("Jenis Jasa")),
                                        Text(" : "),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(item.serviceType),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("Status Pembayaran")),
                                    Text(" : "),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(item.paymentStatus),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Icon(Icons.chevron_right_outlined),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

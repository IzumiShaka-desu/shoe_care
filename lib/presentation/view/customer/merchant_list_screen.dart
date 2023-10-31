import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/enum/service_type.dart';
import 'package:shoe_care/presentation/viewmodel/customer_viewmodel.dart';
import 'package:shoe_care/presentation/widgets/rating_bar.dart';

class MerchanListScreen extends StatelessWidget {
  const MerchanListScreen({
    super.key,
    required this.serviceType,
  });
  final ServiceType serviceType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar ${serviceType.toString().split(".").last}"),
      ),
      body: Builder(builder: (context) {
        final merchantsState =
            context.watch<CustomerViewmodel>().mitraListState;
        if (merchantsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (merchantsState.isError) {
          return Center(
            child: Text(merchantsState.errorMessage ?? "Error"),
          );
        }
        final items = merchantsState.data ?? [];
        if (items.isEmpty) {
          return const Center(
            child: Text("Mitra tidak ditemukan"),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  context.read<CustomerViewmodel>().updateRequest(
                        idMitra: item.idMitra,
                        serviceType: serviceTypeToString(serviceType),
                      );
                });
                context.push("/customer/make-order", extra: serviceType);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(item.imageUrl),
                      ),
                      Text(item.mitraName),
                      RatingBar(
                        initialRating: item.rating,
                        disableChange: true,
                      )
                    ],
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

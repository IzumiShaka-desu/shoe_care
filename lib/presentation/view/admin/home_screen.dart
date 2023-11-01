import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/app/extension/extension.dart';
import 'package:shoe_care/presentation/viewmodel/auth_viewmodel.dart';
import 'package:shoe_care/presentation/viewmodel/mitra_viewmodel.dart';

import '../../../app/enum/service_type.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menu = [
      {
        "icon": Image.asset("images/deepwash.png"),
        "title": "Daftar Layanan",
        "onClick": () {
          context.read<MitraViewmodel>().getMitraService();
          context.push(
            "/mitra/services",
            extra: ServiceType.deepwash,
          );
        },
      },
      {
        "icon": const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.attach_money_outlined, size: 64),
        ),
        "title": "Daftar Rekening",
        "onClick": () {
          context.read<MitraViewmodel>().getMitraRekening();
          context.push(
            "/mitra/rekening",
            extra: ServiceType.deepwash,
          );
        },
      },
      {
        "icon": const Icon(Icons.history_outlined, size: 64),
        "title": "Daftar Transaksi",
        "onClick": () {
          Future.microtask(() {
            context.read<MitraViewmodel>().getTransactionList();
          });
          context.push("/mitra/history-order");
        },
      },
      {
        "icon": const Icon(Icons.settings, size: 64),
        "title": "Pengaturan Profil Jasa",
        "onClick": () {
          final initial = context.read<MitraViewmodel>().myMitraState.data;
          context.push(
            "/mitra/form",
            extra: initial,
          );
        },
      },
    ];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.microtask(() {
        context.read<MitraViewmodel>().getMyMitra();
        context.read<AuthViewmodel>().fetchProfile();
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shoes Care"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        final mitraState = context.watch<MitraViewmodel>().myMitraState;
        if (mitraState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (mitraState.errorMessage != null) {
          if (mitraState.errorMessage?.toLowerCase().contains("not found") ??
              false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Anda belum terdaftar sebagai mitra"),
                  TextButton(
                    onPressed: () {
                      context.push("/mitra/form");
                    },
                    child: const Text("Daftar Sekarang"),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(mitraState.errorMessage!),
          );
        }
        if (mitraState.data == null) {
          return const Center(
            child: Text("Data is null"),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Row(
              children: [
                // avatar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(builder: (context) {
                    final profileState =
                        context.watch<AuthViewmodel>().profileState;
                    return CircleAvatar(
                      radius: 48,
                      backgroundImage: profileState.data?.profilePhoto == null
                          ? null
                          : NetworkImage(
                              profileState.data!.photoProfileUrl,
                            ),
                      child: profileState.data?.profilePhoto == null
                          ? profileState.data?.name.isNotEmpty ?? false
                              ? Text(
                                  profileState.data!.name[0].capitalized,
                                  style: context.headlineLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.person)
                          : null,
                    );
                  }),
                ),
                SizedBox(
                  width: context.width * 0.05,
                ),
                // name
                Builder(builder: (context) {
                  final profileState =
                      context.watch<AuthViewmodel>().profileState;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang!",
                        style:
                            context.titleMedium?.copyWith(color: Colors.grey),
                      ),
                      Text(
                        profileState.data?.name ?? "",
                        style: context.titleLarge,
                      ),
                    ],
                  );
                }),
                const Spacer(),
                // logout
                IconButton(
                  onPressed: () {
                    context.push("/profile");
                  },
                  icon: const Icon(Icons.person),
                  iconSize: 32,
                ),
              ],
            ),
            // list menu
            // list menu
            Row(
              children: [
                Text("Dashboard Menu", style: context.headlineSmall),
              ],
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            // gridview menu 2 columns with 7 items inside and 1 item in the bottom center
            Wrap(
              alignment: WrapAlignment.center,
              children: menu
                  .map(
                    (e) => SizedBox(
                      width: context.width * 0.45,
                      height: context.width * 0.45,
                      child: InkWell(
                        onTap: e["onClick"],
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              e["icon"],
                              Text(e["title"] ?? ""),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      }),
    );
  }
}

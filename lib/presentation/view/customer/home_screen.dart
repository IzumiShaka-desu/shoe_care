import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/extension/context_utils.dart';
import 'package:shoe_care/app/extension/extension.dart';
import 'package:shoe_care/presentation/viewmodel/customer_viewmodel.dart';

import '../../../app/enum/service_type.dart';
import '../../viewmodel/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menu = [
      {
        "icon": Image.asset("images/deepwash.png"),
        "title": "Deepwash",
        "onClick": () {
          context.read<CustomerViewmodel>().getMitraList(
                ServiceType.deepwash,
              );
          context.push(
            "/customer/merchants",
            extra: ServiceType.deepwash,
          );
        },
      },
      {
        "icon": Image.asset("images/repaint.png"),
        "title": "Repaint",
        "onClick": () {
          context.read<CustomerViewmodel>().getMitraList(
                ServiceType.repaint,
              );
          context.push(
            "/customer/merchants",
            extra: ServiceType.repaint,
          );
        },
      },
      {
        "icon": Image.asset("images/sol.png"),
        "title": "Sol",
        "onClick": () {
          context.read<CustomerViewmodel>().getMitraList(
                ServiceType.sol,
              );
          context.push(
            "/customer/merchants",
            extra: ServiceType.sol,
          );
        },
      },
      {
        "icon": Image.asset("images/unyellowing.png"),
        "title": "Unyellowing",
        "onClick": () {
          context.read<CustomerViewmodel>().getMitraList(
                ServiceType.unyellowing,
              );
          context.push(
            "/customer/merchants",
            extra: ServiceType.unyellowing,
          );
        },
      },
    ];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.microtask(() {
        // context.read<MitraViewmodel>().getMyMitra();
        context.read<AuthViewmodel>().fetchProfile();
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shoes Care"),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/customer/history-order");
            },
            icon: Icon(Icons.history_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            children: [
              // avatar
              Padding(
                padding: EdgeInsets.all(8.0),
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
                      style: context.titleMedium?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      profileState.data?.name ?? "",
                      style: context.titleLarge,
                    ),
                  ],
                );
              }),
              Spacer(),
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
      ),
    );
  }
}

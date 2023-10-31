import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/utils/color_utils.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/upload_image_dialog.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: NetworkImage(
                //       'https://raw.githubusercontent.com/IzumiShaka-desu/gif_host/main/tenkuji_takeru.png'),
                //   fit: BoxFit.cover,
                // ),
                color: fromHex("#FFC008").withOpacity(.3),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.58,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Stack(
                        children: [
                          ListView(
                            // controller: scrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              const SizedBox(
                                // button for change photo
                                height: 8,
                              ),
                              Center(
                                child: Builder(builder: (context) {
                                  final profile = context
                                      .watch<AuthViewmodel>()
                                      .profileState;
                                  return Text(
                                    profile.data?.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Builder(builder: (context) {
                                  final profile = context
                                      .watch<AuthViewmodel>()
                                      .profileState;
                                  return Text(
                                    profile.data?.email ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  );
                                }),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.email_outlined),
                                title: Builder(
                                  builder: (context) {
                                    final profile = context
                                        .watch<AuthViewmodel>()
                                        .profileState;
                                    return Text(
                                      profile.data?.address ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: Builder(
                                  builder: (context) {
                                    final profile = context
                                        .watch<AuthViewmodel>()
                                        .profileState;
                                    return Text(
                                      profile.data?.phone ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                              Builder(builder: (context) {
                                final profile =
                                    context.watch<AuthViewmodel>().profileState;
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text("Edit Profile"),
                                  onTap: () {
                                    if (profile.data != null) {
                                      context.push(
                                        "/profile/edit",
                                        extra: profile.data!,
                                      );
                                    }
                                  },
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                );
                              }),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text("Logout"),
                                onTap: () {
                                  context.read<AuthViewmodel>().logout();
                                  context.go("/welcome");
                                },
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                              const Divider(),
                              Container()
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, -128),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: fromHex("#F5F7F4"),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    final profile = context
                                        .watch<AuthViewmodel>()
                                        .profileState;
                                    return CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            profile.data?.profilePhoto == null
                                                ? null
                                                : NetworkImage(
                                                    profile
                                                        .data!.photoProfileUrl,
                                                  ),
                                        child: profile.data?.profilePhoto ==
                                                null
                                            ? profile.data?.name.isNotEmpty ==
                                                    true
                                                ? Text(
                                                    profile.data!.name[0]
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 60,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.person,
                                                    size: 60,
                                                  )
                                            : null);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // backbutton
          Positioned(
            top: 32,
            left: 16,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: fromHex("#F5F7F4"),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.arrow_back_ios)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

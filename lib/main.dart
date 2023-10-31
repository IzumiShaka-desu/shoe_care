import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/route_config.dart';
import 'package:shoe_care/app/utils/color_utils.dart';
import 'package:shoe_care/presentation/viewmodel/auth_viewmodel.dart';
import 'package:shoe_care/presentation/viewmodel/customer_viewmodel.dart';
import 'package:shoe_care/presentation/viewmodel/mitra_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('auth');
  await Hive.openBox<String>('user');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomerViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MitraViewmodel(),
        ),
        ChangeNotifierProvider(create: (context) => AuthViewmodel()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: routeConfig,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: fromHex("#B8C7CE")),
          useMaterial3: true,
        ),
      ),
    );
  }
}

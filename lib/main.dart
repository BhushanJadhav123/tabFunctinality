import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app/blocs/in_app_browser_bloc/in_app_browser_bloc.dart';
import 'app/screens/in_app_browser_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: Platform.isAndroid || Platform.isIOS ? await getApplicationDocumentsDirectory() : HydratedStorage.webStorageDirectory,
  );

  /// ✅ THIS LINE FIXES YOUR ERROR
  HydratedBloc.storage = storage;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InAppBrowserBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'In-App Browser',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const InAppBrowserScreen(),
      ),
    );
  }
}

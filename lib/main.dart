import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/database.service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  initDatabase() {
    final databaseService = Get.put(DatabaseService());
    databaseService.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: initDatabase,
              child: const Text('Init Database'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().showDatabases(),
              child: const Text('Show Databases'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().showTables(),
              child: const Text('Show Tables'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().insertUser(),
              child: const Text('Insert User'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().all(),
              child: const Text('All Users'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().find(),
              child: const Text('Find User'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().update(),
              child: const Text('Update User'),
            ),
            ElevatedButton(
              onPressed: () => Get.find<DatabaseService>().delete(),
              child: const Text('Delete User'),
            ),
          ],
        ),
      ),
    );
  }
}

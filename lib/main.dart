// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ed_manager/ed_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EncodeDecodeManager encodeDecodeManager;
  Map<String, dynamic> data = {};
  @override
  void initState() {
    Future.microtask(() {
      generateDummy();
      encodeDecodeManager = EncodeDecodeManager(data);
      encodeDecode().then((value) => encodeDecodeJsonString());
    });

    super.initState();
  }

  void generateDummy() {
    for (var i = 0; i < 1000000; i++) {
      var a = {
        "$i": {"int": i, "double": i.toDouble()},
      };
      data.addAll(a);
    }
  }

  Future<void> encodeDecode() async {
    final Directory appDocumentsDir = await getApplicationCacheDirectory();
    final file = File('${appDocumentsDir.path}/model.bin');
    final firstDate = DateTime.now();
    final encodedData = encodeDecodeManager.encode();
    file.writeAsBytesSync(encodedData);
    final readData = file.readAsBytesSync();
    final lastDate = DateTime.now();
    print((encodeDecodeManager.decode(readData) as Map<String, dynamic>).entries.last);
    print("binary: " "${((file.lengthSync() / 1024) / 1024).toStringAsFixed(1)}mb, Process Time:${lastDate.difference(firstDate).inMilliseconds}ms");
  }

  Future<void> encodeDecodeJsonString() async {
    final Directory appDocumentsDir = await getApplicationCacheDirectory();
    final file = File('${appDocumentsDir.path}/model.json');
    final firstDate = DateTime.now();
    final encodedData = jsonEncode(data);
    file.writeAsStringSync(encodedData);
    final readData = file.readAsStringSync();
    final lastDate = DateTime.now();
    print((json.decode(readData) as Map<String, dynamic>).entries.last);
    print("json: " "${((file.lengthSync() / 1024) / 1024).toStringAsFixed(1)}mb, Process Time:${lastDate.difference(firstDate).inMilliseconds}ms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Access Internal Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String image = "";

  messageDialog(msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Access Internal Storage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image.isEmpty ? Container() : Image.file(File(image)),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                var status = await Permission.storage.request();

                var image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    this.image = image.path;
                  });
                }
                messageDialog("Image Selected Success");
              },
              child: const Text('Select Image From Device')),
          ElevatedButton(
              onPressed: () async {
                var status = await Permission.storage.request();

                if (status == PermissionStatus.granted) {
                  var read = await File(image).readAsBytes();
                  var new_file_create =
                      await File("/storage/emulated/0/myfile.png")
                          .create(recursive: true);

                  await new_file_create.writeAsBytes(read);
                  messageDialog("Image Created Success");
                }
              },
              child: const Text('Create File in Device')),
          ElevatedButton(
              onPressed: () async {
                var file = File("/storage/emulated/0/myfile.png");
                file.renameSync("/storage/emulated/0/my_new_file.png");

                const snackBar = SnackBar(content: Text("File Rename Success"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Rename File Name in Device')),
          ElevatedButton(
              onPressed: () async {
                var file = File(image);
                print(await file.lastModified());
                print(await file.statSync());

                messageDialog("File Information Success");
              },
              child: const Text('Get File Information')),
          ElevatedButton(
              onPressed: () async {
                var read = await File(image).readAsBytes();

                var file = await File("/storage/emulated/0/my_new_file.png")
                    .delete(recursive: true);

                messageDialog("File Delete Success");
              },
              child: const Text('Delete File From Device'))
        ],
      ),
    );
  }
}

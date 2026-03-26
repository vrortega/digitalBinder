import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/binder_model.dart';
import '../binder/binder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<BinderModel> binders = [];

  @override
  void initState() {
    super.initState();
    loadBinders();
  }

  Future<void> loadBinders() async {

    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString("binders");

    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    binders = decoded.map((e) => BinderModel.fromJson(e)).toList();

    setState(() {});
  }

  Future<void> saveBinders() async {

    final prefs = await SharedPreferences.getInstance();

    final json = jsonEncode(
      binders.map((e) => e.toJson()).toList(),
    );

    await prefs.setString("binders", json);
  }

  Future<void> createBinder() async {

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final binder = BinderModel(
      id: id,
      name: "New Binder",
    );

    binders.add(binder);

    await saveBinders();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BinderPage(
          binderId: binder.id,
        ),
      ),
    ).then((_) {
      loadBinders();
    });
  }

  /// 🔥 reconstrói o arquivo a partir do fileName
  Future<File?> getPreviewFile(String? fileName) async {
    if (fileName == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/binder_images/$fileName');

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  Widget binderCard(BinderModel binder) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BinderPage(
              binderId: binder.id,
            ),
          ),
        ).then((_) {
          loadBinders();
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: const Color(0xFFF9F7F5),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [

            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),

              child: FutureBuilder<File?>(
                future: getPreviewFile(binder.preview),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }

                  final file = snapshot.data;

                  if (file != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  return const Icon(Icons.photo);
                },
              ),
            ),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  binder.name,
                  style: const TextStyle(
                    fontFamily: "Sora",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${binder.cardCount} cards",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEA),

      body: binders.isEmpty
          ? const Center(
              child: Text(
                "No binders yet",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: binders.length,
              itemBuilder: (context, index) {
                return binderCard(binders[index]);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: createBinder,
        backgroundColor: const Color(0xFFD8CFC7),
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
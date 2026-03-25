import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEA),

      body: binders.isEmpty
          ? const Center(
              child: Text(
                "No binders yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: binders.length,
              itemBuilder: (context, index) {

                final binder = binders[index];

                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(binder.name),
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
                );
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
// main.dart
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:lgp/bookmark/bookmark-detail.dart';
import 'package:lgp/sqlhelper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:sqflite/sqflite.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key);

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      // if (id == null) {
                      //   await _addItem();
                      // }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  // Future<void> _addItem() async {
  //   await SQLHelper.createItem(
  //       _titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(String id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Berhasil Dihapus!'),
    ));
    _refreshJournals();
  }

  void SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        SQLHelper.emptyCache();
        Alert(context: context, title: 'Bookmark Dikosongkan!', buttons: [
          DialogButton(
              child: Text('OK'),
              onPressed: () {
                _refreshJournals();
                Navigator.pop(context);
              })
        ]).show();

        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => SettingPage()));
        break;
      // case 1:
      //   print("Privacy Clicked");
      //   break;
      // case 2:
      //   print("User Logged out");
      //   // Navigator.of(context).pushAndRemoveUntil(
      //   //     MaterialPageRoute(builder: (context) => LoginPage()),
      //   //     (route) => false);
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 13, 9, 243),
                Color.fromARGB(255, 11, 55, 90)
              ])),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: Color.fromARGB(255, 239, 240, 248),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Kosongkan Bookmark",
                      style: TextStyle(color: Colors.black),
                    )),
                // PopupMenuItem<int>(
                //     value: 1, child: Text("Privacy Policy page")),
                // PopupMenuDivider(),
                // PopupMenuItem<int>(
                //     value: 2,
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.logout,
                //           color: Colors.black,
                //         ),
                //         const SizedBox(
                //           width: 7,
                //         ),
                //         Text("Logout")
                //       ],
                //     )),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Color.fromARGB(255, 245, 245, 248),
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookmarkDetail(id: _journals[index]['cache']),
                          ));
                    },
                    title: Text(_journals[index]['nama']),
                    // subtitle: Text(_journals[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteItem(_journals[index]['cache']);
                              setState(() {});
                            }),
                      ),
                    )),
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () => _showForm(null),
      // ),
    );
  }
}

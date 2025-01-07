// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, unnecessary_statements, unused_field

import 'dart:convert';
import 'dart:typed_data';
import 'package:bookshop/pages/list_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contact_controller.dart';
import '../model/book.dart';
import '../utils/db_helper.dart';
import '../utils/table_names.dart';
import '../widgets/book_view.dart';
import 'create_list_view.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final _contactController = Get.put(ContactController());

  final searchboxController = TextEditingController();

  var isSearching = false;
  showalertdialog(BookEntity contact) {
    Get.defaultDialog(
      title: 'Confirm',
      onCancel: () {},
      content: const Text('Are you sure to delete?'),
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await DatabaseHelper.instance
            .delete(
              contact.id!,
              TableNames.CONTACT_TABLE,
            )
            .then((value) => Get.find<ContactController>().getContacts());
        Get.back();
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  getImageBytes(BookEntity data) {
    Uint8List bytes = const Base64Codec().decode(data.image.toString());
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: !isSearching
            ? const Text("My Books")
            : TextFormField(
                controller: searchboxController,
                autofocus: true,
                onChanged: (value) =>
                    Get.find<ContactController>().runFilter(value),
                decoration: const InputDecoration(
                  hintText: 'Search Something',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: isSearching
                ? const Icon(Icons.cancel)
                : const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Obx(
            () => Get.find<ContactController>().filteredContacts.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        Get.find<ContactController>().filteredContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      BookEntity contact =
                          Get.find<ContactController>().filteredContacts[index];
                      return InkWell(
                          child: BookView(contact: contact),
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ListDetailsPage(bookEntity: contact),
                                ),
                              )
                          //     ListTile(
                          //   leading: contact.image != ''
                          //       ? Image.memory(getImageBytes(contact))
                          //       : Icon(Icons.image_rounded),
                          //   //                backgroundColor: Color.fromARGB(255, 94, 208, 153)

                          //   title: Text(
                          //     contact.name ?? '',
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          //   trailing: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       IconButton(
                          //         onPressed: () {
                          //           Get.to(() => ListEditPage(
                          //                 contact: contact,
                          //               ));
                          //         },
                          //         icon: Icon(Icons.edit),
                          //       ),
                          //       IconButton(
                          //       onPressed: () => showalertdialog(contact),
                          //         icon: Icon(Icons.remove_circle),
                          //       ),
                          //     ],
                          //   ),
                          // )
                          );
                    },
                  )
                : const Center(
                    child: Text('No contact found'),
                  ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_contact',
            onPressed: () {
              Get.to(
                () => const ListCreatePage(),
                transition: Transition.rightToLeft,
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

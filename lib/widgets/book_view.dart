import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contact_controller.dart';
import '../model/book.dart';
import '../pages/edit_list_view.dart';
import '../utils/db_helper.dart';
import '../utils/table_names.dart';

class BookView extends StatelessWidget {
  final BookEntity contact;
  const BookView({Key? key, required this.contact}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: const Key("product.image"),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Container(
            color: const Color.fromARGB(255, 208, 210, 207),
            child: SizedBox(
              height: 150,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    color: const Color.fromARGB(255, 162, 174, 158),
                    width: (MediaQuery.of(context).size.width) / 2,
                    child: contact.image != ''
                        ? Image.memory(getImageBytes(contact))
                        : const Icon(Icons.image_rounded),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(contact.name.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.right),
                        contact.des.toString().length > 35
                            ? Text(
                                "${contact.des.toString().substring(0, 35)} .....",
                              )
                            : Text(
                                contact.des.toString(),
                              ),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => ListEditPage(
                                          contact: contact,
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => showalertdialog(contact),
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Uint8List getImageBytes(BookEntity contact) {
    Uint8List bytes = const Base64Codec().decode(contact.image.toString());

    return bytes;
  }

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
}

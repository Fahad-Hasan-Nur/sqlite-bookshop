import 'dart:convert';
import 'dart:typed_data';

import 'package:bookshop/model/book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_list_view.dart';

class ListDetailsPage extends StatefulWidget {
  const ListDetailsPage({Key? key, required this.bookEntity}) : super(key: key);

  final BookEntity bookEntity;

  @override
  _ListDetailsPageState createState() => _ListDetailsPageState();
}

class _ListDetailsPageState extends State<ListDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          //    title: Text(widget.bookEntity.name.toString()),
          ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.height / 3.3,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(getImageBytes(
                              widget.bookEntity.image.toString()))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          widget.bookEntity.name.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Color.fromARGB(255, 6, 69, 8)),
                        ),
                        Text(
                          widget.bookEntity.des.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromARGB(255, 2, 4, 2)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 220,
              child: InkWell(
                onTap: () {
                  Get.to(() => ListEditPage(
                        contact: widget.bookEntity,
                      ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 12,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: const Icon(Icons.create),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 163, 238, 126),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            Text(
              "Publioshed On:  ${widget.bookEntity.dop.toString().substring(0, 10)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List getImageBytes(String contact) {
    Uint8List bytes = const Base64Codec().decode(contact.toString());
    return bytes;
  }
}

class ListDetailsCard extends StatelessWidget {
  const ListDetailsCard({
    Key? key,
    required this.leadinicon,
    required this.trallingicon,
    required this.titletext,
    // required this.subtext,
    required this.trallingicon2,
    required this.isPhone,
  }) : super(key: key);
  final IconData leadinicon, trallingicon, trallingicon2;
  final String titletext; //, subtext;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadinicon),
      title: Text(titletext),
      // subtitle: Text(subtext),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isPhone
              ? IconButton(
                  icon: Icon(trallingicon),
                  onPressed: () {},
                )
              : Container(),
          isPhone
              ? IconButton(
                  icon: Icon(trallingicon2),
                  onPressed: () {},
                )
              : Container(),
        ],
      ),
    );
  }
}

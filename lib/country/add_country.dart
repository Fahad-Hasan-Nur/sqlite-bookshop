import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contact_controller.dart';
import '../utils/db_helper.dart';
import '../utils/table_names.dart';

class AddCountry extends StatefulWidget {
  const AddCountry({Key? key}) : super(key: key);

  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Country'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(children: [
            TextFormField(
              controller: countryController,
              decoration: const InputDecoration(
                hintText: 'country name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                int id = await DatabaseHelper.instance.insert(
                  {
                    DatabaseHelper.countryName: countryController.text,
                  },
                  TableNames.COUNTRY_TABLE,
                );
                if (id > 0) {
                  Get.find<ContactController>().getContacts();
                  Get.find<ContactController>().getCountries();
                  Get.back();
                }
              },
              child: const Text('Add'),
            ),
          ]),
        ),
      ),
    );
  }
}

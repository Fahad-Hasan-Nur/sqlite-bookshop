import 'dart:typed_data';
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../controller/contact_controller.dart';
import '../country/add_country.dart';
import '../model/country.dart';
import '../utils/db_helper.dart';
import '../utils/helper_functions.dart';
import '../utils/table_names.dart';

class ListCreatePage extends StatefulWidget {
  const ListCreatePage({Key? key}) : super(key: key);

  @override
  _ListCreatePageState createState() => _ListCreatePageState();
}

class _ListCreatePageState extends State<ListCreatePage> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime? dob = DateTime.now();

  String _dropDownValue = 'Select Country';

  int _selectedCountryId = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  //...

  String image = '';

  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() async {
        var imageFile = pickedFile;
        Uint8List imagebytes =
            await imageFile!.readAsBytes(); //convert to bytes
        image = base64.encode(imagebytes);
      });
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add optional parameters'),
                actions: <Widget>[
                  TextButton(
                      child: const Text('PICK'),
                      onPressed: () {
                        final double? width = maxWidthController.text.isNotEmpty
                            ? double.parse(maxWidthController.text)
                            : null;
                        final double? height =
                            maxHeightController.text.isNotEmpty
                                ? double.parse(maxHeightController.text)
                                : null;
                        final int? quality = qualityController.text.isNotEmpty
                            ? int.parse(qualityController.text)
                            : null;
                        onPick(width, height, quality);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
  //...

  get key => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: RequiredValidator(errorText: 'name is required'),
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
      ),
    );

    final descriptionField = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
        minLines: 2,
      ),
    );

    final dropdownField = Obx(() {
      var newCountries = Get.find<ContactController>().countries;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: _dropDownValue,
                isExpanded: true,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    _dropDownValue = newValue!;
                  });

                  for (var item in newCountries) {
                    if (item.countryName == newValue) {
                      _selectedCountryId = item.id!;
                      break;
                    }
                  }
                },
                items: newCountries.map((Country data) {
                  return DropdownMenuItem(
                    value: data.countryName,
                    child: Text(
                      data.countryName!,
                    ),
                  );
                }).toList(),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Colors.green,
                tooltip: "Add Country Now",
                onPressed: () {
                  Get.to(
                    () => const AddCountry(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: const Icon(Icons.add))
          ],
        ),
      );
    });

    final dateField = Padding(
        padding: const EdgeInsets.all(8.0),
        child: DateTimeField(
          decoration: const InputDecoration(
            labelText: 'Date of Publish',
          ),
          format: format,
          onShowPicker: (context, currentValue) async {
            // dob = currentValue;
            await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
            ).then((value) => dob = value);

            return dob;
          },
        ));

    final submitButton = MaterialButton(
      color: Colors.green,
      onPressed: () async {
        await DatabaseHelper.instance.insert(
          {
            DatabaseHelper.columnName: nameController.text,
            DatabaseHelper.columnImage: image,
            DatabaseHelper.columnDes: descriptionController.text,
            DatabaseHelper.columnDop: dob.toString(),
            DatabaseHelper.columnCountryId: _selectedCountryId,
            DatabaseHelper.columnCreatedAt: getTimeNow(),
            DatabaseHelper.columnUpdatedAt: getTimeNow(),
          },
          TableNames.CONTACT_TABLE,
        );

        Get.find<ContactController>().getContacts();
        Get.back();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Save',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );

    final imageField =
        Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Semantics(
        child: FloatingActionButton(
          onPressed: () {
            _onImageButtonPressed(ImageSource.gallery, context: context);
          },
          child: const Icon(Icons.photo),
        ),
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new contact'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nameField,
                descriptionField,
                imageField,
                dropdownField,
                dateField,
                const SizedBox(height: 20),
                submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

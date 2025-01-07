import 'dart:convert';
import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controller/contact_controller.dart';
import '../country/add_country.dart';
import '../model/book.dart';
import '../model/country.dart';
import '../utils/db_helper.dart';
import '../utils/helper_functions.dart';
import '../utils/table_names.dart';
import 'create_list_view.dart';

class ListEditPage extends StatefulWidget {
  const ListEditPage({Key? key, required this.contact}) : super(key: key);
  final BookEntity contact;

  @override
  _ListEditPageState createState() => _ListEditPageState();
}

class _ListEditPageState extends State<ListEditPage> {
  int _selectedCountryId = 0;

  final format = DateFormat("yyyy-MM-dd");
  DateTime? dob;

  late DateTime _initialDate;

  String _dropDownValue = 'Select Country';

  List<String> text = ["InduceSmile.com", "Flutter.io", "google.com"];

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController desController = TextEditingController();
//...

  String image = '';

  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );

        setState(() async {
          var imageFile = pickedFile;
          Uint8List imagebytes =
              await imageFile!.readAsBytes(); //convert to bytes
          image = base64.encode(imagebytes);
          setState(() {});
        });
      } catch (e) {
        setState(() {});
      }
    });
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
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: maxWidthController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          hintText: 'Enter maxWidth if desired'),
                    ),
                    TextField(
                      controller: maxHeightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          hintText: 'Enter maxHeight if desired'),
                    ),
                    TextField(
                      controller: qualityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Enter quality if desired'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
  void initializeValue() {
    nameController.text = widget.contact.name ?? '';
    imageController.text = widget.contact.image ?? '';
    desController.text = widget.contact.des ?? '';

    var countries = Get.find<ContactController>().countries;
    _selectedCountryId = widget.contact.countryId ?? 0;

    for (var item in countries) {
      if (item.id == widget.contact.countryId) {
        setState(() {
          _dropDownValue = item.countryName!;
        });
        break;
      }
    }

    dob = widget.contact.dop!.isNotEmpty
        ? DateTime.parse(widget.contact.dop!)
        : null;
    _initialDate = widget.contact.dop!.isNotEmpty
        ? DateTime.parse(widget.contact.dop!)
        : DateTime.now();
  }

  @override
  void initState() {
    initializeValue();
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

    final desField = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: desController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
        minLines: 2,
      ),
    );

    final imageField =
        Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Semantics(
        label: 'image_picker_example_from_gallery',
        child: FloatingActionButton(
          onPressed: () {
            _onImageButtonPressed(ImageSource.gallery, context: context);
          },
          heroTag: 'image0',
          tooltip: 'Pick Image from gallery',
          child: const Icon(Icons.photo),
        ),
      ),
    ]);

    // final dropdownField1 = Container(
    //   // width: 330,
    //   child: Obx(() {
    //     var newCountries = Get.find<ContactController>().countries;

    //     return DropdownButton<String>(
    //       value: _dropDownValue,
    //       isExpanded: true,
    //       elevation: 16,
    //       onChanged: (String? newValue) {
    //         setState(() {
    //           _dropDownValue = newValue!;
    //         });

    //         for (var item in newCountries) {
    //           if (item.countryName == newValue) {
    //             _selectedCountryId = item.id!;
    //             break;
    //           }
    //         }
    //       },
    //       items: newCountries.map((Country data) {
    //         return DropdownMenuItem(
    //           value: data.countryName,
    //           child: Text(
    //             data.countryName!,
    //           ),
    //         );
    //       }).toList(),
    //     );
    //   }),
    // );

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
          initialValue: dob,
          decoration: const InputDecoration(
            labelText: 'Date of Publish',
          ),
          format: format,
          onShowPicker: (context, currentValue) async {
            // dob = currentValue;
            await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: _initialDate,
              lastDate: DateTime(2100),
            ).then((value) => dob = value);
            return dob;
            // ).then((pickedDate) {
            //   dob = pickedDate;
            // });
          },
        ));

    final submitButton = MaterialButton(
      color: Colors.green,
      onPressed: () async {
        if (image == '') {
          image = widget.contact.image.toString();
        }
        await DatabaseHelper.instance.update(
          {
            DatabaseHelper.columnId: widget.contact.id,
            DatabaseHelper.columnName: nameController.text,
            DatabaseHelper.columnImage: image,
            DatabaseHelper.columnDes: desController.text,
            DatabaseHelper.columnDop: dob.toString(),
            DatabaseHelper.columnCountryId: _selectedCountryId,
            DatabaseHelper.columnCreatedAt: widget.contact.createdAt,
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
        'Update',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update contact'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                nameField,
                desField,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (image != '')
                      Image.memory(
                        getImageBytes(image),
                        height: 100,
                      )
                    else if (widget.contact.image != '')
                      Image.memory(
                        getImageBytes(widget.contact.image.toString()),
                        height: 100,
                      )
                    else
                      const Icon(Icons.image),
                    imageField
                  ],
                ),
                dropdownField,
                dateField,
                const SizedBox(height: 10),
                submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Uint8List getImageBytes(String image) {
    Uint8List bytes = const Base64Codec().decode(image.toString());

    return bytes;
  }
}

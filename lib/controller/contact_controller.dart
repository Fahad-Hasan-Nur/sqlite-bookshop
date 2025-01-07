import 'package:bookshop/model/book.dart';
import 'package:bookshop/model/country.dart';
import 'package:bookshop/utils/contacts_list.dart';
import 'package:get/get.dart';

import '../utils/db_helper.dart';
import '../utils/table_names.dart';

class ContactController extends GetxController {
  List<BookEntity> contacts = <BookEntity>[].obs;
  // List<ContactEntity> filteredContacts = <ContactEntity>[].obs;
  List<BookEntity> filteredContacts = <BookEntity>[].obs;

  ContactList contactList = ContactList();
  List<Country> countries = <Country>[].obs;

  getContacts() async {
    List<Map<String, dynamic>> allContacts =
        await DatabaseHelper.instance.queryAll(TableNames.CONTACT_TABLE);
    if (contacts.isNotEmpty) {
      contacts.clear();
      for (var item in allContacts) {
        contacts.add(BookEntity.fromJson(item));
      }
    } else {
      for (var item in allContacts) {
        contacts.add(BookEntity.fromJson(item));
      }
    }
    contacts.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });
    if (filteredContacts.isNotEmpty) {
      filteredContacts.clear();
      filteredContacts.addAll(contacts);
    } else {
      filteredContacts.addAll(contacts);
    }
    // for (var item in contacts) {
    //   var dob = item.dob ?? '';
    //   var date = dob != '' ? getCustomDate(dob) : '';
    //   print('contacts ${item.dob} = dob = $date');
    // }
  }

  void runFilter(String keyword) {
    List<BookEntity> results = [];
    if (keyword.trim().isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = contacts;
    } else {
      results = contacts
          .where((contact) => contact.name!
              .toLowerCase()
              .contains(keyword.trim().toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    if (filteredContacts.isNotEmpty) {
      filteredContacts.clear();
      filteredContacts.addAll(results);
    } else {
      filteredContacts.addAll(results);
    }

    // filteredContacts.addAll(results);
    // filteredContacts = results;
  }

  getCountries() async {
    List<Map<String, dynamic>> allCountries =
        await DatabaseHelper.instance.queryAll(TableNames.COUNTRY_TABLE);

    if (countries.isNotEmpty) {
      countries.clear();
      countries.add(Country(id: 0, countryName: 'Select Country'));
      for (var item in allCountries) {
        countries.add(Country.fromJson(item));
      }
    } else {
      countries.add(Country(id: 0, countryName: 'Select Country'));
      for (var item in allCountries) {
        countries.add(Country.fromJson(item));
      }
    }
    countries.sort((a, b) {
      return a.countryName
          .toString()
          .toLowerCase()
          .compareTo(b.countryName.toString().toLowerCase());
    });
  }

  @override
  void onInit() {
    getContacts();
    getCountries();
    super.onInit();
  }
}

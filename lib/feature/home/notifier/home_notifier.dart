import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task/config/constants.dart';
import 'package:flutter_task/feature/details/widgets/details.dart';
import 'package:flutter_task/feature/history/widgets/history.dart';
import 'package:flutter_task/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNotifier extends ChangeNotifier {
  late BuildContext context;

  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextFocusNode = FocusNode();

  late List<dynamic> petsList;
  late SharedPreferences sharedPreferences;
  Map<String, dynamic> alreadyAdoptedPets = {};

  int currentPage = 0;
  int itemsPerPage = 5;

  HomeNotifier(this.context);

  Future<void> init() async {
    searchTextController.addListener(() {
      searchTextController.selection = TextSelection.collapsed(offset: searchTextController.text.length);
    });

    // Clear previous state
    petsList = [];
    alreadyAdoptedPets = {};
    currentPage = 0;

    // Load new data
    petsList = pets;
    sharedPreferences = await SharedPreferences.getInstance();
    String adoptedPetsAsString = sharedPreferences.getString(Constants.prefKeyAdoptedPets) ?? '{}';
    sharedPreferences.remove(Constants.prefKeyAdoptedPets);

    notifyListeners();
  }

  void onSearchTextChange(String? value) {
    searchTextController.text = value ?? '';
    if (value != null && value.isNotEmpty) {
      petsList = pets.where((element) => (element["name"].toLowerCase()).contains(searchTextController.text.toLowerCase())).toList();
    } else {
      petsList = pets;
    }
    notifyListeners();
  }

  void onHistoryIconTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => History(alreadyAdoptedPets: alreadyAdoptedPets),
      ),
    );
  }

  Future<void> onTapCard(int index) async {
    searchTextFocusNode.unfocus();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(petsList[index]),
      ),
    );
    try {
      String adoptedPetsAsString = sharedPreferences.getString(Constants.prefKeyAdoptedPets) ?? '';
      alreadyAdoptedPets = json.decode(adoptedPetsAsString);
    } catch (e) {}
    notifyListeners();
  }

  void nextPage() {
    if ((currentPage + 1) * itemsPerPage < petsList.length) {
      currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
    } else {
      // If already on the first page, reset to the last page
      currentPage = (petsList.length / itemsPerPage).ceil() - 1;
    }
    notifyListeners();
  }

  List<dynamic> getCurrentPagePets() {
    int start = currentPage * itemsPerPage;
    int end = (currentPage + 1) * itemsPerPage;
    return petsList.sublist(start, end < petsList.length ? end : petsList.length);
  }

  bool canShowNextPage() {
    return (currentPage + 1) * itemsPerPage < petsList.length;
  }

  bool canShowPreviousPage() {
    return currentPage > 0;
  }
}

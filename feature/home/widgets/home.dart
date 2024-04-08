import 'package:flutter/material.dart';
import 'package:flutter_task/feature/home/notifier/home_notifier.dart';
import 'package:flutter_task/feature/home/widgets/pet_widget.dart';
import 'package:flutter_task/utils/utils.dart';
import 'package:flutter_task/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeNotifier _notifier;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _notifier = HomeNotifier(context);
    _notifier.init();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    isDarkMode ? Utils.setDarkStatusBar() : Utils.setLightStatusBar();

    return ChangeNotifierProvider(
      create: (_) => _notifier,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _appBar(),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Home Page',
                  textScaleFactor: 3,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              _searchFieldWidget(),
              _petListWidget(),
              _paginationControls(), // Add pagination controls
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchFieldWidget() {
    return Consumer<HomeNotifier>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextField(
          hint: 'Search',
          controller: _notifier.searchTextController,
          onChange: _notifier.onSearchTextChange,
          focusNode: _notifier.searchTextFocusNode,
        ),
      ),
    );
  }

  Widget _petListWidget() {
    return Consumer<HomeNotifier>(
      builder: (context, value, child) {
        final currentPagePets = _notifier.getCurrentPagePets();
        return currentPagePets.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            key: const Key('petList'),
            itemBuilder: (context, index) => PetWidget(
              pet: currentPagePets[index],
              onTap: () => _notifier.onTapCard(index),
              isAlreadyAdopted: !_notifier.alreadyAdoptedPets.containsKey(currentPagePets[index]['id']),
            ),
            itemCount: currentPagePets.length,
          ),
        )
            : const Center(
          child: Text('No pets found.'),
        );
      },
    );
  }

  Widget _appBar() {
    return Consumer<HomeNotifier>(
      builder: (context, value, child) => Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: _notifier.onHistoryIconTap,
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
            child: const Icon(
              Icons.bookmark,
              color: Colors.blue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _paginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _notifier.canShowPreviousPage() ? _notifier.previousPage : null,
          icon: Icon(Icons.arrow_back),
        ),
        SizedBox(width: 16),
        Text(
          '${_notifier.currentPage + 1}', // Display current page number
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16),
        IconButton(
          onPressed: _notifier.canShowNextPage() ? _notifier.nextPage : null,
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }



}


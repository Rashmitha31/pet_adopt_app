import 'package:flutter/material.dart';
import 'package:flutter_task/feature/details/widgets/details.dart';
import 'package:flutter_task/feature/history/widgets/history.dart';
import 'package:flutter_task/feature/home/widgets/home.dart';

class Routes {
  static const String homeRoute = '/';
  static const String detailsRoute = '/details';
  static const String historyRoute = '/history';

  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      homeRoute: (_) => const Home(),
      detailsRoute: (_) => const Details(""),
      historyRoute: (_) => const History(alreadyAdoptedPets: {}),
    };
  }
}
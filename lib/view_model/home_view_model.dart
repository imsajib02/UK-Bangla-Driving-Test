import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/repository/home_repository.dart';


class HomeViewModel extends ChangeNotifier {

  bool shouldShow = false;

  void shouldShowTheoryTestAlert() async {

    shouldShow = await HomeRepository().shouldShowTheoryTestAlert();
    notifyListeners();
  }
}
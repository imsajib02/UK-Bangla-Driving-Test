import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/repository/theory_test_repository.dart';

class TheoryTestViewModel extends ChangeNotifier {

  bool isLoading = false;
  bool isPassGuaranteeModeOn = false;

  void getPassGuaranteeModeStatus() async {

    isPassGuaranteeModeOn = await TheoryTestRepository().getPassGuaranteeModeStatus();
    notifyListeners();
  }
}
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/localization/localization_constrants.dart';
import 'package:ukbangladrivingtest/main.dart';
import 'package:ukbangladrivingtest/model/test_result_page_model.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/repository/question_answer_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class TestResultViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = true;

  String bestCategory = "";
  String bestCategoryBangla = "";
  String worstCategory = "";
  String worstCategoryBangla = "";
  String message = "";
  String language = "";
  String timeTaken = "";
  String timeTakenBangla = "";
  String timeRemaining = "";
  String timeRemainingBangla = "";

  String totalQuestion = "";
  String correctNumber = "";

  List<int> correctList = List();
  List<int> incorrectList = List();
  List<int> flaggedList = List();

  List<String> allIndexBanglaList = List();

  LocalMemory _localMemory = LocalMemory();

  double successRate = 0;
  String stringSuccessRate = "০";

  static const int all = 0;
  static const int correct = 1;
  static const int incorrect = 2;
  static const int flagged = 3;
  int currentIndex = 0;



  Future<void> setLanguage(BuildContext context) async {

    if(!isDisposed && language == "") {

      int languageID = await QuestionAnswerRepository().getQuestionAnswerLanguage();

      switch(languageID) {

        case 1:
          language = AppLocalization.of(context).getTranslatedValue("en");
          break;

        case 2:
          language = AppLocalization.of(context).getTranslatedValue("bn");
          break;
      }

      notifyListeners();
    }
  }



  Future<void> getResultStatistics(TestResultPageModel resultModel, BuildContext context) async {

    if(!isDisposed) {

      totalQuestion = await _translateNumber(resultModel.questionList.list.length);

      correctList.clear();
      incorrectList.clear();
      flaggedList.clear();
      allIndexBanglaList.clear();

      Set<int> correctCategoryList = HashSet();
      List<int> totalCorrectList = List();
      List<int> totalCount = List();
      List<int> temp = List();


      for(int i=0; i<resultModel.questionList.list.length; i++) {

        allIndexBanglaList.add(await _translateNumber(i+1));

        if(resultModel.questionList.list[i].isFlagged) {
          flaggedList.add(i);
        }


        if(resultModel.questionList.list[i].isAnswered) {

          if(resultModel.questionList.list[i].isAnsweredCorrectly) {

            correctList.add(i);
            correctCategoryList.add(resultModel.questionList.list[i].categoryID);
            totalCorrectList.add(resultModel.questionList.list[i].categoryID);
          }
          else {
            incorrectList.add(i);
          }
        }
      }


      correctNumber = await _translateNumber(correctList.length);


      successRate = (100 * correctList.length) / resultModel.questionList.list.length;
      stringSuccessRate = await _translateNumber(successRate.floor());


      if((successRate / 10) >= 0.0 && (successRate / 10) <= 3.0) {

        message = AppLocalization.of(context).getTranslatedValue("keep_practising");
      }
      else if((successRate / 10) > 3.0 && (successRate / 10) <= 6.0) {

        message = AppLocalization.of(context).getTranslatedValue("improving");
      }
      else if((successRate / 10) > 6.0 && (successRate / 10) <= 9.0) {

        message = AppLocalization.of(context).getTranslatedValue("well_done");
      }
      else {

        message = AppLocalization.of(context).getTranslatedValue("perfection");
      }


      if(resultModel.isMockTest) {

        if(!resultModel.isComplete) {
          message = AppLocalization.of(context).getTranslatedValue("not_complete");
        }

        Duration duration = Duration(seconds: resultModel.timeTaken);

        String twoDigits(int n) => n.toString().padLeft(2, "0");

        String minutes = twoDigits(duration.inMinutes.remainder(60));
        String seconds = twoDigits(duration.inSeconds.remainder(60));

        timeTaken = minutes + AppLocalization.of(context).getTranslatedValue("min") +
            seconds + AppLocalization.of(context).getTranslatedValue("sec");

        minutes = await _translateNumber(int.tryParse(twoDigits(duration.inMinutes.remainder(60))));
        seconds = await _translateNumber(int.tryParse(twoDigits(duration.inSeconds.remainder(60))));

        timeTakenBangla = minutes + AppLocalization.of(context).getTranslatedValue("min") +
            seconds + AppLocalization.of(context).getTranslatedValue("sec");

        duration = Duration(seconds: resultModel.timeRemaining);

        minutes = twoDigits(duration.inMinutes.remainder(60));
        seconds = twoDigits(duration.inSeconds.remainder(60));

        timeRemaining = minutes + AppLocalization.of(context).getTranslatedValue("min") +
            seconds + AppLocalization.of(context).getTranslatedValue("sec");

        minutes = await _translateNumber(int.tryParse(twoDigits(duration.inMinutes.remainder(60))));
        seconds = await _translateNumber(int.tryParse(twoDigits(duration.inSeconds.remainder(60))));

        timeRemainingBangla = minutes + AppLocalization.of(context).getTranslatedValue("min") +
            seconds + AppLocalization.of(context).getTranslatedValue("sec");
      }


      for(int i=0; i<correctCategoryList.length; i++) {

        int total = 0;

        for(int j=0; j<totalCorrectList.length; j++) {

          if(totalCorrectList[j] == correctCategoryList.elementAt(i)) {
            total = total + 1;
          }
        }

        totalCount.add(total);
        temp.add(total);
      }


      try {

        temp.sort();

        if(totalCount.length > 1) {

          bestCategory = Constants.categories[totalCount.indexOf(temp.last)];
          bestCategoryBangla = Constants.categoriesBangla[totalCount.indexOf(temp.last)];

          if(totalCount.indexOf(temp.first) == 0) {
            worstCategory = "";
            worstCategoryBangla = "";
          }
          else {
            worstCategory = Constants.categories[totalCount.indexOf(temp.first)];
            worstCategoryBangla = Constants.categoriesBangla[totalCount.indexOf(temp.first)];
          }
        }
        else {
          bestCategory = Constants.categories[correctCategoryList.first];
          bestCategoryBangla = Constants.categoriesBangla[correctCategoryList.first];
        }
      }
      catch(error) {}
    }

    notifyListeners();
  }



  Future<void> alterLanguage(BuildContext context) async {

    if(!isDisposed) {

      if(language == AppLocalization.of(context).getTranslatedValue("en")) {
        await QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[1]);
        language = AppLocalization.of(context).getTranslatedValue("bn");
        await _changeAppLanguage(context, BANGLA);
      }
      else {
        await QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[0]);
        language = AppLocalization.of(context).getTranslatedValue("en");
        await _changeAppLanguage(context, ENGLISH);
      }

      notifyListeners();
    }
  }


  Future<void> _changeAppLanguage(BuildContext context, String languageCode) async {

    _localMemory.saveLanguageCode(languageCode).then((locale) {

      MyApp.setLocale(context, locale);
    });
  }



  void setTab(int index) {

    if(!isDisposed) {

      switch (index) {

        case all:
          currentIndex = all;
          break;

        case correct:
          currentIndex = correct;
          break;

        case incorrect:
          currentIndex = incorrect;
          break;

        case flagged:
          currentIndex = flagged;
          break;

        default:
          currentIndex = all;
          break;
      }

      notifyListeners();
    }
  }



  Future<String> _translateNumber(int index) async {

    String indexInBangla = "";

    for(int i=0; i<index.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(index.toString()[i] == Constants.englishNumeric[j]) {

          indexInBangla = indexInBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return indexInBangla;
  }



  Future<void> resetModel() async {

    isDisposed = true;

    bestCategory = "";
    bestCategoryBangla = "";
    worstCategory = "";
    worstCategoryBangla = "";
    message = "";
    language = "";
    timeTaken = "";
    timeTakenBangla = "";
    timeRemaining = "";
    timeRemainingBangla = "";
    stringSuccessRate = "০";

    correctList.clear();
    incorrectList.clear();
    flaggedList.clear();
    allIndexBanglaList.clear();

    successRate = 0;
    currentIndex = all;

    if(!isDisposed) {
      notifyListeners();
    }
  }


  @override
  void removeDisposedStatus() {

    if(isDisposed) {
      isDisposed = false;
    }

    notifyListeners();
  }
}
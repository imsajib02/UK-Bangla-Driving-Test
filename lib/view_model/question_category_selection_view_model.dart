import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/question_category_selection_interface.dart';
import 'package:ukbangladrivingtest/model/theory_category_info.dart';
import 'package:ukbangladrivingtest/repository/home_repository.dart';
import 'package:ukbangladrivingtest/repository/questions_category_selection_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';

class QuestionCategorySelectionViewModel extends ChangeNotifier implements BasicViewModel {

  int numberOfQuestionsSelected = 0;
  int totalNumberOfQuestions = 0;

  String totalNumber = "";
  String totalSelected = "০";

  final int allCategoryIndex = 0;

  bool isDisposed = false;

  List<TheoryCategoryInfo> categoryInfoList = List();



  void getCategoryWiseTotalNumberOfQuestions(QuestionCategorySelectionInterface categorySelectionInterface) async {

    if(categoryInfoList.length == 0) {
      categoryInfoList = await QuestionCategorySelectionRepository().getCategoryWiseNumberOfQuestions();
    }

    if(!isDisposed) {
      categorySelectionInterface.showListView();
      notifyListeners();
    }
  }


  void getTotalNumberOfQuestions() async {

    if(!isDisposed) {

      if(totalNumberOfQuestions == 0) {

        totalNumberOfQuestions = await QuestionCategorySelectionRepository().getTotalNumberOfQuestions();

        totalNumber = await _translateNumber(totalNumberOfQuestions);
      }

      notifyListeners();
    }
  }


  void setSelectedCategory(int index, List<bool> categorySelection, QuestionCategorySelectionInterface categorySelectionInterface) async {

    if(!isDisposed) {

      if(index == allCategoryIndex && !categorySelection[allCategoryIndex]) {

        if(!isDisposed) {
          categorySelectionInterface.selectAllCategory();
          numberOfQuestionsSelected = categoryInfoList[allCategoryIndex].totalQuestions;
        }
      }
      else if(index == allCategoryIndex && categorySelection[allCategoryIndex]) {

        if(!isDisposed) {
          categorySelectionInterface.unSelectAllCategory();
          numberOfQuestionsSelected = 0;
        }
      }
      else if(index != allCategoryIndex && categorySelection[allCategoryIndex]) {

        if(!isDisposed) {
          categorySelectionInterface.unSelectFirstCategory();
          categorySelectionInterface.alterCategorySelection(index);

          numberOfQuestionsSelected = numberOfQuestionsSelected - categoryInfoList[index].totalQuestions;
        }
      }
      else if(index != allCategoryIndex && !categorySelection[allCategoryIndex]) {

        if(!isDisposed) {
          categorySelectionInterface.alterCategorySelection(index);

          if(!categorySelection[index]) {
            numberOfQuestionsSelected = numberOfQuestionsSelected - categoryInfoList[index].totalQuestions;
          }
          else {
            numberOfQuestionsSelected = numberOfQuestionsSelected + categoryInfoList[index].totalQuestions;
          }
        }
      }

      totalSelected = await _translateNumber(numberOfQuestionsSelected);

      notifyListeners();
    }
  }


  Future<String> _translateNumber(int number) async {

    String inBangla = "";

    for(int i=0; i<number.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number.toString()[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }


  Future<void> closeDb() async {
    await QuestionCategorySelectionRepository().closeDb();
  }


  void resetModel() async {

    totalNumber = "";
    totalSelected = "০";

    isDisposed = true;
    numberOfQuestionsSelected = 0;
    totalNumberOfQuestions = 0;
    categoryInfoList.clear();

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

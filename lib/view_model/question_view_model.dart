import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_search_interface.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ukbangladrivingtest/localization/localization_constrants.dart';
import 'package:ukbangladrivingtest/main.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';
import '../interace/basic_view_model.dart';
import '../interace/question_answer_interface.dart';
import '../localization/app_localization.dart';
import '../model/theory_question.dart';
import '../repository/question_answer_repository.dart';
import '../utils/constants.dart';


class QuestionViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = true;
  bool noMatchFound = false;
  bool isVoiceActivated = false;
  bool isSet = false;
  bool isSearching = false;
  bool gotFavs = false;

  String language = "";
  int languageID = 0;

  int number = 0;

  int totalPage = 0;
  String stringTotalPage = "";

  int currentPage = 1;
  String stringCurrentPage = "১";

  FlutterTts flutterTts = FlutterTts();
  LocalMemory _localMemory = LocalMemory();

  String totalSize = "";
  String stringNumber = "০";

  TheoryTestQuestionList allQuestionList = TheoryTestQuestionList(list: List());
  TheoryTestQuestionList filterList = TheoryTestQuestionList(list: List());
  TheoryTestQuestionList favList = TheoryTestQuestionList(list: List());



  Future<void> setNumber(int index, QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      if(!isSet) {

        number = index + 1;
        stringNumber = await _translateNumber(number);

        isSet = true;
        questionAnswerInterface.addAnswers(filterList.list[number-1]);

        speak(true);
      }

      notifyListeners();
    }
  }



  Future<void> onClose() async {

    if(!isDisposed) {

      isSet = false;
      await flutterTts.stop();
      notifyListeners();
    }
  }



  Future<void> alterLanguage(BuildContext context, {QuestionSearchInterface interface}) async {

    try{
      await flutterTts.stop();
    }
    catch(e){}

    if(languageID != 0) {

      switch(languageID) {

        case 1:
          await QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[1]);
          await _changeAppLanguage(context, BANGLA);
          break;

        case 2:
          await QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[0]);
          await _changeAppLanguage(context, ENGLISH);
          break;
      }
    }

    if(interface != null) {
      interface.showSearchList();
      interface.showFavList();
    }

    notifyListeners();
  }



  Future<void> _changeAppLanguage(BuildContext context, String languageCode) async {

    _localMemory.saveLanguageCode(languageCode).then((locale) {

      MyApp.setLocale(context, locale);
    });
  }



  void getAnsweringLanguage(BuildContext context) async {

    languageID = await QuestionAnswerRepository().getQuestionAnswerLanguage();

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




  Future<void> getAllQuestions() async {

    if(!isDisposed) {

      isSearching = true;

      if(allQuestionList.list.length == 0) {

        allQuestionList = await QuestionAnswerRepository().getAllQuestions();
      }
    }
  }




  Future<void> getFavQuestions(QuestionSearchInterface interface) async {

    if(!isDisposed) {

      if(!isSearching) {

        if(!gotFavs) {

          gotFavs = true;

          filterList = await QuestionAnswerRepository().getFavQuestions();
          totalSize = await _translateNumber(filterList.list.length);

          totalPage = (filterList.list.length / 20).ceil();
          stringTotalPage = await _translateNumber(totalPage);

          if(filterList.list.length > 0) {

            interface.showFavList();
          }
          else {

            interface.onNoFavourites();
          }

          notifyListeners();
        }
      }
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




  void setVoiceOverStatus() async {

    QuestionAnswerRepository().setVoiceOverStatus(!isVoiceActivated);
    await flutterTts.stop();
    notifyListeners();
  }




  void getVoiceOverStatus() async {

    isVoiceActivated = await QuestionAnswerRepository().getVoiceOverStatus();
    notifyListeners();
  }




  Future<void> filterQuestions(String pattern, QuestionSearchInterface interface) async {

    if(!isDisposed) {

      filterList.list.clear();

      if(allQuestionList.list.length > 0) {

        for(int i=0; i<allQuestionList.list.length; i++) {

          if(allQuestionList.list[i].question.toLowerCase().contains(pattern.toLowerCase()) || allQuestionList.list[i].questionInBangla.contains(pattern)) {

            filterList.list.add(allQuestionList.list[i]);
          }
        }

        totalSize = await _translateNumber(filterList.list.length);

        totalPage = (filterList.list.length / 20).ceil();
        stringTotalPage = await _translateNumber(totalPage);
      }

      notifyListeners();
    }
  }




  Future<void> increaseNumber(QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      number = number + 1;
      stringNumber = await _translateNumber(number);

      questionAnswerInterface.addAnswers(filterList.list[number-1]);

      speak(true);

      notifyListeners();
    }
  }




  Future<void> decreaseNumber(QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      number = number - 1;
      stringNumber = await _translateNumber(number);

      questionAnswerInterface.addAnswers(filterList.list[number-1]);

      speak(true);

      notifyListeners();
    }
  }




  Future<void> onFavPressed(QuestionAnswerInterface questionAnswerInterface, QuestionSearchInterface searchInterface) async {

    if(!isDisposed) {

      filterList.list[number-1].isMarkedFavourite = !filterList.list[number-1].isMarkedFavourite;
      await QuestionAnswerRepository().setFavouriteStatus(filterList.list[number-1]);

      if(!isSearching) {

        if(filterList.list.length > 1) {

          if(number == 1) {

            filterList.list.removeAt(0);

            number = number - 1;
            increaseNumber(questionAnswerInterface);
          }
          else if(number > 1 && number < filterList.list.length) {

            filterList.list.removeAt(number-1);

            number = number - 1;
            increaseNumber(questionAnswerInterface);
          }
          else if(number == filterList.list.length) {

            decreaseNumber(questionAnswerInterface);
            filterList.list.removeLast();
          }

          stringNumber = await _translateNumber(number);
          searchInterface.showFavList();
        }
        else if(filterList.list.length == 1) {

          searchInterface.onNoFavourites();
          questionAnswerInterface.onClose();
          //filterList.list.removeAt(0);
        }
      }

      totalSize = await _translateNumber(filterList.list.length);

      notifyListeners();
    }
  }




  Future speak(bool isQuestion) async {

    if(!isDisposed) {

      if(isVoiceActivated) {

        if(languageID != 0) {

          await flutterTts.stop();

          await flutterTts.setPitch(0.3);
          await flutterTts.setVolume(1.0);

          languageID == 1 ? await flutterTts.setLanguage("en-US") : await flutterTts.setLanguage("bn-BD");

          if(isQuestion) {

            if(isVoiceActivated) {
              languageID == 1 ? await flutterTts.speak(filterList.list[number-1].question) : await flutterTts.speak(filterList.list[number-1].questionInBangla);
            }
          }
          else {

            if(isVoiceActivated) {
              languageID == 1 ? await flutterTts.speak(filterList.list[number-1].explanation) : await flutterTts.speak(filterList.list[number-1].explanationInBangla);
            }
          }
        }
      }
    }
  }




  Future<void> increasePageNumber() async {

    if(!isDisposed) {
      currentPage = currentPage + 1;
      stringCurrentPage = await _translateNumber(currentPage);
      notifyListeners();
    }
  }




  Future<void> decreasePageNumber() async {

    if(!isDisposed) {
      currentPage = currentPage - 1;
      stringCurrentPage = await _translateNumber(currentPage);
      notifyListeners();
    }
  }




  void clearFilterList() {

    if(!isDisposed) {

      filterList.list.clear();
      totalSize = "";
      notifyListeners();
    }
  }




  Future<void> resetModel() async {

    isDisposed = true;
    noMatchFound = false;
    isVoiceActivated = false;
    isSet = false;
    isSearching = false;
    gotFavs = false;

    language = "";
    stringTotalPage = "";
    stringCurrentPage = "১";
    totalSize = "";
    stringNumber = "০";

    languageID = 0;
    number = 0;
    totalPage = 0;
    currentPage = 1;

    allQuestionList.list.clear();
    filterList.list.clear();
    favList.list.clear();

    if(!isDisposed) {
      notifyListeners();
    }
  }




  @override
  void removeDisposedStatus() {

    if(isDisposed) {
      isDisposed = false;
    }

    //notifyListeners();
  }
}
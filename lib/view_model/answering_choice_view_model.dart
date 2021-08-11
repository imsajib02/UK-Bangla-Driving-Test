import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/answering_choice_interface.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/question_availability.dart';
import 'package:ukbangladrivingtest/repository/answering_choice_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';


class AnsweringChoiceViewModel extends ChangeNotifier implements BasicViewModel {

  static const int mainViewIndex = 0;
  static const int questionBankViewIndex = 1;
  static const int numberOfQuestionViewIndex = 2;
  static const int questionTypeViewIndex = 3;
  static const int infoViewIndex = 4;

  bool autoMoveToNext = false;
  bool isIncorrectAlertActive = false;
  bool isChanged = false;
  bool isValid = true;
  bool isDisposed = true;

  int userTypeID = 0;
  String userType = "";
  int countryCode = 0;
  String countryShortForm = "";
  int numberOfQuestionID = 0;
  String numberOfQuestion = "";
  String numberOfQuestionBangla = "";
  int questionTypeID = 0;
  String questionType = "";
  String questionTypeBangla = "";
  int index = 0;
  String infoMessage = "";
  String language = "";

  IconData topIcon = Icons.refresh;
  String topTitle = "";

  QuestionAvailability questionAvailability = QuestionAvailability(false, 0, 0);

  List<bool> userTypeSelection = [false, false, false];
  List<bool> countrySelection = [false, false];
  List<bool> numberOfQuestionSelection = [false, false, false, false, false, false];
  List<bool> questionTypeSelection = [false, false, false, false];



  void getAutoMoveStatus() async {

    if(!isDisposed) {
      autoMoveToNext = await AnsweringChoiceRepository().getAutoMoveStatus();
      notifyListeners();
    }
  }



  void getIncorrectAlertStatus() async {

    if(!isDisposed) {
      isIncorrectAlertActive = await AnsweringChoiceRepository().getIncorrectAlertStatus();
      notifyListeners();
    }
  }



  void setAutoMoveStatus(bool value) async {

    if(!isDisposed) {
      AnsweringChoiceRepository().setAutoMoveStatus(value);
      notifyListeners();
    }
  }




  void setIncorrectAlertStatus(bool value) async {

    if(!isDisposed) {
      AnsweringChoiceRepository().setIncorrectAlertStatus(value);
      notifyListeners();
    }
  }




  void setCountrySelection(int index) async {

    if(!isDisposed) {

      for(int i=0; i<countrySelection.length; i++) {

        if(i == index) {
          countrySelection[i] = true;
        }
        else {
          countrySelection[i] = false;
        }
      }

      notifyListeners();
    }
  }




  void setIndex(int value) async {

    if(!isDisposed) {
      index = value;
      notifyListeners();
    }
  }




  void onClosed(int index) {

    if(!isDisposed) {

      switch (index) {

        case questionBankViewIndex:
          if(userTypeID != 0) {
            setUserTypeSelection(Constants.userTypeIdList.indexOf(userTypeID));
          }

          if(countryCode != 0) {
            setCountrySelection(Constants.countryCodeList.indexOf(countryCode));
          }

          isChanged = false;
          break;


        case numberOfQuestionViewIndex:
          if(numberOfQuestionID != 0) {
            setNumberOfQuestionSelection(Constants.numberOfQuestionsIdList.indexOf(numberOfQuestionID));
          }
          break;


        case questionTypeViewIndex:
          if(questionTypeID != 0) {
            setQuestionTypeSelection(Constants.questionTypeIdList.indexOf(questionTypeID));
          }
          break;
      }

      setIndex(mainViewIndex);
      notifyListeners();
    }
  }




  void setUserTypeSelection(int index) async {

    if(!isDisposed) {

      for(int i=0; i<userTypeSelection.length; i++) {

        if(i == index) {
          userTypeSelection[i] = true;
        }
        else {
          userTypeSelection[i] = false;
        }
      }

      notifyListeners();
    }
  }




  void getUserType() async {

    if(!isDisposed) {

      if(index != questionBankViewIndex) {

        userTypeID = await AnsweringChoiceRepository().getUserType();

        for(int i=0; i<Constants.userTypeIdList.length; i++) {

          if(Constants.userTypeIdList[i] == userTypeID) {

            userTypeSelection[i] = true;
            userType = Constants.userTypeList[i];
            break;
          }
        }
      }

      notifyListeners();
    }
  }




  void getCountry() async {

    if(!isDisposed) {

      if(index != questionBankViewIndex) {

        countryCode = await AnsweringChoiceRepository().getCountry();

        for(int i=0; i<Constants.countryCodeList.length; i++) {

          if(Constants.countryCodeList[i] == countryCode) {

            countrySelection[i] = true;
            countryShortForm = Constants.countryListShortForm[i];
            break;
          }
        }
      }

      notifyListeners();
    }
  }



  void setNumberOfQuestionSelection(int index) async {

    if(!isDisposed) {

      for(int i=0; i<numberOfQuestionSelection.length; i++) {

        if(i == index) {
          numberOfQuestionSelection[i] = true;
        }
        else {
          numberOfQuestionSelection[i] = false;
        }
      }

      notifyListeners();
    }
  }




  void getNumberOfQuestion() async {

    if(!isDisposed) {

      if(index != numberOfQuestionViewIndex) {

        numberOfQuestionID = await AnsweringChoiceRepository().getNumberOfQuestion();

        for(int i=0; i<Constants.numberOfQuestionsIdList.length; i++) {

          if(Constants.numberOfQuestionsIdList[i] == numberOfQuestionID) {

            numberOfQuestionSelection[i] = true;
            numberOfQuestion = Constants.numberOfQuestionsList[i];
            numberOfQuestionBangla = Constants.numberOfQuestionsBanglaList[i];
            break;
          }
        }
      }

      notifyListeners();
    }
  }



  void setQuestionTypeSelection(int index) async {

    if(!isDisposed) {

      for(int i=0; i<questionTypeSelection.length; i++) {

        if(i == index) {
          questionTypeSelection[i] = true;
        }
        else {
          questionTypeSelection[i] = false;
        }
      }

      notifyListeners();
    }
  }




  void getQuestionType() async {

    if(index != questionTypeViewIndex) {

      questionTypeID = await AnsweringChoiceRepository().getQuestionType();

      for(int i=0; i<Constants.questionTypeIdList.length; i++) {

        if(Constants.questionTypeIdList[i] == questionTypeID) {

          questionTypeSelection[i] = true;
          questionType = Constants.questionTypeList[i];
          questionTypeBangla = Constants.questionTypeBanglaList[i];
          break;
        }
      }
    }

    if(!isDisposed) {
      notifyListeners();
    }
  }



  Future<void> getQuestionAvailability(BuildContext context, List<bool> categorySelection, bool isEnglish) async {

    try {

      if(index != questionTypeViewIndex && questionTypeID != 0) {

        questionAvailability = await AnsweringChoiceRepository().isEnoughQuestionAvailable(categorySelection);

        if(questionAvailability.isAvailable) {

          switch (questionTypeID) {

            case 2:
              isValid = await AnsweringChoiceRepository().isChoiceValid(16, 0, categorySelection);

              if(!isValid) {

                infoMessage = AppLocalization.of(context).getTranslatedValue("no_incorrectly_answered_questions_info");
              }
              else {

                infoMessage = "";
              }

              break;

            case 3:
              isValid = await AnsweringChoiceRepository().isChoiceValid(15, 0, categorySelection);

              if(!isValid) {

                infoMessage = AppLocalization.of(context).getTranslatedValue("no_unseen_left_info");
              }
              else {

                infoMessage = "";
              }

              break;

            case 4:
              isValid = await AnsweringChoiceRepository().isChoiceValid(18, 1, categorySelection);

              if(!isValid) {

                infoMessage = AppLocalization.of(context).getTranslatedValue("no_favourite_questions_info");
              }
              else {

                infoMessage = "";
              }

              break;
          }

          if(!isValid) {

            topTitle = AppLocalization.of(context).getTranslatedValue("question_shuffle");
          }
          else {

            topTitle = "";
          }
        }
        else {

          topTitle = AppLocalization.of(context).getTranslatedValue("practise_info");

          String totalAmount = "";
          String choiceAmount = "";

          if(!isEnglish) {

            totalAmount = await _translateNumber(questionAvailability.totalAmount);
            choiceAmount = await _translateNumber(questionAvailability.choiceAmount);
          }
          else {

            totalAmount = questionAvailability.totalAmount.toString();
            choiceAmount = questionAvailability.choiceAmount.toString();
          }

          infoMessage = AppLocalization.of(context).getTranslatedValue("not_enough_questions_info1") + totalAmount +
              AppLocalization.of(context).getTranslatedValue("not_enough_questions_info2") + choiceAmount +
              AppLocalization.of(context).getTranslatedValue("not_enough_questions_info3");
        }
      }
    }
    catch(error) {

    }

    if(!isDisposed) {
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



  void checkViewIndex(AnsweringChoiceInterface answeringChoiceInterface) async {

    if(!isDisposed) {

      if(index == mainViewIndex) {
        answeringChoiceInterface.onBackPress();
      }
      else {
        index = mainViewIndex;
      }

      notifyListeners();
    }
  }




  void isChoiceChanged(int index, {AnsweringChoiceInterface answeringChoiceInterface}) async {

    if(!isDisposed) {

      switch (index) {

        case mainViewIndex:
          if(isChanged) {
            answeringChoiceInterface.onBackPress();
          }
          else {
            choiceValidation(answeringChoiceInterface);
          }
          break;

        case questionBankViewIndex:
          if(userTypeID != 0) {

            for(int i=0; i<userTypeSelection.length; i++) {

              if(userTypeSelection[i] && Constants.userTypeIdList[i] != userTypeID) {

                AnsweringChoiceRepository().setUserType(Constants.userTypeIdList[i]);
                isChanged = true;
                break;
              }
            }
          }

          if(countryCode != 0) {

            for(int i=0; i<countrySelection.length; i++) {

              if(countrySelection[i] && Constants.countryCodeList[i] != countryCode) {

                AnsweringChoiceRepository().setCountry(Constants.countryCodeList[i]);
                isChanged = true;
                break;
              }
            }
          }

          setIndex(mainViewIndex);
          break;


        case numberOfQuestionViewIndex:
          if(numberOfQuestionID != 0) {

            for(int i=0; i<numberOfQuestionSelection.length; i++) {

              if(numberOfQuestionSelection[i] && Constants.numberOfQuestionsIdList[i] != numberOfQuestionID) {

                AnsweringChoiceRepository().setNumberOfQuestion(Constants.numberOfQuestionsIdList[i]);
                setIndex(mainViewIndex);
                break;
              }
            }
          }
          break;


        case questionTypeViewIndex:
          if(questionTypeID != 0) {

            for(int i=0; i<questionTypeSelection.length; i++) {

              if(questionTypeSelection[i] && Constants.questionTypeIdList[i] != questionTypeID) {

                AnsweringChoiceRepository().setQuestionType(Constants.questionTypeIdList[i]);
                setIndex(mainViewIndex);
                break;
              }
            }
          }
          break;
      }

      notifyListeners();
    }
  }




  void choiceValidation(AnsweringChoiceInterface answeringChoiceInterface) async {

    if(!isDisposed) {

      if(questionAvailability.isAvailable) {

        if(isValid) {
          answeringChoiceInterface.onStartPress();
        }
        else {
          topIcon = Icons.info;
          bool shouldShow = await AnsweringChoiceRepository().shouldShowQuestionChoiceValidationAlert();

          shouldShow && (topTitle.isNotEmpty || infoMessage.isNotEmpty) ? setIndex(infoViewIndex) :
          answeringChoiceInterface.onStartPress();
        }
      }
      else {

        topIcon = Icons.info;
        bool shouldShow = await AnsweringChoiceRepository().shouldShowNotEnoughQuestionAlert();

        shouldShow && (topTitle.isNotEmpty || infoMessage.isNotEmpty) ? setIndex(infoViewIndex) :
        answeringChoiceInterface.onStartPress();
      }

      notifyListeners();
    }
  }




  void onDoNotShowPressed(AnsweringChoiceInterface answeringChoiceInterface) async {

    if(!isDisposed) {

      if(questionAvailability.isAvailable) {

        if(!isValid) {
          AnsweringChoiceRepository().setQuestionChoiceValidationAlertShow(false);
        }
      }
      else {
        AnsweringChoiceRepository().setNotEnoughQuestionAlertShow(false);
      }

      answeringChoiceInterface.onStartPress();
      notifyListeners();
    }
  }




  void resetModel() async {

    isDisposed = true;
    autoMoveToNext = false;
    isIncorrectAlertActive = false;
    isChanged = false;
    isValid = true;

    topIcon = Icons.refresh;

    for(int i=0; i<userTypeSelection.length; i++) {
      userTypeSelection[i] = false;
    }

    for(int i=0; i<countrySelection.length; i++) {
      countrySelection[i] = false;
    }

    for(int i=0; i<numberOfQuestionSelection.length; i++) {
      numberOfQuestionSelection[i] = false;
    }

    for(int i=0; i<questionTypeSelection.length; i++) {
      questionTypeSelection[i] = false;
    }

    userTypeID = 0;
    userType = "";
    countryCode = 0;
    countryShortForm = "";
    numberOfQuestionID = 0;
    numberOfQuestion = "";
    numberOfQuestionBangla = "";
    questionTypeID = 0;
    questionType = "";
    questionTypeBangla = "";
    index = 0;
    infoMessage = "";
    language = "";
    topTitle = "";

    questionAvailability = QuestionAvailability(false, 0, 0);

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
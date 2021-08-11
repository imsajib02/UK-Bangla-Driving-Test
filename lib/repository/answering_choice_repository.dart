import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/question_availability.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class AnsweringChoiceRepository {

  LocalMemory _localMemory = LocalMemory();
  DbHelper _dbHelper = DbHelper();


  Future<bool> getAutoMoveStatus() async {

    bool status = await _localMemory.getMoveToNextStatus();
    return status;
  }


  void setAutoMoveStatus(bool value) async {
    await _localMemory.setMoveToNextStatus(value);
  }


  Future<bool> getIncorrectAlertStatus() async {

    bool status = await _localMemory.getIncorrectAlertStatus();
    return status;
  }


  void setIncorrectAlertStatus(bool value) async {
    await _localMemory.setIncorrectAlertStatus(value);
  }


  void setUserType(int id) async {
    await _localMemory.setUserType(id);
  }


  Future<int> getUserType() async {

    int userTypeID = await _localMemory.getUserType();
    return userTypeID;
  }


  void setCountry(int code) async {
    await _localMemory.setCountry(code);
  }


  Future<int> getCountry() async {

    int countryCode = await _localMemory.getCountry();
    return countryCode;
  }


  void setNumberOfQuestion(int id) async {
    await _localMemory.setNumberOfQuestion(id);
  }


  Future<int> getNumberOfQuestion() async {

    int numberOfQuestionID = await _localMemory.getNumberOfQuestion();
    return numberOfQuestionID;
  }


  void setQuestionType(int id) async {
    await _localMemory.setTypeOfQuestion(id);
  }


  Future<int> getQuestionType() async {

    int questionTypeID = await _localMemory.getTypeOfQuestion();
    return questionTypeID;
  }


  Future<QuestionAvailability> isEnoughQuestionAvailable(List<bool> categorySelection) async {

    await _dbHelper.initDb();

    QuestionAvailability questionAvailability = await _dbHelper.isEnoughQuestionAvailable(categorySelection);
    return questionAvailability;
  }


  Future<bool> isChoiceValid(int columnIndex, int value, List<bool> categorySelection) async {

    await _dbHelper.initDb();

    bool isValid = await _dbHelper.isChoiceValid(columnIndex, value, categorySelection);
    return isValid;
  }


  Future<bool> shouldShowNotEnoughQuestionAlert() async {

    bool status = await _localMemory.shouldShowNotEnoughQuestionAlert();
    return status;
  }


  void setNotEnoughQuestionAlertShow(bool value) async {
    await _localMemory.setNotEnoughQuestionShow(value);
  }


  Future<bool> shouldShowQuestionChoiceValidationAlert() async {

    bool status = await _localMemory.shouldShowQuestionChoiceValidationAlert();
    return status;
  }


  void setQuestionChoiceValidationAlertShow(bool value) async {
    await _localMemory.setQuestionChoiceValidationShow(value);
  }
}
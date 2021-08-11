import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/performance.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class QuestionAnswerRepository {

  LocalMemory _localMemory = LocalMemory();
  DbHelper _dbHelper = DbHelper();



  Future<void> setQuestionAnswerLanguage(int id) async {
    await _localMemory.setQuestionAnswerLanguage(id);
  }


  Future<int> getQuestionAnswerLanguage() async {

    int languageID = await _localMemory.getQuestionAnswerLanguage();
    return languageID;
  }


  Future<TheoryTestQuestionList> getQuestions(List<bool> categorySelection) async {

    await _dbHelper.initDb();

    TheoryTestQuestionList testQuestionList = await _dbHelper.getPracticeQuestions(categorySelection);
    return testQuestionList;
  }


  Future<TheoryTestQuestionList> getAllQuestions() async {

    await _dbHelper.initDb();

    TheoryTestQuestionList testQuestionList = await _dbHelper.getAllQuestions();
    return testQuestionList;
  }


  Future<TheoryTestQuestionList> getMockQuestions() async {

    await _dbHelper.initDb();

    TheoryTestQuestionList testQuestionList = await _dbHelper.getMockQuestions();
    return testQuestionList;
  }


  Future<TheoryTestQuestionList> getFavQuestions() async {

    await _dbHelper.initDb();

    TheoryTestQuestionList testQuestionList = await _dbHelper.getFavQuestions();
    return testQuestionList;
  }


  Future<bool> getAutoMoveStatus() async {

    bool shouldAutoMove = await _localMemory.getMoveToNextStatus();
    return shouldAutoMove;
  }


  Future<bool> getIncorrectAlert() async {

    bool alertStatus = await _localMemory.getIncorrectAlertStatus();
    return alertStatus;
  }


  void setVoiceOverStatus(bool value) async {
    await _localMemory.setVoiceActivationStatus(value);
  }


  Future<bool> getVoiceOverStatus() async {

    bool isActivated = await _localMemory.getVoiceActivationStatus();
    return isActivated;
  }


  Future<void> setFavouriteStatus(TheoryQuestion question) async {

    await _dbHelper.initDb();
    await _dbHelper.saveFavouriteStatus(question);
  }


  Future<void> setFlagStatus(TheoryQuestion question) async {

    await _dbHelper.initDb();
    await _dbHelper.saveFlagStatus(question);
  }


  Future<void> saveTestResult(TheoryTestQuestionList testQuestionList, int type) async {

    await _dbHelper.initDb();

    for(int i=0; i<testQuestionList.list.length; i++) {
      await _dbHelper.saveTestResult(testQuestionList.list[i]);
    }

    Performance performance = Performance(testQuestionList: testQuestionList);

    await _dbHelper.saveTheoryTestPerformance(performance, type);
  }


  Future<PerformanceList> getTheoryTestPerformance() async {

    await _dbHelper.initDb();

    PerformanceList performanceList = await _dbHelper.getTheoryTestPerformance();
    return performanceList;
  }


  Future<void> resetTheoryTestPerformance() async {

    await _dbHelper.initDb();
    await _dbHelper.resetTheoryTestPerformance();
  }
}
import 'package:ukbangladrivingtest/model/theory_question.dart';


abstract class QuestionAnswerInterface {

  void addAnswers(TheoryQuestion theoryQuestion);
  void removeLastAnswer();
  void showFlaggedQuestionAlert();
  void showTestResult();
  void showRemainingTime(int remainingTime);
  void onClose();
}
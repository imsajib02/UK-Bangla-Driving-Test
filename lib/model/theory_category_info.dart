

class TheoryCategoryInfo {

  int id;
  int totalQuestions;
  String stringTotalQuestions;
  int questionsAnswered;
  String stringQuestionsAnswered;
  int correctlyAnswered;
  String stringCorrectlyAnswered;
  double answeringPercentage;
  double correctlyAnsweredPercentage;
  String stringCorrectlyAnsweredPercentage;

  TheoryCategoryInfo(this.id, this.questionsAnswered, this.correctlyAnswered, this.totalQuestions,
    this.answeringPercentage, this.correctlyAnsweredPercentage, this.stringTotalQuestions, this.stringQuestionsAnswered,
      this.stringCorrectlyAnswered, this.stringCorrectlyAnsweredPercentage);
}
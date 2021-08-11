import 'dart:typed_data';
import 'package:ukbangladrivingtest/database/dbhelper.dart';


class TheoryQuestion {

  int id;
  int categoryID;
  String question;
  String questionInBangla;
  String option1;
  String option1InBangla;
  String option2;
  String option2InBangla;
  String option3;
  String option3InBangla;
  String option4;
  String option4InBangla;
  String explanation;
  String explanationInBangla;
  String correctAnswer;
  int optionAnswered;
  bool isAnswered;
  bool isAnsweredCorrectly;
  bool isFlagged;
  bool isMarkedFavourite;
  bool isCorrectAnswerShown;
  int countryCode;
  int userTypeID;
  bool hasImage;
  Uint8List image;


  TheoryQuestion({this.id, this.categoryID, this.question, this.questionInBangla,
    this.option1, this.option1InBangla, this.option2, this.option2InBangla,
    this.option3, this.option3InBangla, this.option4, this.option4InBangla,
    this.explanation, this.explanationInBangla, this.correctAnswer, this.isAnswered,
    this.isAnsweredCorrectly, this.isFlagged, this.isMarkedFavourite,
    this.countryCode, this.userTypeID, this.optionAnswered, this.isCorrectAnswerShown, this.hasImage, this.image});


  TheoryQuestion.fromMap(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_QUESTIONS_COLUMNS[0]];
    categoryID =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_QUESTIONS_COLUMNS[1]];
    question =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[2]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[2]];
    questionInBangla =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[3]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[3]];
    option1 =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[4]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[4]];
    option1InBangla =  json[DbHelper.TABLE_QUESTIONS_COLUMNS[5]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[5]];
    option2 = json[DbHelper.TABLE_QUESTIONS_COLUMNS[6]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[6]];
    option2InBangla = json[DbHelper.TABLE_QUESTIONS_COLUMNS[7]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[7]];
    option3 = json[DbHelper.TABLE_QUESTIONS_COLUMNS[8]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[8]];
    option3InBangla = json[DbHelper.TABLE_QUESTIONS_COLUMNS[9]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[9]];
    option4 = json[DbHelper.TABLE_QUESTIONS_COLUMNS[10]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[10]];
    option4InBangla = json[DbHelper.TABLE_QUESTIONS_COLUMNS[11]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[11]];
    explanation = json[DbHelper.TABLE_QUESTIONS_COLUMNS[12]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[12]];
    explanationInBangla = json[DbHelper.TABLE_QUESTIONS_COLUMNS[13]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[13]];
    correctAnswer = json[DbHelper.TABLE_QUESTIONS_COLUMNS[14]] == null ? "" : json[DbHelper.TABLE_QUESTIONS_COLUMNS[14]];
    isAnswered = json[DbHelper.TABLE_QUESTIONS_COLUMNS[15]] == null ? false : (json[DbHelper.TABLE_QUESTIONS_COLUMNS[15]] == 1 ? true : false);
    isAnsweredCorrectly = json[DbHelper.TABLE_QUESTIONS_COLUMNS[16]] != null && json[DbHelper.TABLE_QUESTIONS_COLUMNS[16]] == 1 ? true : false;
    isFlagged = json[DbHelper.TABLE_QUESTIONS_COLUMNS[17]] == null ? false : (json[DbHelper.TABLE_QUESTIONS_COLUMNS[17]] == 1 ? true : false);
    isMarkedFavourite = json[DbHelper.TABLE_QUESTIONS_COLUMNS[18]] == null ? false : (json[DbHelper.TABLE_QUESTIONS_COLUMNS[18]] == 1 ? true : false);
    countryCode = json[DbHelper.TABLE_QUESTIONS_COLUMNS[19]] == null ? 0 : json[DbHelper.TABLE_QUESTIONS_COLUMNS[19]];
    userTypeID = json[DbHelper.TABLE_QUESTIONS_COLUMNS[20]] == null ? 0 : json[DbHelper.TABLE_QUESTIONS_COLUMNS[20]];
    hasImage = json[DbHelper.TABLE_QUESTIONS_COLUMNS[21]] == null ? false : (json[DbHelper.TABLE_QUESTIONS_COLUMNS[21]] == 0 ? false : true);

    if(hasImage) {
      image = json[DbHelper.TABLE_QUESTIONS_COLUMNS[22]];
    }

    isCorrectAnswerShown = false;
    optionAnswered = 0;
  }


  toMap() {

    return {
    DbHelper.TABLE_QUESTIONS_COLUMNS[1] : categoryID == null ? 0 : categoryID,
    DbHelper.TABLE_QUESTIONS_COLUMNS[2] : question == null ? "" : question,
    DbHelper.TABLE_QUESTIONS_COLUMNS[3] : questionInBangla == null ? "" : questionInBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[4] : option1 == null ? "" : option1,
    DbHelper.TABLE_QUESTIONS_COLUMNS[5] : option1InBangla == null ? "" : option1InBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[6] : option2 == null ? "" : option2,
    DbHelper.TABLE_QUESTIONS_COLUMNS[7] : option2InBangla == null ? "" : option2InBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[8] : option3 == null ? "" : option3,
    DbHelper.TABLE_QUESTIONS_COLUMNS[9] : option3InBangla == null ? "" : option3InBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[10] : option4 == null ? "" : option4,
    DbHelper.TABLE_QUESTIONS_COLUMNS[11] : option4InBangla == null ? "" : option4InBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[12] : explanation == null ? "" : explanation,
    DbHelper.TABLE_QUESTIONS_COLUMNS[13] : explanationInBangla == null ? "" : explanationInBangla,
    DbHelper.TABLE_QUESTIONS_COLUMNS[14] : correctAnswer == null ? "" : correctAnswer,
    DbHelper.TABLE_QUESTIONS_COLUMNS[15] : isAnswered == null ? 0 : (isAnswered == true ? 1 : 0),
    DbHelper.TABLE_QUESTIONS_COLUMNS[16] : isAnsweredCorrectly == null ? null : (isAnsweredCorrectly == true ? 1 : 0),
    DbHelper.TABLE_QUESTIONS_COLUMNS[17] : isFlagged == null ? 0 : (isFlagged == true ? 1 : 0),
    DbHelper.TABLE_QUESTIONS_COLUMNS[18] : isMarkedFavourite == null ? 0 : (isMarkedFavourite == true ? 1 : 0),
    DbHelper.TABLE_QUESTIONS_COLUMNS[19] : countryCode == null ? 0 : countryCode,
    DbHelper.TABLE_QUESTIONS_COLUMNS[20] : userTypeID == null ? 0 : userTypeID
    };
  }


  testResult() {

    return {
      DbHelper.TABLE_QUESTIONS_COLUMNS[15] : isAnswered == null ? 0 : (isAnswered ? 1 : 0),
      DbHelper.TABLE_QUESTIONS_COLUMNS[16] : isAnsweredCorrectly == null ? null : (isAnsweredCorrectly ? 1 : 0),
      DbHelper.TABLE_QUESTIONS_COLUMNS[18] : isMarkedFavourite == null ? 0 : (isMarkedFavourite ? 1 : 0)
    };
  }


  favStatus() {

    return {
      DbHelper.TABLE_QUESTIONS_COLUMNS[18] : isMarkedFavourite == null ? 0 : (isMarkedFavourite ? 1 : 0)
    };
  }


  flagStatus() {

    return {
      DbHelper.TABLE_QUESTIONS_COLUMNS[17] : isFlagged == null ? 0 : (isFlagged ? 1 : 0)
    };
  }
}


class TheoryTestQuestionList {

  List<TheoryQuestion> list;

  TheoryTestQuestionList({this.list});

  TheoryTestQuestionList.fromMap(List<Map> maps) {

    list = List();

    if(maps != null) {

      maps.forEach((question) {
        list.add(TheoryQuestion.fromMap(question));
      });
    }
  }
}
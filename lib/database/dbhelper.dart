import 'dart:math';

import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/model/hazard_video.dart';
import 'package:ukbangladrivingtest/model/highway_code.dart';
import 'package:ukbangladrivingtest/model/performance.dart';
import 'package:ukbangladrivingtest/model/question_availability.dart';
import 'package:ukbangladrivingtest/model/road_sign_category_description.dart';
import 'package:ukbangladrivingtest/model/theory_category_info.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';


class DbHelper {

  Database database;

  final String DATABASE_NAME = "DrivingTest.db";

  final String TABLE_QUESTIONS = "Questions";
  final String TABLE_PERFORMANCE = "Performance";
  final String TABLE_HIGHWAY_CODE = "HighWayCode";
  final String TABLE_ROAD_SIGN = "RoadSign";
  final String TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION = "RoadSignCategoryDescription";
  final String TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION = "RoadSignSubCategoryDescription";
  final String TABLE_HAZARD_CLIPS = "HazardClips";

  final int DB_VERSION = 1;

  LocalMemory _localMemory = LocalMemory();

  int _userTypeID = 0;
  int _countryCode = 0;
  int _numberOfQuestionID = 0;
  int _questionTypeID = 0;


  static final List<String> TABLE_QUESTIONS_COLUMNS = <String> ['ID', 'CategoryID', 'Question', 'QuestionBangla', 'Option1', 'Option1Bangla', 'Option2', 'Option2Bangla',
    'Option3', 'Option3Bangla', 'Option4', 'Option4Bangla', 'Explanation', 'ExplanationBangla', 'CorrectAnswer', 'IsAnswered', 'IsCorrectlyAnswered', 'IsFlagged',
    'IsMarkedFavourite', 'CountryCode', 'UserTypeId', 'HasImage', 'Image'];

  static final List<String> TABLE_PERFORMANCE_COLUMNS = <String> ['ID', 'Type', 'Data'];

  static final List<String> TABLE_HIGHWAY_CODE_COLUMNS = <String> ['ID', 'CategoryID', 'SubCategoryID', 'Content', 'ContentBangla', 'Law', 'LawBangla', 'HasImage',
    'Image', 'Rule', 'RuleBangla'];

  static final List<String> TABLE_ROAD_SIGN_COLUMNS = <String> ['ID', 'CategoryID', 'SubCategoryID', 'Image', 'StartContent', 'StartContentBangla', 'EndContent',
    'EndContentBangla', 'IsMarkedFavourite', 'WhatToDo'];

  static final List<String> TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS = <String> ['ID', 'CategoryID', 'Description', 'DescriptionBangla'];

  static final List<String> TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS = <String> ['ID', 'CategoryID', 'SubCategoryID', 'Description', 'DescriptionBangla'];

  static final List<String> TABLE_HAZARD_CLIPS_COLUMNS = <String> ['ID', 'Data', 'Score'];



  Future initDb() async {

    final dirPath = await getDatabasesPath();
    final dbPath = join(dirPath, DATABASE_NAME);

    final available = await databaseExists(dbPath);


    if(!available) {

      try {
        await Directory(dirname(dbPath)).create(recursive: true);
      }
      catch (_) {}


      ByteData data = await rootBundle.load(join("assets/db/", DATABASE_NAME));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    database = await openDatabase(dbPath, version: DB_VERSION, onConfigure: _onConfigure);
  }



  _onConfigure(Database db) async {
    await db.rawQuery("PRAGMA journal_mode = PERSIST");
  }




  Future<int> getNumberOfTheoryTestQuestions() async {

    List<Map> records = List();

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();

      records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
          whereArgs: [_countryCode, _userTypeID]);

      print("questonsssssssssssss   " + records.length.toString());

      return records.length;
    });

    return records.length;
  }




  Future<List<TheoryCategoryInfo>> getCategoryWiseNumberOfTheoryTestQuestions() async {

    List<TheoryCategoryInfo> categoryInfoList = List();

    TheoryCategoryInfo allCategoryInfo = TheoryCategoryInfo(0, 0, 0, 0, 0.0, 0.0, "০", "০", "০", "০");

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();

      for(int i=1; i<Constants.categories.length; i++) {

        TheoryCategoryInfo theoryCategoryInfo = TheoryCategoryInfo(i, 0, 0, 0, 0.0, 0.0, "০", "০", "০", "০");

        List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[1] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
            whereArgs: [i, _countryCode, _userTypeID]);


        theoryCategoryInfo.totalQuestions = records.length;
        theoryCategoryInfo.stringTotalQuestions = await _translateNumber(theoryCategoryInfo.totalQuestions.toString());

        records.forEach((record) {

          TheoryQuestion theoryQuestion = TheoryQuestion.fromMap(record);

          if(theoryQuestion.isAnswered) {
            theoryCategoryInfo.questionsAnswered = theoryCategoryInfo.questionsAnswered + 1;
          }

          if(theoryQuestion.isAnsweredCorrectly != null && theoryQuestion.isAnsweredCorrectly) {
            theoryCategoryInfo.correctlyAnswered = theoryCategoryInfo.correctlyAnswered + 1;
          }
        });


        theoryCategoryInfo.stringQuestionsAnswered = await _translateNumber(theoryCategoryInfo.questionsAnswered.toString());
        theoryCategoryInfo.stringCorrectlyAnswered = await _translateNumber(theoryCategoryInfo.correctlyAnswered.toString());


        if(theoryCategoryInfo.questionsAnswered > 0 && theoryCategoryInfo.totalQuestions > 0) {

          theoryCategoryInfo.answeringPercentage = double.tryParse((theoryCategoryInfo.questionsAnswered / theoryCategoryInfo.totalQuestions).toStringAsFixed(2));
        }

        if(theoryCategoryInfo.correctlyAnswered > 0 && theoryCategoryInfo.totalQuestions > 0) {

          theoryCategoryInfo.correctlyAnsweredPercentage = double.tryParse(((100 * theoryCategoryInfo.correctlyAnswered) / theoryCategoryInfo.totalQuestions).toStringAsFixed(2));
          theoryCategoryInfo.stringCorrectlyAnsweredPercentage = await _translateNumber(theoryCategoryInfo.correctlyAnsweredPercentage.round().toString());
        }


        categoryInfoList.add(theoryCategoryInfo);

        allCategoryInfo.totalQuestions += theoryCategoryInfo.totalQuestions;
        allCategoryInfo.questionsAnswered += theoryCategoryInfo.questionsAnswered;
        allCategoryInfo.correctlyAnswered += theoryCategoryInfo.correctlyAnswered;
      }

      allCategoryInfo.stringTotalQuestions = await _translateNumber(allCategoryInfo.totalQuestions.toString());
      allCategoryInfo.stringQuestionsAnswered = await _translateNumber(allCategoryInfo.questionsAnswered.toString());
      allCategoryInfo.stringCorrectlyAnswered = await _translateNumber(allCategoryInfo.correctlyAnswered.toString());

      if(allCategoryInfo.questionsAnswered > 0 && allCategoryInfo.totalQuestions > 0) {

        allCategoryInfo.answeringPercentage = double.tryParse((allCategoryInfo.questionsAnswered / allCategoryInfo.totalQuestions).toStringAsFixed(2));
      }

      if(allCategoryInfo.correctlyAnswered > 0 && allCategoryInfo.totalQuestions > 0) {

        allCategoryInfo.correctlyAnsweredPercentage = double.tryParse(((100 * allCategoryInfo.correctlyAnswered) / allCategoryInfo.totalQuestions).toStringAsFixed(2));
        allCategoryInfo.stringCorrectlyAnsweredPercentage = await _translateNumber(allCategoryInfo.correctlyAnsweredPercentage.round().toString());
      }

      categoryInfoList.insert(0, allCategoryInfo);

      return categoryInfoList;
    });

    return categoryInfoList;
  }




  Future<String> _translateNumber(String number) async {

    String inBangla = "";

    for(int i=0; i<number.length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number[i] == ".") {

          inBangla = inBangla + ".";
          break;
        }
        else if(number[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }





  Future<QuestionAvailability> isEnoughQuestionAvailable(List<bool> categorySelection) async {

    QuestionAvailability questionAvailability = QuestionAvailability(false, 0, 0);

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();
      _numberOfQuestionID = await _localMemory.getNumberOfQuestion();

      for(int i=0; i<categorySelection.length; i++) {

        if(i == 0 && categorySelection[i]) {

          List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
              whereArgs: [_countryCode, _userTypeID]);

          questionAvailability.totalAmount = records.length;
          break;
        }
        else if(i != 0 && categorySelection[i]) {

          List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[1] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
              whereArgs: [i, _countryCode, _userTypeID]);

          questionAvailability.totalAmount = questionAvailability.totalAmount + records.length;
        }
      }

      if(_numberOfQuestionID != Constants.numberOfQuestionsIdList[Constants.numberOfQuestionsIdList.length-1]) {

        if(questionAvailability.totalAmount >= _numberOfQuestionID * 10) {

          questionAvailability.isAvailable = true;
          return questionAvailability;
        }
        else {

          questionAvailability.isAvailable = false;
          questionAvailability.choiceAmount = _numberOfQuestionID * 10;
          return questionAvailability;
        }
      }
      else {
        questionAvailability.isAvailable = true;
        return questionAvailability;
      }
    });

    return questionAvailability;
  }





  Future<bool> isChoiceValid(int columnIndex, int value, List<bool> categorySelection) async {

    bool isValid = false;
    int questions = 0;

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();
      _numberOfQuestionID = await _localMemory.getNumberOfQuestion();

      for(int i=0; i<categorySelection.length; i++) {

        if(i == 0 && categorySelection[i]) {

          List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ? and ' +
              TABLE_QUESTIONS_COLUMNS[columnIndex] + ' = ?', whereArgs: [_countryCode, _userTypeID, value]);

          questions = records.length;
          break;
        }
        else if(i != 0 && categorySelection[i]) {

          List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[1] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' +
              TABLE_QUESTIONS_COLUMNS[20] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[columnIndex] + ' = ?', whereArgs: [i, _countryCode, _userTypeID, value]);

          questions = questions + records.length;
        }
      }

      if(_numberOfQuestionID != Constants.numberOfQuestionsIdList[Constants.numberOfQuestionsIdList.length-1]) {
        isValid = questions >= _numberOfQuestionID * 10;
      }
      else {
        isValid = questions >= 10;
      }
    });

    return isValid;
  }





  Future<TheoryTestQuestionList> getPracticeQuestions(List<bool> categorySelection) async {

    TheoryTestQuestionList allQuestionList = TheoryTestQuestionList(list: List());
    TheoryTestQuestionList testQuestionList = TheoryTestQuestionList(list: List());
    TheoryTestQuestionList listToShow = TheoryTestQuestionList(list: List());

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();
      _numberOfQuestionID = await _localMemory.getNumberOfQuestion();
      _questionTypeID = await _localMemory.getTypeOfQuestion();


      //getting all question filtered by countryCode and userType
      List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
          whereArgs: [_countryCode, _userTypeID]);

      if(records.length > 0) {
        allQuestionList = TheoryTestQuestionList.fromMap(records);
      }



      for(int i=0; i<categorySelection.length; i++) {

        //getting all category question
        if(i == 0 && categorySelection[i]) {

          testQuestionList.list = testQuestionList.list + allQuestionList.list;
          break;
        }
        //getting selected category question
        else if(i != 0 && categorySelection[i]) {

          for(int j=0; j<allQuestionList.list.length; j++) {

            if(allQuestionList.list[j].categoryID == i) {

              testQuestionList.list.add(allQuestionList.list[j]);
            }
          }
        }
      }


      listToShow.list = listToShow.list + testQuestionList.list;


      //getting non answered questions
      if(_questionTypeID == Constants.questionTypeIdList[0] || _questionTypeID == Constants.questionTypeIdList[2]) {

        List<int> answeredList = List();

        for(int i=0; i<listToShow.list.length; i++) {

          if(listToShow.list[i].isAnswered) {
            answeredList.add(i);
          }
        }

        if(answeredList.length > 0) {

          for(int i=answeredList.length-1; i>=0 ; i--) {
            listToShow.list.removeAt(answeredList[i]);
          }
        }
      }
      //getting not correctly answered questions
      else if(_questionTypeID == Constants.questionTypeIdList[1]) {

        List<int> correctlyAnsweredList = List();

        for(int i=0; i<listToShow.list.length; i++) {

          if(listToShow.list[i].isAnswered && listToShow.list[i].isAnsweredCorrectly) {
            correctlyAnsweredList.add(i);
          }
        }

        if(correctlyAnsweredList.length > 0) {

          for(int i=correctlyAnsweredList.length-1; i>=0; i--) {
            listToShow.list.removeAt(correctlyAnsweredList[i]);
          }
        }
      }
      //getting marked favourite questions
      else if(_questionTypeID == Constants.questionTypeIdList[3]) {

        List<int> notFavList = List();

        for(int i=0; i<listToShow.list.length; i++) {

          if(!listToShow.list[i].isMarkedFavourite) {
            notFavList.add(i);
          }
        }

        if(notFavList.length > 0) {

          for(int i=notFavList.length-1; i>=0; i--) {
            listToShow.list.removeAt(notFavList[i]);
          }
        }
      }


      bool needToAddRandomQuestion = false;
      bool addFromAll = false;
      bool addFromCategory = false;
      int questionToAdd = 0;


      //when need to show 10 or 20 or 30 or 40 or 50 questions
      if(_numberOfQuestionID != Constants.numberOfQuestionsIdList[Constants.numberOfQuestionsIdList.length-1]) {

        if(testQuestionList.list.length < _numberOfQuestionID * 10) {

          if(listToShow.list.length < _numberOfQuestionID * 10) {

            listToShow.list.clear();
            listToShow.list = listToShow.list + testQuestionList.list;

            needToAddRandomQuestion = false;
          }
          else {

            for(int i = listToShow.list.length-1; i >= _numberOfQuestionID * 10; i--) {

              listToShow.list.removeLast();
            }

            needToAddRandomQuestion = false;
          }
        }
        else {

          if(listToShow.list.length < _numberOfQuestionID * 10) {

            questionToAdd = (_numberOfQuestionID * 10) - listToShow.list.length;

            if(questionToAdd <= (testQuestionList.list.length - listToShow.list.length)) {

              addFromCategory = true;
            }
            else {

              addFromAll = true;
            }

            needToAddRandomQuestion = true;
          }
          else if(listToShow.list.length > _numberOfQuestionID * 10) {

            for(int i = listToShow.list.length-1; i >= _numberOfQuestionID * 10; i--) {

              listToShow.list.removeLast();
            }

            needToAddRandomQuestion = false;
          }
        }
      }
      //when need to show all questions
      else {

        if(listToShow.list.length < 10) {

          listToShow.list.clear();
          listToShow.list = listToShow.list + testQuestionList.list;

          needToAddRandomQuestion = false;
        }
      }


      if(needToAddRandomQuestion) {

        List<int> notShowingIndexList = List();

        if(addFromAll) {

          for(int i=0; i<allQuestionList.list.length; i++) {

            bool matched = false;

            for(int j=0; j<listToShow.list.length; j++) {

              if(allQuestionList.list[i].id == listToShow.list[j].id) {
                matched = true;
                break;
              }
            }

            if(!matched) {
              notShowingIndexList.add(i);
            }
          }
        }
        else if(addFromCategory) {

          for(int i=0; i<testQuestionList.list.length; i++) {

            bool matched = false;

            for(int j=0; j<listToShow.list.length; j++) {

              if(testQuestionList.list[i].id == listToShow.list[j].id) {
                matched = true;
                break;
              }
            }

            if(!matched) {
              notShowingIndexList.add(i);
            }
          }
        }

        Set<int> indexes = Set();

        Random random = Random();

        if(notShowingIndexList.length > 0) {

          while (indexes.length < questionToAdd) {
            indexes.add(random.nextInt(notShowingIndexList.length));
          }
        }

        if(addFromAll) {

          for(int i=0; i<indexes.length; i++) {
            listToShow.list.add(allQuestionList.list[notShowingIndexList[indexes.elementAt(i)]]);
          }
        }
        else if(addFromCategory) {

          for(int i=0; i<indexes.length; i++) {
            listToShow.list.add(testQuestionList.list[notShowingIndexList[indexes.elementAt(i)]]);
          }
        }
      }
    });


    return listToShow;
  }





  Future<int> saveTestResult(TheoryQuestion theoryQuestion) async {

    await database.transaction((txn) async {

      int id =  await txn.update(TABLE_QUESTIONS, theoryQuestion.testResult(), where: TABLE_QUESTIONS_COLUMNS[0] + ' = ?', whereArgs: [theoryQuestion.id]);
      return id;
    });

    return 0;
  }




  Future<int> saveFavouriteStatus(TheoryQuestion theoryQuestion) async {

    await database.transaction((txn) async {

      int id =  await txn.update(TABLE_QUESTIONS, theoryQuestion.favStatus(), where: TABLE_QUESTIONS_COLUMNS[0] + ' = ?', whereArgs: [theoryQuestion.id]);
      return id;
    });

    return 0;
  }




  Future<int> saveFlagStatus(TheoryQuestion theoryQuestion) async {

    await database.transaction((txn) async {

      int id =  await txn.update(TABLE_QUESTIONS, theoryQuestion.flagStatus(), where: TABLE_QUESTIONS_COLUMNS[0] + ' = ?', whereArgs: [theoryQuestion.id]);
      return id;
    });

    return 0;
  }




  Future<int> saveTheoryTestPerformance(Performance performance, int type) async {

    await database.transaction((txn) async {

      return await txn.insert(TABLE_PERFORMANCE, performance.toMap(type));
    });

    return 0;
  }




  Future<PerformanceList> getTheoryTestPerformance() async {

    PerformanceList performanceList = PerformanceList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_PERFORMANCE);

      performanceList.list = List();

      if(records.length > 0) {
        performanceList = PerformanceList.fromMap(records);
      }
    });

    return performanceList;
  }




  Future<void> resetTheoryTestPerformance() async {

    await database.transaction((txn) async {

      await txn.delete(TABLE_PERFORMANCE);
    });
  }





  Future<TheoryTestQuestionList> getAllQuestions() async {

    TheoryTestQuestionList testQuestionList = TheoryTestQuestionList();

    await database.transaction((txn) async {

      _countryCode = await _localMemory.getCountry();
      _userTypeID = await _localMemory.getUserType();

      List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[19] + ' = ? and ' + TABLE_QUESTIONS_COLUMNS[20] + ' = ?',
          whereArgs: [_countryCode, _userTypeID]);

      testQuestionList.list = List();

      if(records.length > 0) {
        testQuestionList = TheoryTestQuestionList.fromMap(records);
      }
    });


    return testQuestionList;
  }





  Future<TheoryTestQuestionList> getMockQuestions() async {

    TheoryTestQuestionList testQuestionList = TheoryTestQuestionList(list: List());
    TheoryTestQuestionList listToReturn = TheoryTestQuestionList(list: List());

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_QUESTIONS);

      if(records.length > 0) {
        testQuestionList = TheoryTestQuestionList.fromMap(records);
      }
    });


    Set<int> indexes = Set();

    Random random = Random();

    while (indexes.length < 50) {
      indexes.add(random.nextInt(testQuestionList.list.length));
    }


    for(int i=0; i<indexes.length; i++) {
      testQuestionList.list[indexes.elementAt(i)].isAnswered = false;
      testQuestionList.list[indexes.elementAt(i)].isAnsweredCorrectly = false;
      testQuestionList.list[indexes.elementAt(i)].optionAnswered = 0;
      listToReturn.list.add(testQuestionList.list[indexes.elementAt(i)]);
    }


    return listToReturn;
  }





  Future<TheoryTestQuestionList> getFavQuestions() async {

    TheoryTestQuestionList testQuestionList = TheoryTestQuestionList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_QUESTIONS, where: TABLE_QUESTIONS_COLUMNS[18] + ' = ?', whereArgs: [1]);

      testQuestionList.list = List();

      if(records.length > 0) {
        testQuestionList = TheoryTestQuestionList.fromMap(records);
      }
    });


    return testQuestionList;
  }




  Future<HighWayCodeList> getHighwayCategoryData(int categoryID) async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_HIGHWAY_CODE, where: TABLE_HIGHWAY_CODE_COLUMNS[1] + ' = ?', whereArgs: [categoryID]);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromMap(records);
      }
    });

    return highWayCodeList;
  }




  Future<HighWayCodeList> getHighwaySubCategoryData(int categoryID, int subCategoryID) async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_HIGHWAY_CODE, where: TABLE_HIGHWAY_CODE_COLUMNS[1] + ' = ? and ' + TABLE_HIGHWAY_CODE_COLUMNS[2] + ' = ?', whereArgs: [categoryID, subCategoryID]);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromMap(records);
      }
    });

    return highWayCodeList;
  }




  Future<HighWayCodeList> getRoadSignCategoryData(int categoryID) async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN, where: TABLE_ROAD_SIGN_COLUMNS[1] + ' = ?', whereArgs: [categoryID]);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromRoadSign(records);
      }
    });

    return highWayCodeList;
  }




  Future<RoadSignDescription> getRoadSignCategoryDescription(int categoryID) async {

    RoadSignDescription categoryDescription = RoadSignDescription();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION, where: TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[1] + ' = ?', whereArgs: [categoryID]);

      if(records.length > 0) {
        categoryDescription = RoadSignDescription.fromCategoryDescription(records.first);
      }
    });

    return categoryDescription;
  }




  Future<HighWayCodeList> getRoadSignSubCategoryData(int categoryID, int subCategoryID) async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN, where: TABLE_ROAD_SIGN_COLUMNS[1] + ' = ? and ' + TABLE_ROAD_SIGN_COLUMNS[2] + ' = ?', whereArgs: [categoryID, subCategoryID]);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromRoadSign(records);
      }
    });

    return highWayCodeList;
  }




  Future<RoadSignDescription> getRoadSignSubCategoryDescription(int categoryID, int subCategoryID) async {

    RoadSignDescription subCategoryDescription = RoadSignDescription();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION, where: TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[1] + ' = ? and ' +
          TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[2] + ' = ?', whereArgs: [categoryID, subCategoryID]);

      if(records.length > 0) {
        subCategoryDescription = RoadSignDescription.fromSubCategoryDescription(records.first);
      }
    });

    return subCategoryDescription;
  }





  Future<HighWayCodeList> getAllRoadSignData() async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromRoadSign(records);
      }
    });

    return highWayCodeList;
  }





  Future<HighWayCodeList> getFavRoadSignData() async {

    HighWayCodeList highWayCodeList = HighWayCodeList();

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_ROAD_SIGN, where: TABLE_ROAD_SIGN_COLUMNS[8] + ' = ?', whereArgs: [1]);

      highWayCodeList.list = List();

      if(records.length > 0) {
        highWayCodeList = HighWayCodeList.fromRoadSign(records);
      }
    });

    return highWayCodeList;
  }





  Future<int> saveRoadSignFavouriteStatus(HighWayCode highWayCode) async {

    await database.transaction((txn) async {

      int id = await txn.update(TABLE_ROAD_SIGN, highWayCode.favStatus(), where: TABLE_ROAD_SIGN_COLUMNS[0] + ' = ?', whereArgs: [highWayCode.id]);
      return id;
    });

    return 0;
  }




  Future<int> saveHazardClipDetails(String data) async {

    int id = 0;

    Map<String, dynamic> map = Map();
    map[TABLE_HAZARD_CLIPS_COLUMNS[1]] = data;

    await database.transaction((txn) async {

      id = await txn.insert(TABLE_HAZARD_CLIPS, map);
    });

    return id;
  }




  Future<HazardClips> getHazardClipDetails() async {

    HazardClips hazardClips = HazardClips(clipList: List());

    await database.transaction((txn) async {

      List<Map> records = await txn.query(TABLE_HAZARD_CLIPS);

      if(records.length > 0) {

        hazardClips = HazardClips.fromDb(records);
      }
    });

    return hazardClips;
  }




  Future<int> saveHazardClipScore(HazardClip clip) async {

    int id = 0;

    await database.transaction((txn) async {

      id = await txn.update(TABLE_HAZARD_CLIPS, clip.setScore(), where: TABLE_HAZARD_CLIPS_COLUMNS[0] + ' = ?', whereArgs: [clip.id]);
    });

    return id;
  }





  Future close() async {

    if(database != null && database.isOpen) {
      database.close();
    }
  }
}
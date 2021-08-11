import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/theory_category_info.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class QuestionCategorySelectionRepository {

  DbHelper _dbHelper = DbHelper();


  Future<int> getTotalNumberOfQuestions() async {

    await _dbHelper.initDb();

    int totalNumber = await _dbHelper.getNumberOfTheoryTestQuestions();
    return totalNumber;
  }


  Future<List<TheoryCategoryInfo>> getCategoryWiseNumberOfQuestions() async {

    await _dbHelper.initDb();

    List<TheoryCategoryInfo> categoryInfoList = await _dbHelper.getCategoryWiseNumberOfTheoryTestQuestions();
    return categoryInfoList;
  }


  Future<void> closeDb() async {
    await _dbHelper.close();
  }
}
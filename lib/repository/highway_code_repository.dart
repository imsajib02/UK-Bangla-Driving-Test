import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/highway_code.dart';
import 'package:ukbangladrivingtest/model/performance.dart';
import 'package:ukbangladrivingtest/model/road_sign_category_description.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class HighwayCodeRepository {

  DbHelper _dbHelper = DbHelper();


  Future<HighWayCodeList> getHighwayCategoryData(int categoryID) async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getHighwayCategoryData(categoryID);
    return highWayCodeList;
  }


  Future<HighWayCodeList> getHighwaySubCategoryData(int categoryID, int subCategoryID) async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getHighwaySubCategoryData(categoryID, subCategoryID);
    return highWayCodeList;
  }


  Future<HighWayCodeList> getRoadSignCategoryData(int categoryID) async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getRoadSignCategoryData(categoryID);
    return highWayCodeList;
  }


  Future<RoadSignDescription> getRoadSignCategoryDescription(int categoryID) async {

    await _dbHelper.initDb();

    RoadSignDescription categoryDescription = await _dbHelper.getRoadSignCategoryDescription(categoryID);
    return categoryDescription;
  }


  Future<HighWayCodeList> getRoadSignSubCategoryData(int categoryID, int subCategoryID) async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getRoadSignSubCategoryData(categoryID, subCategoryID);
    return highWayCodeList;
  }


  Future<RoadSignDescription> getRoadSignSubCategoryDescription(int categoryID, int subCategoryID) async {

    await _dbHelper.initDb();

    RoadSignDescription subCategoryDescription = await _dbHelper.getRoadSignSubCategoryDescription(categoryID, subCategoryID);
    return subCategoryDescription;
  }


  Future<HighWayCodeList> getAllRoadSignData() async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getAllRoadSignData();
    return highWayCodeList;
  }


  Future<void> setFavouriteStatus(HighWayCode highWayCode) async {

    await _dbHelper.initDb();
    await _dbHelper.saveRoadSignFavouriteStatus(highWayCode);
  }


  Future<HighWayCodeList> getFavRoadSignData() async {

    await _dbHelper.initDb();

    HighWayCodeList highWayCodeList = await _dbHelper.getFavRoadSignData();
    return highWayCodeList;
  }
}
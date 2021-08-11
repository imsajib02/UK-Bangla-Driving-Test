import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/hazard_video.dart';
import 'package:ukbangladrivingtest/model/question_availability.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';


class HazardPerceptionRepository {

  LocalMemory _localMemory = LocalMemory();
  DbHelper _dbHelper = DbHelper();


  Future<int> getQuestionType() async {

    int questionTypeID = await _localMemory.getTypeOfQuestion();
    return questionTypeID;
  }


  Future<HazardClips> getHazardClipDetails() async {

    await _dbHelper.initDb();

    HazardClips hazardClips = await _dbHelper.getHazardClipDetails();
    return hazardClips;
  }


  Future<int> saveHazardClipDetails(String data) async {

    await _dbHelper.initDb();
    int id = await _dbHelper.saveHazardClipDetails(data);
    return id;
  }


  Future<int> saveHazardClipScore(HazardClip clip) async {

    await _dbHelper.initDb();
    int id = await _dbHelper.saveHazardClipScore(clip);
    return id;
  }
}
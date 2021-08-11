import 'dart:typed_data';
import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';


class HighWayCode {

  int id;
  String idBangla;
  int categoryID;
  int subCategoryID;
  String content;
  String contentBangla;
  String endContent;
  String endContentBangla;
  String law;
  String lawBangla;
  bool hasImage;
  Uint8List image;
  String rule;
  String ruleBangla;
  bool isMarkedFavourite;


  HighWayCode({this.id, this.idBangla, this.categoryID, this.subCategoryID, this.content,
    this.contentBangla, this.endContent, this.endContentBangla, this.law,
    this.lawBangla, this.hasImage, this.image, this.rule, this.ruleBangla, this.isMarkedFavourite});



  HighWayCode.fromMap(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[0]];

    idBangla = _translateNumber(id);

    categoryID =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[1]];
    subCategoryID =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[2]] == null ? 0 : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[2]];
    content =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[3]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[3]];
    contentBangla =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[4]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[4]];

    endContent = "";
    endContentBangla = "";

    law =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[5]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[5]];
    lawBangla =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[6]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[6]];
    hasImage =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[7]] == null ? false : (json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[7]] == 0 ? false : true);

    if(hasImage) {
      image = json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[8]];
    }

    rule =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[9]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[9]];
    ruleBangla =  json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[10]] == null ? "" : json[DbHelper.TABLE_HIGHWAY_CODE_COLUMNS[10]];
  }


  HighWayCode.fromRoadSign(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[0]];

    idBangla = _translateNumber(id);

    categoryID =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[1]];
    subCategoryID =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[2]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[2]];

    hasImage =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[3]] == null ? false : true;

    if(hasImage) {
      image = json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[3]];
    }

    content =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[4]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[4]];
    contentBangla =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[5]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[5]];
    endContent =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[6]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[6]];
    endContentBangla =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[7]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[7]];
    isMarkedFavourite =  json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[8]] == null ? false : (json[DbHelper.TABLE_ROAD_SIGN_COLUMNS[8]] == 0 ? false : true);

    law =  "";
    lawBangla =  "";
    rule =  "";
    ruleBangla =  "";
  }


  favStatus() {

    return {
      DbHelper.TABLE_ROAD_SIGN_COLUMNS[8] : isMarkedFavourite == null ? 0 : (isMarkedFavourite ? 1 : 0)
    };
  }


  String _translateNumber(int number) {

    String numInBangla = "";

    for(int i=0; i<number.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number.toString()[i] == Constants.englishNumeric[j]) {

          numInBangla = numInBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return numInBangla;
  }
}


class HighWayCodeList {

  List<HighWayCode> list;

  HighWayCodeList({this.list});

  HighWayCodeList.fromMap(List<Map> maps) {

    list = List();

    if(maps != null) {

      maps.forEach((code) {
        list.add(HighWayCode.fromMap(code));
      });
    }
  }

  HighWayCodeList.fromRoadSign(List<Map> maps) {

    list = List();

    if(maps != null) {

      maps.forEach((code) {
        list.add(HighWayCode.fromRoadSign(code));
      });
    }
  }
}
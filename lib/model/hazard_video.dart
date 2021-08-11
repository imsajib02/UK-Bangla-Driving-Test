import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'dart:convert';

import 'package:ukbangladrivingtest/utils/parse_duration.dart';


class Details {

  int totalMarks;
  String description;
  String descriptionBangla;
  Duration startFrame;
  Duration endFrame;
  int highestMark;
  int lowestMark;

  Details({this.totalMarks, this.description, this.descriptionBangla, this.startFrame,
    this.endFrame, this.highestMark, this.lowestMark});


  Details.fromJson(Map<String, dynamic> json) {

    totalMarks =  json['marks'] == null ? 0 : json['marks'];
    description =  json['description'] == null ? "" : json['description'];
    descriptionBangla =  json['bangla_description'] == null ? "" : json['bangla_description'];
    startFrame =  json['time_frame_start'] == null ? Duration() : parseDuration(json['time_frame_start']);
    endFrame =  json['time_frame_end'] == null ? Duration() : parseDuration(json['time_frame_end']);
    highestMark =  json['highest_mark'] == null ? 0 : json['highest_mark'];
    lowestMark =  json['lowest_mark'] == null ? 0 : json['lowest_mark'];
  }
}


class HazardClip {

  int id;
  String clipUrl;
  Duration clipDuration;
  int score;
  String scoreInBangla;
  List<Details> detailsList;

  HazardClip({this.id, this.clipUrl, this.clipDuration, this.detailsList, this.score});


  HazardClip.fromJson(Map<String, dynamic> json, int id) {

    this.id = id;
    clipUrl =  json['clip_path'] == null ? "" : json['clip_path'];
    clipDuration =  json['duration'] == null ? Duration() : parseDuration(json['duration']);

    detailsList = List();

    if(json['details'] != null) {

      json['details'].forEach((detail) {
        detailsList.add(Details.fromJson(detail));
      });
    }

    score = 0;
    scoreInBangla = "০";
  }


  HazardClip.fromDb(Map<String, dynamic> map) {

    id =  map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[0]] == null ? 0 : map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[0]];

    if(map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[1]] != null) {

      Map clipData = json.decode(map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[1]]);

      clipUrl =  clipData['clip_path'] == null ? "" : clipData['clip_path'];
      clipDuration =  clipData['duration'] == null ? Duration() : parseDuration(clipData['duration']);

      detailsList = List();

      if(clipData['details'] != null) {

        clipData['details'].forEach((detail) {
          detailsList.add(Details.fromJson(detail));
        });
      }
    }
    else {

      clipUrl = "";
      detailsList = List();
    }

    score =  map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[2]] == null ? 0 : map[DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[2]];
    scoreInBangla = _translateNumber(score);
  }


  setScore() {

    return {
      DbHelper.TABLE_HAZARD_CLIPS_COLUMNS[2] : score == null ? 0 : score,
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


class HazardClips {

  List<HazardClip> clipList;

  HazardClips({this.clipList});


  HazardClips.fromJson(List list) {

    clipList = List();

    list.forEach((clip) {

      if(clip != null) {

        //clipList.add(HazardClip.fromJson(clip));
      }
    });
  }


  HazardClips.fromDb(List<Map> maps) {

    clipList = List();

    maps.forEach((clip) {

      if(clip != null) {

        clipList.add(HazardClip.fromDb(clip));
      }
    });
  }
}
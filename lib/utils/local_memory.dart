import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/localization_constrants.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalMemory {

  Future<SharedPreferences> _prefs;

  static const String LANGUAGE_CODE = "bhj6GF4Bu7gY";
  static const String LOGGED_USER = "gG5DTRD6chG";
  static const String FIRST_OPEN = "bbJHFVf56rtG";
  static const String THEORY_TEST_ALERT_SHOW = "H68tvDhdhM";
  static const String PASS_GUARANTEE_STATUS = "JKbkG78Tgy";
  static const String SOUND_STATUS = "BhgU6Tf7c";
  static const String USER_TYPE = "jhg67RFr76";
  static const String COUNTRY = "vGHR56r7UT7";
  static const String NUMBER_OF_QUESTION = "9B8u986R";
  static const String QUESTION_TYPE = "VJcy54v8";
  static const String AUTO_MOVE_TO_NEXT = "LNjkh876tdfY";
  static const String INCORRECT_ALERT = "mbGFSDerJ";
  static const String QUESTION_CHOICE_VALIDATION_SHOW = "mnBJHf76TDC";
  static const String NOT_ENOUGH_QUESTION_ALERT = "vytRrv65ft";
  static const String QUESTION_ANSWER_LANGUAGE = "j68VDRT";
  static const String VOICE_ACTIVATION = "JKu8989T7";

  LocalMemory() {
    _prefs = SharedPreferences.getInstance();
  }


  Future<Locale> saveLanguageCode(String languageCode) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setString(LANGUAGE_CODE, languageCode);

    return getLocale(languageCode);
  }


  Future<Locale> getLanguageCode() async {

    final SharedPreferences prefs = await _prefs;
    String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;

    return getLocale(languageCode);
  }

  /*saveUser(User user) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setString(LOGGED_USER, json.encode(user.toLocal()));
  }

  Future<User> getUser() async {

    final SharedPreferences prefs = await _prefs;
    User user = User(auth: false);

    if(prefs.containsKey(LOGGED_USER)) {

      var data = json.decode(await prefs.get(LOGGED_USER));
      user = User.fromLocal(data);
      user.auth = true;
    }

    return user;
  }*/


  setFirstOpenOrNot(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(FIRST_OPEN, value);
  }


  Future<bool> isFirstOpen() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(FIRST_OPEN)) {

      bool val = prefs.getBool(FIRST_OPEN);
      return val;
    }

    return true;
  }


  setUserType(int id) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(USER_TYPE, id);
  }


  Future<int> getUserType() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(USER_TYPE)) {

      int id = prefs.getInt(USER_TYPE);
      return id;
    }

    return Constants.userTypeIdList[0];
  }


  setCountry(int code) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(COUNTRY, code);
  }


  Future<int> getCountry() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(COUNTRY)) {

      int code = prefs.getInt(COUNTRY);
      return code;
    }

    return Constants.countryCodeList[0];
  }


  setNumberOfQuestion(int id) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(NUMBER_OF_QUESTION, id);
  }


  Future<int> getNumberOfQuestion() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(NUMBER_OF_QUESTION)) {

      int id = prefs.getInt(NUMBER_OF_QUESTION);
      return id;
    }

    return Constants.numberOfQuestionsIdList[Constants.numberOfQuestionsIdList.length - 1];
  }


  setTypeOfQuestion(int id) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(QUESTION_TYPE, id);
  }


  Future<int> getTypeOfQuestion() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(QUESTION_TYPE)) {

      int id = prefs.getInt(QUESTION_TYPE);
      return id;
    }

    return Constants.questionTypeIdList[0];
  }


  setTheoryTestAlertShow(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(THEORY_TEST_ALERT_SHOW, value);
  }


  Future<bool> shouldShowTheoryTestAlert() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(THEORY_TEST_ALERT_SHOW)) {

      bool val = prefs.getBool(THEORY_TEST_ALERT_SHOW);
      return val;
    }

    return true;
  }


  setQuestionChoiceValidationShow(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(QUESTION_CHOICE_VALIDATION_SHOW, value);
  }


  Future<bool> shouldShowQuestionChoiceValidationAlert() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(QUESTION_CHOICE_VALIDATION_SHOW)) {

      bool val = prefs.getBool(QUESTION_CHOICE_VALIDATION_SHOW);
      return val;
    }

    return true;
  }


  setNotEnoughQuestionShow(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(NOT_ENOUGH_QUESTION_ALERT, value);
  }


  Future<bool> shouldShowNotEnoughQuestionAlert() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(NOT_ENOUGH_QUESTION_ALERT)) {

      bool val = prefs.getBool(NOT_ENOUGH_QUESTION_ALERT);
      return val;
    }

    return true;
  }


  setMoveToNextStatus(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(AUTO_MOVE_TO_NEXT, value);
  }


  Future<bool> getMoveToNextStatus() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(AUTO_MOVE_TO_NEXT)) {

      bool val = prefs.getBool(AUTO_MOVE_TO_NEXT);
      return val;
    }

    return true;
  }


  setVoiceActivationStatus(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(VOICE_ACTIVATION, value);
  }


  Future<bool> getVoiceActivationStatus() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(VOICE_ACTIVATION)) {

      bool val = prefs.getBool(VOICE_ACTIVATION);
      return val;
    }

    return true;
  }


  setIncorrectAlertStatus(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(INCORRECT_ALERT, value);
  }


  Future<bool> getIncorrectAlertStatus() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(INCORRECT_ALERT)) {

      bool val = prefs.getBool(INCORRECT_ALERT);
      return val;
    }

    return false;
  }


  setPassGuaranteeStatus(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(PASS_GUARANTEE_STATUS, value);
  }


  Future<bool> getPassGuaranteeStatus() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(PASS_GUARANTEE_STATUS)) {

      bool val = prefs.getBool(PASS_GUARANTEE_STATUS);
      return val;
    }

    return false;
  }


  setSoundStatus(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(SOUND_STATUS, value);
  }


  Future<bool> getSoundStatus() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(SOUND_STATUS)) {

      bool val = prefs.getBool(SOUND_STATUS);
      return val;
    }

    return true;
  }


  setQuestionAnswerLanguage(int id) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(QUESTION_ANSWER_LANGUAGE, id);
  }


  Future<int> getQuestionAnswerLanguage() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(QUESTION_ANSWER_LANGUAGE)) {

      int id = prefs.getInt(QUESTION_ANSWER_LANGUAGE);
      return id;
    }

    return Constants.questionAnswerLanguageIdList[0];
  }


  Future<Set<String>> getAllKeys() async {

    final SharedPreferences prefs = await _prefs;
    return prefs.getKeys();
  }


  Future<bool> clearAllData() async {

    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }


  Future remove(String key) async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(key)) {
      await prefs.remove(key);
    }
  }
}
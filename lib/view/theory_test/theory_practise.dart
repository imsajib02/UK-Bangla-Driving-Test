import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_answer_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/test_result_page_model.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_answer_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/theory_question_explanation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';


class TheoryPractise extends StatefulWidget {

  final List<bool> _selectedCategoryList;

  TheoryPractise(this._selectedCategoryList);

  @override
  State<StatefulWidget> createState() {
    return _TheoryPractiseState();
  }
}

class _TheoryPractiseState extends State<TheoryPractise> implements QuestionAnswerInterface {

  QuestionAnswerViewModel _answerViewModel;
  SettingsViewModel _settingsViewModel;

  QuestionAnswerInterface _questionAnswerInterface;

  List<List<String>> _answers = List();
  List<List<String>> _banglaAnswers = List();


  @override
  void initState() {
    _questionAnswerInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _answerViewModel = Provider.of<QuestionAnswerViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _answerViewModel.removeDisposedStatus();
      _answerViewModel.getAutoMoveStatus();
      _answerViewModel.getIncorrectAlert();
      _answerViewModel.getQuestions(widget._selectedCategoryList, _questionAnswerInterface);

      Provider.of<QuestionAnswerViewModel>(context, listen: true).getAnsweringLanguage(context);
      Provider.of<QuestionAnswerViewModel>(context, listen: true).getVoiceOverStatus();
    });

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future(() => false);
      },
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return _body();
          },
        ),
      ),
    );
  }


  Widget _body() {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
              flex: 3,
              child: _header()
          ),

          Expanded(
              flex: 19,
              child: _mainBody(),
          ),

          Expanded(
              flex: 2,
              child: _footer()
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
        color: Colors.lightGreen[500],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Icon(Icons.arrow_back, color: Colors.lightGreen[500],),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _onBackPressed();
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Text(_answerViewModel.language,
                  style: Theme.of(context).textTheme.subtitle2,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _answerViewModel.alterLanguage(context);
                },
              ),
            ),

            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(AppLocalization.of(context).getTranslatedValue("question") + " " + (_settingsViewModel.isEnglish ?
                _answerViewModel.number.toString() : _answerViewModel.stringNumber),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Padding(
                    padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                    child: Image.asset(
                      _answerViewModel.isVoiceActivated ? Images.voiceOnIcon : Images.voiceOffIcon,
                      color: Colors.lightGreen[500],
                    ),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _answerViewModel.setVoiceOverStatus();
                },
              ),
            ),

            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Icon(Icons.play_circle_filled, color: Colors.lightGreen[500],),
                ),
                onTap: () {
                  _answerViewModel.speak(true);
                },
              ),
            ),
          ],
        )
    );
  }


  Container _mainBody() {

    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Container(
            height: 1.5 * SizeConfig.heightSizeMultiplier,
            width: double.infinity,
            color: Colors.white,
            child: LinearPercentIndicator(
              lineHeight: 1 * SizeConfig.heightSizeMultiplier,
              percent: _answerViewModel.number > 0 ? (_answerViewModel.number / _answerViewModel.testQuestionList.list.length) : 0.0,
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              progressColor: Colors.lightGreen[700],
              linearStrokeCap: LinearStrokeCap.butt,
            ),
          ),

          Expanded(
            flex: _answerViewModel.number > 0 && _answerViewModel.testQuestionList.list[_answerViewModel.number-1].hasImage ? 4 : 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Expanded(
                  flex: _answerViewModel.number > 0 && _answerViewModel.testQuestionList.list[_answerViewModel.number-1].hasImage ? 2 : 2,
                  child: Container(
                    alignment: _answerViewModel.number > 0 ? (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].hasImage ?
                    Alignment.center : Alignment.bottomCenter) : Alignment.bottomCenter,
                    margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                    child: Text(_answerViewModel.number > 0 ? (_answerViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                    _answerViewModel.testQuestionList.list[_answerViewModel.number-1].question :
                    _answerViewModel.testQuestionList.list[_answerViewModel.number-1].questionInBangla) : "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: _answerViewModel.number > 0 && _answerViewModel.testQuestionList.list[_answerViewModel.number-1].hasImage,
                  child: _answerViewModel.number > 0 && _answerViewModel.testQuestionList.list[_answerViewModel.number-1].hasImage ?
                  Expanded(
                    flex: 3,
                    child: Container(
                      //height: 50 * SizeConfig.heightSizeMultiplier,
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      //margin: EdgeInsets.only(top: 6.25 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: MemoryImage(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].image),
                          fit: BoxFit.contain
                        ),
                      ),
                    ),
                  ) : Container(),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _answerList(),
            ),
          ),
        ],
      ),
    );
  }


  NotificationListener _answerList() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _answerViewModel.number > 0 ? ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
            child: Stack(
              children: <Widget>[

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                  margin: EdgeInsets.only(bottom: .375 * SizeConfig.heightSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier, left: 1.28 * SizeConfig.widthSizeMultiplier),
                  decoration: BoxDecoration(
                    color:  _answerViewModel.number > 0 ? (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isCorrectAnswerShown ?
                    (((index + 1) == _answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered) ||
                        (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].correctAnswer.contains((index + 1).toString())) ? Colors.white : Colors.lightGreen[500]) :
                    (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0 &&
                        ((index + 1) == _answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered) ? Colors.white : Colors.lightGreen[500])) : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(_answerViewModel.number > 0 ? (_answerViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? _answers[_answerViewModel.number-1][index] :
                  _banglaAnswers[_answerViewModel.number-1][index]) : "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: _answerViewModel.number > 0 ?
                      (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isCorrectAnswerShown ? Colors.black :
                      (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0 &&
                          ((index + 1) == _answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered) ? Colors.black : Colors.white)) : Colors.black),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(1.5 * SizeConfig.heightSizeMultiplier),
                  child: _answerViewModel.number > 0 && _answerViewModel.testQuestionList.list[_answerViewModel.number-1].isCorrectAnswerShown ?
                  (((index + 1) == _answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered) ?
                  Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.red,) :
                  ((_answerViewModel.testQuestionList.list[_answerViewModel.number-1].correctAnswer).contains((index + 1).toString()) ?
                  Icon(Icons.check_circle_outline, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.lightGreen[500],) :
                  Container())) : Container(),
                ),
              ],
            ),
            onTap: () {

              if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isCorrectAnswerShown) {
                return null;
              }
              else {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _saveOptionAnswered(index);
              }
            },
          );
        },
      ) : Center(child: CircularProgressIndicator(),),
    );
  }


  Container _footer() {

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: Row(
        children: <Widget>[

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: _answerViewModel.number > 1 ? Colors.black : Colors.grey[400],
                    size: 12.82 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {

                  if(_answerViewModel.flagList.length > 0 && _answerViewModel.number == _answerViewModel.flagList[0] + 1) {
                    return null;
                  }
                  else {

                    if(_answerViewModel.number > 1) {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _answerViewModel.decreaseNumber(_questionAnswerInterface);
                    }
                    else {
                      return null;
                    }
                  }
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.flag,
                    color: _answerViewModel.number > 0 ? (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isFlagged ? Colors.red : Colors.black) : Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _answerViewModel.onFlagPressed();
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.info,
                    color: Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _explanationWidget();
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.favorite,
                    color: _answerViewModel.number > 0 ? (_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isMarkedFavourite ? Colors.lightGreen[500] : Colors.black) : Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _answerViewModel.onFavPressed();
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: _answerViewModel.flagList.length > 0 ? (_answerViewModel.number == (_answerViewModel.flagList[_answerViewModel.flagList.length - 1] + 1) ?
                  Text(AppLocalization.of(context).getTranslatedValue("finish"), style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.lightGreen[500]),) :
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12.82 * SizeConfig.imageSizeMultiplier,)) :
                  (_answerViewModel.number > 0 && _answerViewModel.number == _answerViewModel.testQuestionList.list.length ?
                  Text(AppLocalization.of(context).getTranslatedValue("finish"), style: Theme.of(context).textTheme.headline6.copyWith(
                      color: _answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0 ? Colors.lightGreen[500] : Colors.grey),) :
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12.82 * SizeConfig.imageSizeMultiplier,)),
                ),

                onTap: () {

                  if(_answerViewModel.flagList.length > 0) {

                    Provider.of<SettingsViewModel>(context, listen: false).playSound();

                    if(_answerViewModel.number == (_answerViewModel.flagList[_answerViewModel.flagList.length - 1] + 1)) {

                      _answerViewModel.onFinished(_questionAnswerInterface);
                    }
                    else {

                      _answerViewModel.increaseNumber(_questionAnswerInterface);
                    }
                  }
                  else {

                    if(_answerViewModel.number > 0) {

                      if(_answerViewModel.number == _answerViewModel.testQuestionList.list.length) {

                        if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0) {

                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _answerViewModel.onFinished(_questionAnswerInterface);
                        }
                        else {

                          return null;
                        }
                      }
                      else {

                        if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isFlagged) {

                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _answerViewModel.increaseNumber(_questionAnswerInterface);
                        }
                        else {

                          if(_answerViewModel.autoMoveToNext) {

                            if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].isCorrectAnswerShown) {

                              Provider.of<SettingsViewModel>(context, listen: false).playSound();
                              _answerViewModel.increaseNumber(_questionAnswerInterface);
                            }
                            else {

                              if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0) {

                                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                _answerViewModel.increaseNumber(_questionAnswerInterface);
                              }
                              else {

                                return null;
                              }
                            }
                          }
                          else {

                            if(_answerViewModel.testQuestionList.list[_answerViewModel.number-1].optionAnswered != 0) {

                              Provider.of<SettingsViewModel>(context, listen: false).playSound();
                              _answerViewModel.increaseNumber(_questionAnswerInterface);
                            }
                            else {

                              return null;
                            }
                          }
                        }
                      }
                    }
                    else {

                      return null;
                    }
                  }
                },
              )
          ),
        ],
      ),
    );
  }



  @override
  void dispose() {

    _answerViewModel.resetModel();
    super.dispose();
  }


  @override
  void addAnswers(TheoryQuestion theoryQuestion) {

    _answers.add(<String> [theoryQuestion.option1, theoryQuestion.option2, theoryQuestion.option3, theoryQuestion.option4]);
    _banglaAnswers.add(<String> [theoryQuestion.option1InBangla, theoryQuestion.option2InBangla, theoryQuestion.option3InBangla, theoryQuestion.option4InBangla]);
  }


  void _saveOptionAnswered(int choice) {

    _answerViewModel.setOptionAnswered(choice + 1);

    bool isCorrect = false;

    for(int i=0; i<4; i++) {

      if(i == choice) {

        if(_answerViewModel.testQuestionList.list[_answerViewModel.number - 1].correctAnswer.toString().contains((i+1).toString())) {
          isCorrect = true;
        }
      }
    }


    if(_answerViewModel.isIncorrectAlertActive && !isCorrect) {
      _showIncorrectAlert(choice);
    }
    else {
      _onQuestionAnswered();
    }
  }


  void _onQuestionAnswered() {

    if(_answerViewModel.autoMoveToNext) {

      if(_answerViewModel.number < _answerViewModel.testQuestionList.list.length) {
        _answerViewModel.increaseNumber(_questionAnswerInterface);
      }
    }
  }


  void _showIncorrectAlert(int choice) async {

    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

          return WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: <Widget>[

                  Positioned(
                    right: 7.69 * SizeConfig.widthSizeMultiplier,
                    top: -11.25 * SizeConfig.heightSizeMultiplier,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Image.asset(Images.linesIcon),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                        top: 15 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
                    ),
                    child: _incorrectAlert(choice),
                  ),

                  Positioned(
                    top: 11.25 * SizeConfig.heightSizeMultiplier,
                    left: 40.25 * SizeConfig.widthSizeMultiplier,
                    right: 40.25 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 10 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier)
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15.5 * SizeConfig.heightSizeMultiplier,
                    left: 39.74 * SizeConfig.widthSizeMultiplier,
                    right: 39.74 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 11.875 * SizeConfig.heightSizeMultiplier,
                    left: 41.02 * SizeConfig.widthSizeMultiplier,
                    right: 41.02 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 7.5 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.info, color: Colors.lightGreen[500], size: 12.82 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Column _incorrectAlert(int choice) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              Navigator.of(context).pop();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("incorrect_answer"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
            flex: 15,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10.25 * SizeConfig.widthSizeMultiplier, right: 10.25 * SizeConfig.widthSizeMultiplier),
                    padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("show_answer"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _showCorrectAnswer(choice);
                  },
                ),

                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10.25 * SizeConfig.widthSizeMultiplier, right: 10.25 * SizeConfig.widthSizeMultiplier),
                    padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("try_again"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  void _showCorrectAnswer(int choice) {

    _answerViewModel.setCorrectAnswerShownStatus();
    Navigator.of(context).pop();
  }


  @override
  void removeLastAnswer() {

    //_answers.removeLast();
    //_answerSelection.removeLast();
  }


  @override
  void showFlaggedQuestionAlert() async {

    if(mounted) {

      return showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white,
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

            return WillPopScope(
              onWillPop: () {
                return Future(() => false);
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[

                    Positioned(
                      right: 7.69 * SizeConfig.widthSizeMultiplier,
                      top: -11.25 * SizeConfig.heightSizeMultiplier,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(Images.linesIcon),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                          top: 15 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
                      ),
                      child: _flaggedAlert(),
                    ),

                    Positioned(
                      top: 11.25 * SizeConfig.heightSizeMultiplier,
                      left: 40.25 * SizeConfig.widthSizeMultiplier,
                      right: 40.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 10 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier)
                        ),
                      ),
                    ),

                    Positioned(
                      top: 15.5 * SizeConfig.heightSizeMultiplier,
                      left: 39.74 * SizeConfig.widthSizeMultiplier,
                      right: 39.74 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 6.25 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 11.875 * SizeConfig.heightSizeMultiplier,
                      left: 41.02 * SizeConfig.widthSizeMultiplier,
                      right: 41.02 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 7.5 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(Images.questionIcon, color: Colors.lightGreen[500],),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
  }


  Column _flaggedAlert() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              Navigator.of(context).pop();
              _answerViewModel.saveTestResults(_questionAnswerInterface);
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("flagged_title"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 10,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
            child: Text(AppLocalization.of(context).getTranslatedValue("flagged_questions_message"),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),

        Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("yes"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _answerViewModel.setFlaggedNumber();
                  },
                ),

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("no"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _answerViewModel.saveTestResults(_questionAnswerInterface);
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  void _onBackPressed() async {

    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

          return WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: <Widget>[

                  Positioned(
                    right: 7.69 * SizeConfig.widthSizeMultiplier,
                    top: -11.25 * SizeConfig.heightSizeMultiplier,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Image.asset(Images.linesIcon),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                        top: 15 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
                    ),
                    child: _quitAlert(),
                  ),

                  Positioned(
                    top: 11.25 * SizeConfig.heightSizeMultiplier,
                    left: 40.25 * SizeConfig.widthSizeMultiplier,
                    right: 40.25 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 10 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier)
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15.5 * SizeConfig.heightSizeMultiplier,
                    left: 39.74 * SizeConfig.widthSizeMultiplier,
                    right: 39.74 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 11.875 * SizeConfig.heightSizeMultiplier,
                    left: 41.02 * SizeConfig.widthSizeMultiplier,
                    right: 41.02 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 7.5 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.pause_circle_filled, color: Colors.lightGreen[500], size: 12.82 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Column _quitAlert() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              Navigator.of(context).pop();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("test_paused"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 10,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
            child: Text(AppLocalization.of(context).getTranslatedValue("test_paused_message"),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),

        Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("resume"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                  },
                ),

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("quit"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _quitTest();
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  void _quitTest() async {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
  }


  void _explanationWidget() async {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return StatefulBuilder(
              builder: (context, StateSetter setState) {

                _answerViewModel.speak(false);
                return QuestionExplanation(true);
              }
          );
        }
    );
  }


  @override
  void showTestResult() {

    TestResultPageModel resultPageModel = TestResultPageModel(isMockTest: false, questionList: _answerViewModel.testQuestionList);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.TEST_RESULT_PAGE_ROUTE, arguments: resultPageModel);
  }


  @override
  void showRemainingTime(int remainingTime) {
  }


  @override
  void onClose() {
  }
}
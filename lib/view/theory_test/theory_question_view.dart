import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_answer_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/QuestionView.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_answer_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/theory_question_explanation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';


class TheoryQuestionView extends StatefulWidget {

  final QuestionView _questionView;

  TheoryQuestionView(this._questionView);

  @override
  State<StatefulWidget> createState() {
    return _TheoryQuestionViewState();
  }
}


class _TheoryQuestionViewState extends State<TheoryQuestionView> implements QuestionAnswerInterface {

  QuestionViewModel _questionSearchViewModel;
  SettingsViewModel _settingsViewModel;
  QuestionAnswerInterface _questionAnswerInterface;

  Map<int, List<String>> _answers = Map();
  Map<int, List<String>> _banglaAnswers = Map();


  @override
  void initState() {

    _questionAnswerInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _questionSearchViewModel = Provider.of<QuestionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _questionSearchViewModel.setNumber(widget._questionView.index, _questionAnswerInterface);
    });

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        onClose();
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
                  onClose();
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Text(mounted ? _questionSearchViewModel.language : "",
                    style: Theme.of(context).textTheme.subtitle2,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _questionSearchViewModel.alterLanguage(context, interface: widget._questionView.questionSearchInterface);
                },
              ),
            ),

            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(AppLocalization.of(context).getTranslatedValue("question") + " " + (_settingsViewModel.isEnglish ?
                _questionSearchViewModel.number.toString() : _questionSearchViewModel.stringNumber),
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
                    child: mounted ? Image.asset(
                      _questionSearchViewModel.isVoiceActivated ? Images.voiceOnIcon : Images.voiceOffIcon,
                      color: Colors.lightGreen[500],
                    ) : Container(),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _questionSearchViewModel.setVoiceOverStatus();
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
                  _questionSearchViewModel.speak(true);
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
              percent: _questionSearchViewModel.number > 0 ? (_questionSearchViewModel.number / _questionSearchViewModel.filterList.list.length) : 0.0,
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              progressColor: Colors.lightGreen[500],
              linearStrokeCap: LinearStrokeCap.butt,
            ),
          ),

          Expanded(
            flex: _questionSearchViewModel.number > 0 && _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].hasImage ? 4 : 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Expanded(
                  flex: _questionSearchViewModel.number > 0 && _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].hasImage ? 2 : 2,
                  child: Container(
                    alignment: _questionSearchViewModel.number > 0 ? (_questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].hasImage ?
                    Alignment.center : Alignment.bottomCenter) : Alignment.bottomCenter,
                    margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                    child: mounted ? Text(_questionSearchViewModel.number > 0 ? (_questionSearchViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                    _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].question :
                    _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].questionInBangla) : "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ) : Container(),
                  ),
                ),

                Visibility(
                  visible: _questionSearchViewModel.number > 0 && _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].hasImage,
                  child: _questionSearchViewModel.number > 0 && _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].hasImage ?
                  Container(
                    //height: 18.75 * SizeConfig.heightSizeMultiplier,
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    //margin: EdgeInsets.only(top: 6.25 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(_questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].image),
                          fit: BoxFit.contain
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
      child: _questionSearchViewModel.number > 0 ? ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return Stack(
            children: <Widget>[

              Container(
                width: double.infinity,
                padding: _questionSearchViewModel.number > 0 ? ((index+1) == _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].correctAnswer ?
                EdgeInsets.only(right: 6.41 * SizeConfig.widthSizeMultiplier, top: 1.875 * SizeConfig.heightSizeMultiplier,
                    bottom: 1.875 * SizeConfig.heightSizeMultiplier, left: 3.84 * SizeConfig.widthSizeMultiplier) :
                EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier)) : EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                margin: EdgeInsets.only(bottom: .375 * SizeConfig.heightSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier, left: 1.28 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color:  _questionSearchViewModel.number > 0 ? ((index+1) == _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].correctAnswer ?
                  Colors.white : Colors.lightGreen[500]) : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: mounted ? Text(_questionSearchViewModel.number > 0 ? (_questionSearchViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                _answers[_questionSearchViewModel.number][index] : _banglaAnswers[_questionSearchViewModel.number][index]) : "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: _questionSearchViewModel.number > 0 ?
                    ((index+1) == _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].correctAnswer ?
                    Colors.black : Colors.black) : Colors.black),
                  ),
                ) : Container(),
              ),

              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                child: _questionSearchViewModel.number > 0 ?
                ((index+1) == _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].correctAnswer ? Icon(Icons.check_circle_outline,
                  size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.lightGreen[500],) :
                Container()) : Container(),
              ),
            ],
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
                    color: _questionSearchViewModel.number > 1 ? Colors.black : Colors.grey[400],
                    size: 12.82 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {

                  if(_questionSearchViewModel.number > 1) {

                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _questionSearchViewModel.decreaseNumber(_questionAnswerInterface);
                  }
                  else {

                    return null;
                  }
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
                    color: _questionSearchViewModel.number > 0 ? (_questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].isMarkedFavourite ? Colors.lightGreen[500] : Colors.black) :
                    Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _questionSearchViewModel.onFavPressed(_questionAnswerInterface, widget._questionView.questionSearchInterface);
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: _questionSearchViewModel.number > 0 ? (_questionSearchViewModel.number == (_questionSearchViewModel.filterList.list.length) ?
                  Text(AppLocalization.of(context).getTranslatedValue("finish"), style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.lightGreen[500]),) :
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12.82 * SizeConfig.imageSizeMultiplier,)) :
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12.82 * SizeConfig.imageSizeMultiplier,),
                ),

                onTap: () {

                  if(_questionSearchViewModel.number == 0) {

                    return null;
                  }
                  else {

                    Provider.of<SettingsViewModel>(context, listen: false).playSound();

                    if(_questionSearchViewModel.number == _questionSearchViewModel.filterList.list.length) {

                      onClose();
                    }
                    else {

                      _questionSearchViewModel.increaseNumber(_questionAnswerInterface);
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
    _questionSearchViewModel.onClose();
    super.dispose();
  }



  void _explanationWidget() async {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return StatefulBuilder(
              builder: (context, StateSetter setState) {

                _questionSearchViewModel.speak(false);
                return QuestionExplanation(false);
              }
          );
        }
    );
  }


  @override
  void addAnswers(TheoryQuestion theoryQuestion) {

    _answers[_questionSearchViewModel.number] = <String> [theoryQuestion.option1, theoryQuestion.option2, theoryQuestion.option3, theoryQuestion.option4];
    _banglaAnswers[_questionSearchViewModel.number] = <String> [theoryQuestion.option1InBangla, theoryQuestion.option2InBangla, theoryQuestion.option3InBangla, theoryQuestion.option4InBangla];
  }


  @override
  void removeLastAnswer() {
  }


  @override
  void showFlaggedQuestionAlert() {
  }


  @override
  void showTestResult() {
  }


  @override
  void showRemainingTime(int remainingTime) {
  }


  @override
  void onClose() {

    _questionSearchViewModel.onClose();
    Navigator.pop(context);
  }
}
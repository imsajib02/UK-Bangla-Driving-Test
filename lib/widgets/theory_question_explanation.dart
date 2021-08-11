import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_answer_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class QuestionExplanation extends StatefulWidget {

  final bool _isAnswerPage;

  const QuestionExplanation(this._isAnswerPage);

  @override
  _QuestionExplanationState createState() => _QuestionExplanationState();
}


class _QuestionExplanationState extends State<QuestionExplanation> {

  QuestionAnswerViewModel _answerViewModel;
  QuestionViewModel _questionSearchViewModel;


  @override
  void didChangeDependencies() {

    _answerViewModel = Provider.of<QuestionAnswerViewModel>(context);
    _questionSearchViewModel = Provider.of<QuestionViewModel>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future(() => false);
      },
      child: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Scaffold(
          body: Stack(
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
                child: Column(
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
                      child: Text(AppLocalization.of(context).getTranslatedValue("explanation"),
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
                        child: mounted ? Text(widget._isAnswerPage ? (_answerViewModel.number > 0 ? (_answerViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                        _answerViewModel.testQuestionList.list[_answerViewModel.number-1].explanation :
                        _answerViewModel.testQuestionList.list[_answerViewModel.number-1].explanationInBangla) : "") : (_questionSearchViewModel.number > 0 ?
                        (_questionSearchViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].explanation :
                        _questionSearchViewModel.filterList.list[_questionSearchViewModel.number-1].explanationInBangla) : ""),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ) : Container(),
                      ),
                    ),

                    Flexible(
                        flex: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                                      margin: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen[700],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: mounted ? Text(widget._isAnswerPage ? _answerViewModel.language : _questionSearchViewModel.language,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                        ),
                                      ) : Container(),
                                    ),
                                    onTap: () {
                                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                      widget._isAnswerPage ? _answerViewModel.alterLanguage(context) : _questionSearchViewModel.alterLanguage(context);
                                    },
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                                      margin: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen[700],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          mounted ? Image.asset(
                                            widget._isAnswerPage ? (_answerViewModel.isVoiceActivated ? Images.voiceOnIcon : Images.voiceOffIcon) :
                                            (_questionSearchViewModel.isVoiceActivated ? Images.voiceOnIcon : Images.voiceOffIcon),
                                            color: Colors.white,
                                            width: 5.12 * SizeConfig.widthSizeMultiplier, height: 2.5 * SizeConfig.heightSizeMultiplier,
                                          ) : Container(),

                                          mounted ? Text(widget._isAnswerPage ? (_answerViewModel.isVoiceActivated ? AppLocalization.of(context).getTranslatedValue("on") :
                                          AppLocalization.of(context).getTranslatedValue("off")) : (_questionSearchViewModel.isVoiceActivated ? AppLocalization.of(context).getTranslatedValue("on") :
                                          AppLocalization.of(context).getTranslatedValue("off")),
                                            style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                            ),
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                      widget._isAnswerPage ? _answerViewModel.setVoiceOverStatus() : _questionSearchViewModel.setVoiceOverStatus();
                                    },
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                                      margin: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen[700],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          Icon(Icons.replay, size: 5.12 * SizeConfig.imageSizeMultiplier, color: Colors.white,),

                                          Text(AppLocalization.of(context).getTranslatedValue("replay"),
                                            style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      widget._isAnswerPage ? _answerViewModel.speak(false) : _questionSearchViewModel.speak(false);
                                    },
                                  ),
                                ),
                              ],
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
                                child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
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
                          ],
                        )
                    ),
                  ],
                ),
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
      ),
    );
  }
}
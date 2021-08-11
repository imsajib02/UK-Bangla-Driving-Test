import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/theory_progress_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class ProgressAnswerReview extends StatefulWidget {

  final int _index;

  ProgressAnswerReview(this._index);

  @override
  _ProgressAnswerReviewState createState() => _ProgressAnswerReviewState();
}


class _ProgressAnswerReviewState extends State<ProgressAnswerReview> {

  TheoryProgressViewModel _theoryProgressViewModel;
  QuestionViewModel _questionViewModel;


  @override
  void didChangeDependencies() {

    _theoryProgressViewModel = Provider.of<TheoryProgressViewModel>(context);
    _questionViewModel = Provider.of<QuestionViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Provider.of<QuestionViewModel>(context, listen: true).getAnsweringLanguage(context);
    });

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
          body: Builder(
            builder: (BuildContext context) {
              return _body();
            },
          ),
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
              flex: 2,
              child: _header()
          ),

          Expanded(
            flex: 1,
            child: _tabView(),
          ),

          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier, left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
              child: IndexedStack(
                index: _theoryProgressViewModel.currentIndex,
                children: <Widget>[

                  _allTab(),

                  _correctTab(),

                  _incorrectTab(),

                  _flaggedTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 4.375 * SizeConfig.heightSizeMultiplier),
        color: Colors.black87,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  Navigator.of(context).pop();
                },
              ),
            ),

            Expanded(
              flex: 5,
              child: Text(AppLocalization.of(context).getTranslatedValue("review_answers"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Text(_questionViewModel.language,
                    style: Theme.of(context).textTheme.subtitle2,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _questionViewModel.alterLanguage(context);
                },
              ),
            ),
          ],
        )
    );
  }


  Container _tabView() {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
      child: Row(
        children: <Widget>[

          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: .76 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.currentIndex == TheoryProgressViewModel.all ? Colors.lightGreen[500] : Colors.black45,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("all"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _theoryProgressViewModel.setTab(TheoryProgressViewModel.all);
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: .51 * SizeConfig.widthSizeMultiplier, right: .76 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.currentIndex == TheoryProgressViewModel.correct ? Colors.lightGreen[500] : Colors.black45,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("correct"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _theoryProgressViewModel.setTab(TheoryProgressViewModel.correct);
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: .51 * SizeConfig.widthSizeMultiplier, right: .76 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.currentIndex == TheoryProgressViewModel.incorrect ? Colors.lightGreen[500] : Colors.black45,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("incorrect"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _theoryProgressViewModel.setTab(TheoryProgressViewModel.incorrect);
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: .51 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.currentIndex == TheoryProgressViewModel.flagged ? Colors.lightGreen[500] : Colors.black45,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("flagged"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _theoryProgressViewModel.setTab(TheoryProgressViewModel.flagged);
              },
            ),
          ),
        ],
      ),
    );
  }


  NotificationListener _allTab() {

    return NotificationListener<OverscrollIndicatorNotification> (
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _theoryProgressViewModel.totalCorrect[widget._index].length == 0 && _theoryProgressViewModel.totalIncorrect[widget._index].length == 0 ? Padding(
        padding: EdgeInsets.all(3.125 * SizeConfig.heightSizeMultiplier),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(AppLocalization.of(context).getTranslatedValue("no_question_answered"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),),
        ),
      ) : ListView.builder(
        itemCount: _theoryProgressViewModel.isPractiseMode ? _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list.length :
        _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          String question = "";

          if(_questionViewModel.language == AppLocalization.of(context).getTranslatedValue("en")) {

            question = (index+1).toString() + ". " + (_theoryProgressViewModel.isPractiseMode ?
            _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[index].question :
            _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[index].question);
          }
          else {

            question = _theoryProgressViewModel.indexBanglaList[widget._index][index] + ". " + (_theoryProgressViewModel.isPractiseMode ?
            _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[index].questionInBangla :
            _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[index].questionInBangla);
          }

          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                margin: EdgeInsets.only(bottom: 1* SizeConfig.heightSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.isPractiseMode ?
                  (_theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[index].isAnsweredCorrectly ? Colors.lightGreen[500] : Colors.red) :
                  (_theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[index].isAnsweredCorrectly ? Colors.lightGreen[500] : Colors.red),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier),
                  child: Text(question,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                child: _theoryProgressViewModel.isPractiseMode ?
                (_theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[index].isAnsweredCorrectly ?
                Icon(Icons.check, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,) :
                Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,)) :
                (_theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[index].isAnsweredCorrectly ?
                Icon(Icons.check, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,) :
                Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,)),
              )
            ],
          );
        },
      ),
    );
  }


  NotificationListener _correctTab() {

    return NotificationListener<OverscrollIndicatorNotification> (
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _theoryProgressViewModel.totalCorrect[widget._index].length > 0 ? ListView.builder(
        itemCount: _theoryProgressViewModel.totalCorrect[widget._index].length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          String question = "";

          if(_questionViewModel.language == AppLocalization.of(context).getTranslatedValue("en")) {

            question = (_theoryProgressViewModel.totalCorrect[widget._index][index]+1).toString() + ". " + (_theoryProgressViewModel.isPractiseMode ?
                _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalCorrect[widget._index][index]].question :
                _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalCorrect[widget._index][index]].question);
          }
          else {
            question = (_theoryProgressViewModel.indexBanglaList[widget._index][_theoryProgressViewModel.totalCorrect[widget._index][index]]).toString() + ". "
                + (_theoryProgressViewModel.isPractiseMode ?
                _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalCorrect[widget._index][index]].questionInBangla :
                _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalCorrect[widget._index][index]].questionInBangla);
          }

          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                margin: EdgeInsets.only(bottom: 1 * SizeConfig.heightSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[500],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier),
                  child: Text(question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                child: Icon(Icons.check, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,),
              )
            ],
          );
        },
      ) : Padding(
        padding: EdgeInsets.all(3.125 * SizeConfig.heightSizeMultiplier),
        child: Text(!_theoryProgressViewModel.isPractiseMode ? AppLocalization.of(context).getTranslatedValue("no_correct_answer_mock") :
        AppLocalization.of(context).getTranslatedValue("no_correct_answer"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),),
      ),
    );
  }


  NotificationListener _incorrectTab() {

    return NotificationListener<OverscrollIndicatorNotification> (
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _theoryProgressViewModel.totalIncorrect[widget._index].length > 0 ? ListView.builder(
        itemCount: _theoryProgressViewModel.totalIncorrect[widget._index].length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          String question = "";

          if(_questionViewModel.language == AppLocalization.of(context).getTranslatedValue("en")) {

            question = (_theoryProgressViewModel.totalIncorrect[widget._index][index]+1).toString() + ". " + (_theoryProgressViewModel.isPractiseMode ?
            _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalIncorrect[widget._index][index]].question :
            _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalIncorrect[widget._index][index]].question);
          }
          else {

            question = (_theoryProgressViewModel.indexBanglaList[widget._index][_theoryProgressViewModel.totalIncorrect[widget._index][index]]).toString() + ". "
                + (_theoryProgressViewModel.isPractiseMode ?
                _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalIncorrect[widget._index][index]].questionInBangla :
                _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.totalIncorrect[widget._index][index]].questionInBangla);
          }

          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                margin: EdgeInsets.only(bottom: 1 * SizeConfig.heightSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier),
                  child: Text(question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                child: Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,),
              )
            ],
          );
        },
      ) : Padding(
        padding: EdgeInsets.all(3.125 * SizeConfig.heightSizeMultiplier),
        child: Text(!_theoryProgressViewModel.isPractiseMode ? AppLocalization.of(context).getTranslatedValue("no_incorrect_answer_mock") :
        AppLocalization.of(context).getTranslatedValue("no_incorrect_answer"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),),
      ),
    );
  }


  NotificationListener _flaggedTab() {

    return NotificationListener<OverscrollIndicatorNotification> (
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _theoryProgressViewModel.flagList[widget._index].length > 0 ? ListView.builder(
        itemCount: _theoryProgressViewModel.flagList[widget._index].length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          String question = "";

          if(_questionViewModel.language == AppLocalization.of(context).getTranslatedValue("en")) {

            question = (_theoryProgressViewModel.flagList[widget._index][index]+1).toString() + ". " + (_theoryProgressViewModel.isPractiseMode ?
            _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].question :
            _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].question);
          }
          else {

            question = (_theoryProgressViewModel.indexBanglaList[widget._index][_theoryProgressViewModel.flagList[widget._index][index]]).toString() + ". "
                + (_theoryProgressViewModel.isPractiseMode ?
                _theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].questionInBangla :
                _theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].questionInBangla);
          }

          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                margin: EdgeInsets.only(bottom: 1 * SizeConfig.heightSizeMultiplier),
                decoration: BoxDecoration(
                  color: _theoryProgressViewModel.isPractiseMode ?
                  (_theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].isAnsweredCorrectly ?
                  Colors.lightGreen[500] : Colors.red) :
                  (_theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].isAnsweredCorrectly ?
                  Colors.lightGreen[500] : Colors.red),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier),
                  child: Text(question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                child: _theoryProgressViewModel.isPractiseMode ?
                (_theoryProgressViewModel.practisePerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].isAnsweredCorrectly ?
                Icon(Icons.check, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,) :
                Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,)) :
                (_theoryProgressViewModel.mockPerformanceList.list[widget._index].testQuestionList.list[_theoryProgressViewModel.flagList[widget._index][index]].isAnsweredCorrectly ?
                Icon(Icons.check, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,) :
                Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,)),
              )
            ],
          );
        },
      ) : Padding(
        padding: EdgeInsets.all(3.125 * SizeConfig.heightSizeMultiplier),
        child: Text(!_theoryProgressViewModel.isPractiseMode ? AppLocalization.of(context).getTranslatedValue("no_flagged_answer_mock") :
        AppLocalization.of(context).getTranslatedValue("no_flagged_answer"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),),
      ),
    );
  }



  @override
  void dispose() {
    _theoryProgressViewModel.resetCurrentTab();
    super.dispose();
  }
}
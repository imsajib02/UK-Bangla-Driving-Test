import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/theory_progress_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:touchable/touchable.dart';


class ProgressAnimation extends StatefulWidget {

  final List<Offset> _offsets;

  ProgressAnimation(this._offsets);

  @override
  State<StatefulWidget> createState() => _ProgressAnimationState();
}


class _ProgressAnimationState extends State<ProgressAnimation> with TickerProviderStateMixin {

  TheoryProgressViewModel _theoryProgressViewModel;
  SettingsViewModel _settingsViewModel;

  double _progress = 0.0;
  Animation<double> animation;



  @override
  void initState() {

    var controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    animation = Tween(begin: 1.0, end: 0.0).animate(controller)..addListener(() {

      setState(() {
        _progress = animation.value;
      });
    });

    controller.forward();

    super.initState();
  }



  @override
  void didChangeDependencies() {

    _theoryProgressViewModel = Provider.of<TheoryProgressViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(math.pi),
      child: CanvasTouchDetector(
        builder: (context) =>
            CustomPaint(
              foregroundPainter: ProgressPainter(context, _progress, widget._offsets, _theoryProgressViewModel, _settingsViewModel),
            )
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
  }
}



class ProgressPainter extends CustomPainter {

  double _progress;
  List<Offset> _offsets;
  BuildContext _context;
  TheoryProgressViewModel _theoryProgressViewModel;
  SettingsViewModel _settingsViewModel;


  ProgressPainter(this._context, this._progress, this._offsets, this._theoryProgressViewModel, this._settingsViewModel);

  @override
  void paint(Canvas canvas, Size size) {

    var myCanvas = TouchyCanvas(_context, canvas);

    //horizontal max length = 280. Per label 30
    //vertical max length = 300. 10 label per label 30

    final Paint circlePainter = Paint()..color = Colors.lightGreen[500];
    final Paint linePainter = Paint()..color = Colors.black..strokeWidth = 4..strokeCap = StrokeCap.round;

    for(int i=0; i<_offsets.length; i++) {

      if(i > 0) {

        canvas.drawLine(_offsets[i-1], _offsets[i], linePainter);

        //canvas.drawLine(_offsets[i-1], Offset(_offsets[i].dx - (_offsets[i].dx * _progress), _offsets[i].dy - (_offsets[i].dy * _progress)), linePainter);
      }
    }

    for(int i=0; i<_offsets.length; i++) {

      //canvas.drawCircle(_offsets[i], 10.0, circlePainter);

      myCanvas.drawCircle(_offsets[i], 2.82 * SizeConfig.imageSizeMultiplier, circlePainter, onTapDown: (detail) {

            Provider.of<SettingsViewModel>(_context).playSound();
            _onCircleTap(i);
          }
      );
    }

    //canvas.drawLine(Offset(0.0, 30.0 * 3), Offset((15.0 * 2) - (15.0 * 2) * _progress, (80.0 * 3) - (80.0 * 3) * _progress), linePainter);
    //canvas.drawLine(new Offset(70.0, 240.0), new Offset(50.0, 100.0), linePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


  void _onCircleTap(int index) async {

    return showGeneralDialog(
        context: _context,
        barrierDismissible: false,
        barrierColor: Colors.white,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

          return WillPopScope(
            onWillPop: () {
              Navigator.of(_context).pop();
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
                    child: _practiseInfo(index),
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


  Column _practiseInfo(int index) {

    String totalQuestion = "";
    String totalCorrect = "";
    String totalIncorrect = "";

    if(_settingsViewModel.isEnglish) {

      if(_theoryProgressViewModel.isPractiseMode) {

        totalQuestion = _theoryProgressViewModel.practisePerformanceList.list[index].testQuestionList.list.length.toString();
      }
      else {

        totalQuestion = _theoryProgressViewModel.mockPerformanceList.list[index].testQuestionList.list.length.toString();
      }

      totalCorrect = _theoryProgressViewModel.totalCorrect[index].length.toString();
      totalIncorrect = _theoryProgressViewModel.totalIncorrect[index].length.toString();
    }
    else {

      if(_theoryProgressViewModel.isPractiseMode) {

        totalQuestion = _translateNumber(_theoryProgressViewModel.practisePerformanceList.list[index].testQuestionList.list.length);
      }
      else {

        totalQuestion = _translateNumber(_theoryProgressViewModel.mockPerformanceList.list[index].testQuestionList.list.length);
      }

      totalCorrect = _translateNumber(_theoryProgressViewModel.totalCorrect[index].length);
      totalIncorrect = _translateNumber(_theoryProgressViewModel.totalIncorrect[index].length);
    }

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
              Provider.of<SettingsViewModel>(_context).playSound();
              Navigator.of(_context).pop();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(_theoryProgressViewModel.isPractiseMode ? AppLocalization.of(_context).getTranslatedValue("practise_session") :
            AppLocalization.of(_context).getTranslatedValue("mock_session"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(_context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 10,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(left: 3.84 * SizeConfig.widthSizeMultiplier, top: 2.5 * SizeConfig.heightSizeMultiplier),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 2.56 * SizeConfig.widthSizeMultiplier,
                          backgroundColor: Colors.lightGreen[500],
                          child: Image(image: AssetImage(Images.questionIcon), width: 3.07 * SizeConfig.widthSizeMultiplier, height: 1.5 * SizeConfig.heightSizeMultiplier,
                            color: Colors.white,),
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(_settingsViewModel.isEnglish ? _theoryProgressViewModel.countryList[index] : _theoryProgressViewModel.countryBanglaList[index],
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 2.56 * SizeConfig.imageSizeMultiplier,
                          backgroundColor: Colors.lightGreen[500],
                          child: Image(image: AssetImage(Images.questionIcon), width: 3.07 * SizeConfig.widthSizeMultiplier, height: 1.5 * SizeConfig.heightSizeMultiplier,
                            color: Colors.white,),
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(totalQuestion,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: Icon(Icons.star, color: Colors.yellow[700], size: 5.64 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(AppLocalization.of(_context).getTranslatedValue("score") + (_settingsViewModel.isEnglish ? _theoryProgressViewModel.scoreList[index] :
                        _theoryProgressViewModel.scoreBanglaList[index]),
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: Icon(Icons.check_circle_outline, color: Colors.lightGreen[600], size: 5.64 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(AppLocalization.of(_context).getTranslatedValue("correct") + ": " + totalCorrect,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: Icon(Icons.cancel, color: Colors.red[400], size: 5.64 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(AppLocalization.of(_context).getTranslatedValue("incorrect") + ": " + totalIncorrect,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: Icon(Icons.thumb_up, color: Colors.lightGreen[500], size: 4.61 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(AppLocalization.of(_context).getTranslatedValue("best_category") + (_settingsViewModel.isEnglish ? _theoryProgressViewModel.bestCategoryList[index] :
                        _theoryProgressViewModel.bestCategoryBanglaList[index]),
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    children: <Widget>[

                      Flexible(
                        flex: 1,
                        child: Icon(Icons.thumb_down, color: Colors.lightGreen[500], size: 4.61 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),

                      SizedBox(width: 3.07 * SizeConfig.widthSizeMultiplier),

                      Flexible(
                        flex: 6,
                        child: Text(AppLocalization.of(_context).getTranslatedValue("worst_category") + (_settingsViewModel.isEnglish ? _theoryProgressViewModel.worstCategoryList[index] :
                        _theoryProgressViewModel.worstCategoryBanglaList[index]),
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(_context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                    child: Text(AppLocalization.of(_context).getTranslatedValue("review_answers"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(_context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(_context).playSound();
                    Navigator.of(_context).pop();
                    Navigator.of(_context).pushNamed(RouteManager.PROGRESS_ANSWER_REVIEW_PAGE_ROUTE, arguments: index);
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
                    child: Text(AppLocalization.of(_context).getTranslatedValue("continue"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(_context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(_context).playSound();
                    Navigator.of(_context).pop();
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  String _translateNumber(int index) {

    String indexInBangla = "";

    for(int i=0; i<index.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(index.toString()[i] == Constants.englishNumeric[j]) {

          indexInBangla = indexInBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return indexInBangla;
  }
}
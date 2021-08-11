import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/interace/video_flag_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/video_flag_painter.dart';
import 'package:ukbangladrivingtest/view_model/hazard_practise_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/score_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class VideoPractiseView extends StatefulWidget {

  final String _clipUrl;

  VideoPractiseView(this._clipUrl);

  @override
  _VideoPractiseViewState createState() => _VideoPractiseViewState();
}


class _VideoPractiseViewState extends State<VideoPractiseView> implements VideoFlagInterface {

  HazardPractiseViewModel _hazardPractiseViewModel;
  SettingsViewModel _settingsViewModel;
  VideoFlagInterface _flagInterface;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayer;

  List<Offset> _offsetList = List();


  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _flagInterface = this;

    SystemChrome.setEnabledSystemUIOverlays([]);

    _controller = VideoPlayerController.network(widget._clipUrl, useCache: true);
    _initializeVideoPlayer = _controller.initialize();

    _initializeVideoPlayer.then((_)  {

      _controller.play();
    });

    _controller.addListener(_isFinishedPlaying);

    _controller.setVolume(1.0);
    _controller.setLooping(false);

    super.initState();
  }


  @override
  void didChangeDependencies() {

    _hazardPractiseViewModel = Provider.of<HazardPractiseViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeVideoPlayer,
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.done) {

              return Stack(
                children: <Widget>[

                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      margin: EdgeInsets.only(left: 20 * SizeConfig.widthSizeMultiplier, right: 20 * SizeConfig.widthSizeMultiplier,
                          bottom: 5 * SizeConfig.heightSizeMultiplier),
                      child: VideoPlayer(_controller),
                    ),
                    onTap: () {
                      //Provider.of<SettingsViewModel>(context).playSound();
                      _hazardPractiseViewModel.onTap(_controller.value.position, _flagInterface);
                    },
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 5 * SizeConfig.heightSizeMultiplier,
                      width: double.infinity,
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier,
                          left: 2.05 * SizeConfig.widthSizeMultiplier, right: 2.05 * SizeConfig.widthSizeMultiplier),
                      child: CustomPaint(foregroundPainter: FlagPainter(_offsetList)),
                    ),
                  ),

                  GestureDetector(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.125 * SizeConfig.heightSizeMultiplier, left: 25.64 * SizeConfig.widthSizeMultiplier),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 4.10 * SizeConfig.imageSizeMultiplier,
                          child: Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      //Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _controller.pause();
                      _onClose(_quitAlert());
                    },
                  ),
                ],
              );
            }
            else {

              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black87,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }


  void _isFinishedPlaying() {

    if(_controller.value.position == _controller.value.duration) {

      _hazardPractiseViewModel.calculateScore(_flagInterface);
      _controller.removeListener(_isFinishedPlaying);
    }
  }


  @override
  dispose(){

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    _controller.removeListener(_isFinishedPlaying);
    _controller.dispose();

    super.dispose();
  }


  @override
  void setFlag(Offset offset) {

    setState(() {
      _offsetList.add(offset);
    });
  }


  @override
  void onPractiseComplete() {

    _onClose(_reviewAlert());
  }


  void _onClose(Widget content) async {

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
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                  top: 3.75 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
              ),
              child: content,
            ),
          );
        }
    );
  }


  Stack _quitAlert() {

    return Stack(
      children: <Widget>[

        Column(
          children: <Widget>[

            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier),
                child: Text(AppLocalization.of(context).getTranslatedValue("cancel_play"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 5 * SizeConfig.heightSizeMultiplier, right: 5 * SizeConfig.heightSizeMultiplier),
                child: Text(AppLocalization.of(context).getTranslatedValue("cancel_play_message"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),

            Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Flexible(
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 6.25 * SizeConfig.heightSizeMultiplier,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(AppLocalization.of(context).getTranslatedValue("resume"),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          //Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _continue();
                        },
                      ),
                    ),

                    Flexible(
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 6.25 * SizeConfig.heightSizeMultiplier,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(AppLocalization.of(context).getTranslatedValue("quit"),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          //Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _quitPractise();
                        },
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(2 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.75 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              //Provider.of<SettingsViewModel>(context, listen: false).playSound();
              _continue();
            },
          ),
        ),
      ],
    );
  }


  Stack _reviewAlert() {

    return Stack(
      children: <Widget>[

        Column(
          children: <Widget>[

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier),

            Expanded(
              flex: 3,
              child: Container(
                width: 51.28 * SizeConfig.widthSizeMultiplier,
                decoration: BoxDecoration(
                  image: DecorationImage(image: MemoryImage(_hazardPractiseViewModel.thumbnails[_hazardPractiseViewModel.selectedVideoIndex]), fit: BoxFit.fill),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(AppLocalization.of(context).getTranslatedValue("you_scored") + (_settingsViewModel.isEnglish ?
                _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].score.toString() : AppLocalization.of(context).getTranslatedValue("5")) +
                    (_settingsViewModel.isEnglish ? AppLocalization.of(context).getTranslatedValue("out_of") : AppLocalization.of(context).getTranslatedValue("of")) +
                    (_settingsViewModel.isEnglish ? AppLocalization.of(context).getTranslatedValue("5") :
                _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].scoreInBangla),
                  textAlign: TextAlign.center,
                  style:Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(size: 9.48 * SizeConfig.imageSizeMultiplier),
                  child: ScoreBar(_hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].score),
                ),
              ),
            ),

            Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    width: 76.92 * SizeConfig.widthSizeMultiplier,
                    height: 5.5 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("review_clip"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pushNamed(RouteManager.CLIP_REVIEW_PAGE_ROUTE, arguments: widget._clipUrl);
                  },
                ),
            ),

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier),
          ],
        ),

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(2 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.75 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              _quitPractise();
            },
          ),
        ),
      ],
    );
  }


  void _continue() {

    Navigator.of(context).pop();
    _controller.play();
  }


  void _quitPractise() {

    Navigator.of(context).pop();
    Navigator.pop(context);
  }
}
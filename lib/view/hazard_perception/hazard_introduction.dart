import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class HazardIntroduction extends StatefulWidget {

  @override
  _HazardIntroductionState createState() => _HazardIntroductionState();
}


class _HazardIntroductionState extends State<HazardIntroduction> {

  VideoPlayerController _controller;
  IconData _icon = Icons.pause;
  Future<void> _initializeVideoPlayer;


  @override
  void initState() {

    _controller = VideoPlayerController.network(
        'https://driving.b2gsoft.com/clips/Clip-1.ts', useCache: true);
    _initializeVideoPlayer = _controller.initialize();

    _initializeVideoPlayer.then((_) {

      _controller.play();
      print(_controller.value.duration);
    });

    _controller.addListener(_isFinishedPlaying);

    _controller.setVolume(1.0);
    _controller.setLooping(false);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPress,
      child: SafeArea(
        child: Scaffold(
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
                        padding: EdgeInsets.only(left: 10.25 * SizeConfig.widthSizeMultiplier, right: 10.25 * SizeConfig.widthSizeMultiplier,
                            bottom: 5 * SizeConfig.heightSizeMultiplier, top: 6.25 * SizeConfig.heightSizeMultiplier),
                        child: VideoPlayer(_controller),
                      ),
                      onTap: () {
                        Provider.of<SettingsViewModel>(context, listen: false).playSound();
                        _onVideoTap();
                      },
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 5 * SizeConfig.heightSizeMultiplier,
                        width: double.infinity,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 10.25 * SizeConfig.widthSizeMultiplier, right: 10.25 * SizeConfig.widthSizeMultiplier),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 5 * SizeConfig.heightSizeMultiplier,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 3.85 * SizeConfig.imageSizeMultiplier,
                                child: Icon(Icons.arrow_back, color: Colors.black,),
                              ),
                              onTap: () {
                                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                _onBackPress();
                              },
                            ),
                          ),

                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppLocalization.of(context).getTranslatedValue("introduction"),
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: Icon(_icon, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.white,),
                              onTap: () {
                                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                _onVideoTap();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
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
      ),
    );
  }


  void _onVideoTap() {

    if(_controller.value.position == _controller.value.duration) {

      setState(() {
        _controller.seekTo(Duration.zero);
        _controller.play();
      });
    }
    else {

      setState(() {

        if(_controller.value.isPlaying) {

          _controller.pause();
          _icon = Icons.play_arrow;
        }
        else {

          _controller.play();
          _icon = Icons.pause;
        }
      });
    }
  }


  void _isFinishedPlaying() {

    if(_controller.value.position == _controller.value.duration) {

      setState(() {
        _icon = Icons.play_arrow;
      });
    }
    else {
      setState(() {
        _icon = Icons.pause;
      });
    }
  }


  Future<bool> _onBackPress() {

    Navigator.pop(context);
    return Future.value(false);
  }


  @override
  dispose(){
    _controller.removeListener(_isFinishedPlaying);
    _controller.dispose();
    super.dispose();
  }
}
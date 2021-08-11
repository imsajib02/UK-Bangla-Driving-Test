import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayer = _controller.initialize();

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

                _controller.play();

                return Stack(
                  children: <Widget>[

                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black87,
                        margin: EdgeInsets.only(top: 50, bottom: 40, right: 40),
                        child: VideoPlayer(_controller),
                      ),
                      onTap: () {
                        _onVideoTap();
                      },
                    ),

                    Container(
                      width: double.infinity,
                      height: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(Icons.arrow_back, color: Colors.black,),
                              ),
                              onTap: () {
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
                              child: Icon(_icon, size: 35, color: Colors.white,),
                              onTap: () {
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

    if(_controller.value.isPlaying) {

      _controller.pause();

      setState(() {
        _icon = Icons.pause;
      });
    }
    else {

      _controller.play();

      setState(() {
        _icon = Icons.play_arrow;
      });
    }
  }


  Future<bool> _onBackPress() {

    dispose();
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.HAZARD_PERCEPTION_PAGE_ROUTE);
    return Future.value(false);
  }


  @override
  dispose(){
    _controller.dispose();
    super.dispose();
  }
}
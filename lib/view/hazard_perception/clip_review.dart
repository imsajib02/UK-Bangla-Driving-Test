import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/video_flag_painter.dart';
import 'package:ukbangladrivingtest/view_model/hazard_practise_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class CipReview extends StatefulWidget {

  final String _clipUrl;

  CipReview(this._clipUrl);

  @override
  _CipReviewState createState() => _CipReviewState();
}


class _CipReviewState extends State<CipReview> {

  HazardPractiseViewModel _hazardPractiseViewModel;
  SettingsViewModel _settingsViewModel;

  IconData _button = Icons.play_arrow;

  double _progress = 0.0;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayer;

  String _description = "";

  List<Offset> _offsetList = List();


  @override
  void initState() {

    _controller = VideoPlayerController.network(widget._clipUrl, useCache: true);

    _initializeVideoPlayer = _controller.initialize();

    _initializeVideoPlayer.then((_)  {

      _controller.play();
    });

    _controller.addListener(_isPlaying);
    _controller.addListener(_showProgress);
    _controller.addListener(_isPositionFlagged);
    _controller.addListener(_showDescription);

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

                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    margin: EdgeInsets.only(left: 20 * SizeConfig.widthSizeMultiplier, right: 20 * SizeConfig.widthSizeMultiplier,
                        bottom: 5 * SizeConfig.heightSizeMultiplier),
                    child: Stack(
                      children: <Widget>[

                        VideoPlayer(_controller),

                        Center(
                          child: GestureDetector(
                            child: Icon(_button, size: 12.82 * SizeConfig.imageSizeMultiplier, color: Colors.grey[300]),
                            onTap: () {
                              //Provider.of<SettingsViewModel>(context, listen: false).playSound();
                              _onButtonTap();
                            },
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 5 * SizeConfig.heightSizeMultiplier,
                            child: Slider(
                              value: _progress,
                              activeColor: Colors.red,
                              inactiveColor: Colors.white,
                              onChanged: (value) {
                                //_updateProgress(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 5 * SizeConfig.heightSizeMultiplier,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[

                          Visibility(
                            visible: false,
                            child: Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(.25 * SizeConfig.heightSizeMultiplier),
                                child: Text(_description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: false,
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.black54,
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier,
                                  left: 2.05 * SizeConfig.widthSizeMultiplier, right: 2.05 * SizeConfig.widthSizeMultiplier),
                              child: CustomPaint(foregroundPainter: FlagPainter(_offsetList, rangeList: _hazardPractiseViewModel.rangeList, rangeWidth: _hazardPractiseViewModel.perBlock)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.125 * SizeConfig.heightSizeMultiplier, right: 25.64 * SizeConfig.widthSizeMultiplier),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 4.10 * SizeConfig.imageSizeMultiplier,
                          child: Icon(Icons.cancel, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      Navigator.pop(context);
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


  void _isPlaying() {

    if(_controller.value.isPlaying) {

      setState(() {
        _button = Icons.pause;
      });
    }
    else {

      setState(() {
        _button = Icons.play_arrow;
      });
    }
  }


  void _showProgress() {

    if(_controller.value.initialized) {

      double perBlock = .977 / _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].clipDuration.inSeconds;

      setState(() {

        if(perBlock * _controller.value.position.inSeconds >= 1.0) {

          _progress = 1.0;
        }
        else {

          _progress = perBlock * _controller.value.position.inSeconds;
        }
      });
    }
  }


  void _isPositionFlagged() {

    for(int i=0; i<_hazardPractiseViewModel.secondFlags.length; i++) {

      if(_hazardPractiseViewModel.secondFlags.elementAt(i) == _controller.value.position.inSeconds) {

        print(_controller.value.position.inSeconds);

        double perBlock = (205.1 * SizeConfig.widthSizeMultiplier) /
            _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].clipDuration.inSeconds;

        setState(() {
          _offsetList.add(Offset((perBlock * _controller.value.position.inSeconds) - (perBlock / 2), 0.0));
        });
      }
    }
  }


  void _showDescription() {

    for(int i=0; i<_hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList.length; i++) {

      int startFrameInSec = _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList[i].startFrame.inSeconds;
      int endFrameInSec = _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList[i].endFrame.inSeconds;

      if(_controller.value.position.inSeconds == startFrameInSec) {

        setState(() {
          _description = _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList[i].description;
        });

        _hazardPractiseViewModel.speak(_settingsViewModel.isEnglish ? _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList[i].description :
        _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].detailsList[i].descriptionBangla, _settingsViewModel.isEnglish);
      }
      else if(_controller.value.position.inSeconds == endFrameInSec) {

        setState(() {
          _description = "";
        });

        _hazardPractiseViewModel.removeSpokeStatus();
      }
    }
  }


  void _onButtonTap() {

    if(_controller.value.isPlaying) {
      _controller.pause();
    }
    else {

      if(_controller.value.position == _controller.value.duration) {

        _controller.seekTo(Duration.zero);
      }

      _controller.play();
    }
  }


  void _updateProgress(double value) {

    int sec = 0;
    int milliSec = 0;

    int durationInSec = _hazardPractiseViewModel.storedHazardClips.clipList[_hazardPractiseViewModel.selectedVideoIndex].clipDuration.inSeconds;

    double position = (value * durationInSec) / .977;

    if(position >= durationInSec) {

      sec = durationInSec;
    }
    else {

      sec = position.floor();
      milliSec = ((position - position.truncate()) * 1000).truncate();
    }

    setState(() {
      //_progress = value;
    });

    print(Duration(seconds: sec, milliseconds: milliSec));

    //_controller.seekTo(Duration(seconds: 8, milliseconds: 0));
  }


  @override
  dispose(){

    _hazardPractiseViewModel.stopSpeaking();

    _controller.removeListener(_showDescription);
    _controller.removeListener(_showProgress);
    _controller.removeListener(_isPlaying);
    _controller.removeListener(_isPositionFlagged);
    _controller.dispose();

    super.dispose();
  }
}
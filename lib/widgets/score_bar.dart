import 'package:flutter/material.dart';


class ScoreBar extends StatefulWidget {

  final int score;

  ScoreBar(this.score);

  @override
  _ScoreBarState createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar> {

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {

        return Icon((index+1) <= widget.score ? Icons.star : Icons.star_border, color: (index+1) <= widget.score ? Colors.yellow[500] : Colors.grey);
      }),
    );
  }
}
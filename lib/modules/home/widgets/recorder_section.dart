import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sound_recorder/stores/recorder/recorder_store.dart';
import 'package:sound_recorder/utils/visualizer_painter.dart';

class RecorderSection extends StatefulWidget {
  final RecorderStore recorderStore;

  RecorderSection({this.recorderStore});

  @override
  _RecorderSectionState createState() => _RecorderSectionState();
}

class _RecorderSectionState extends State<RecorderSection>  with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    );
    //_startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Observer(
        name: 'recorder_section_observer',
        builder: (context) {
          bool isRecording = widget.recorderStore.isRecording;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Observer(builder: (context) {
                  String recorderText = widget.recorderStore.recorderTxt;
                  print('recorderText $recorderText');
                  double dbLevel = widget.recorderStore.dbLevel;
                  print('dbLevel $dbLevel');
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0.0, bottom: 16.0),
                        child: Text(
                          recorderText,
                          style: TextStyle(
                            fontSize: 45.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 50.0,),
                Row(
                  children: <Widget>[
                    CustomPaint(
                      painter: isRecording ? SpritePainter(_controller) : null,
                      child: IconButton(
                        iconSize: 100.0,
                        onPressed:() {
                          widget.recorderStore.onStartRecorderPressed();
                            _startAnimation();
                        },
                        icon: Icon(
                          isRecording ? Icons.mic_off : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    /// TODO - can be used this to pause recording...
                    // ClipOval(
                    //   child: IconButton(
                    //       iconSize: 40.0,
                    //       onPressed: recorderStore.onPauseResumeRecorderPressed,
                    //       disabledColor: Colors.white,
                    //       icon: Icon(
                    //         isRecording
                    //             ? Icons.pause_circle_outline
                    //             : Icons.pause_circle_filled,
                    //         color: Colors.white,
                    //       )),
                    // ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ]);
        });
  }
}

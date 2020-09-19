import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sound_recorder/stores/recorder/recorder_store.dart';

class PlayerSection extends StatelessWidget {
  final RecorderStore recorderStore;

  PlayerSection({this.recorderStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
        name: 'player_section_observer',
        builder: (context) {
          PlayerState playerState = recorderStore.playerState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0,),
              Observer(builder: (context) {
                String playerTxt = recorderStore.playerTxt;
                return Container(
                  margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                  child: Text(
                    playerTxt,
                    style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.white,
                    ),
                  ),
                );
              }),

              Row(
                children: <Widget>[
                  IconButton(
                    iconSize: 50.0,
                    onPressed: recorderStore.onStartPlayerPressed,
                    icon: Icon(
                      playerState == PlayerState.isPlaying ? Icons.play_circle_outline : Icons.play_circle_filled,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    iconSize: 50.0,
                    onPressed: recorderStore.onPauseResumePlayerPressed,
                    icon: Icon(
                      playerState == PlayerState.isPlaying ? Icons.pause_circle_outline : Icons.pause_circle_filled,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    iconSize: 50.0,
                    onPressed: recorderStore.onStopPlayerPressed,
                    icon: Icon(
                      Icons.stop,
                      color: Colors.white,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              SizedBox(height: 20.0,),
              Observer(
                  name: 'play_slider_observer',
                  builder: (context) {
                    double sliderCurrentPosition =
                        recorderStore.sliderCurrentPosition;
                    double maxDuration = recorderStore.maxDuration;
                    return Container(
                        height: 30.0,
                        child: Slider(
                            value: min(sliderCurrentPosition, maxDuration),
                            min: 0.0,
                            max: maxDuration,
                            onChanged: (double value) async {
                              await recorderStore.playerModule.seekToPlayer(
                                  Duration(milliseconds: value.toInt()));
                            },
                            divisions:
                                maxDuration == 0.0 ? 1 : maxDuration.toInt()));
                  }),
              Container(
                height: 30.0,
                child: Text(recorderStore.duration != null
                    ? "Duration: ${recorderStore.duration} sec."
                    : ''),
              ),
            ],
          );
        });
  }
}

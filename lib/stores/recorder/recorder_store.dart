import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sound_recorder/models/enums.dart';
import 'package:sounds/sounds.dart';
part 'recorder_store.g.dart';

///https://bsutton.gitbook.io/sounds/soundplayer#monitoring
class RecorderStore = _RecorderStore with _$RecorderStore;

abstract class _RecorderStore with Store {
  String recordingFile;
  Track track;
  BuildContext context;
  SoundRecorder recorderModule = SoundRecorder();
  SoundPlayer playerModule = SoundPlayer.noUI();
  Stream<RecordingDisposition> _recorderSubscription;
  Stream<PlaybackDisposition> _playerSubscription;

  @observable
  bool isRecording = false;

  @observable
  PlayState playerState = PlayState.isStopped;

  @observable
  String recorderTxt = '00:00:00';

  @observable
  String playerTxt = '00:00:00';

  @observable
  double dbLevel = 0.0;

  @observable
  double duration = 0.0;

  @observable
  double maxDuration = 1.0;

  @observable
  double sliderCurrentPosition = 0.0;

  setContext(BuildContext c) => context = c;

  @action
  setIsRecording(bool r) => isRecording = r;

  @action
  setRecorderText(String t) => recorderTxt = t;

  @action
  setPlayerText(String p) => playerTxt = p;

  @action
  setDBLevel(double d) => dbLevel = d;

  @action
  setDuration(double d) => duration = d;

  @action
  setPlayState(PlayState p) => playerState = p;

  Future<void> init(BuildContext ctx) async {
    setContext(ctx);
    recordingFile = Track.tempFile(WellKnownMediaFormats.adtsAac);
    track = Track.fromFile(recordingFile,
        mediaFormat: WellKnownMediaFormats.adtsAac);
    track.artist = 'By Vijay Rathod';
    _recorderSubscription =
        recorderModule.dispositionStream(interval: Duration(milliseconds: 100));
    _playerSubscription = playerModule.dispositionStream();
    await _initializeExample();
  }

  Future<void> _initializeExample() async {
    await initializeDateFormatting();
    _addListners();
  }

  void startRecorder() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        SnackBar snackBar = SnackBar(
            content: Text('Recording cannot start as you did not allow '
                'the required permissions'));

        // Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
      }
      setIsRecording(true);
      await recorderModule.record(track);
      print('startRecorder');
    } catch (err) {
      print('startRecorder error: $err');
      stopRecorder();
      setIsRecording(false);
    }
  }

  void stopRecorder() async {
    try {
      await recorderModule.stop();
      print('stopRecorder');
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setIsRecording(false);
  }

  Future<void> startPlayer() async {
    try {
      setPlayState(PlayState.isPlaying);
      playerModule.onStopped = ({wasUser}) => setPlayState(PlayState.isStopped);

      await playerModule.play(track);
    } catch (err) {
      setPlayState(PlayState.isStopped);
      print('error: $err');
    }
  }

  Future<void> stopPlayer(bool wasUser) async {
    try {
      await playerModule.stop(wasUser: wasUser);
      setPlayState(PlayState.isStopped);
      sliderCurrentPosition = 0.0;
    } catch (err) {
      print('error: $err');
    }
  }

  void onStartRecorderPressed() {
    if (recorderModule == null) return null;
    if (recorderModule.isRecording || recorderModule.isPaused) {
      stopRecorder();
    } else {
      startRecorder();
    }
  }

  void Function() onPauseResumeRecorderPressed() {
    if (recorderModule == null) return null;
    if (recorderModule.isPaused || recorderModule.isRecording) {
      if (recorderModule.isPaused) {
        recorderModule.resume();
      } else {
        recorderModule.pause();
      }
    }
    return null;
  }

  void onStartPlayerPressed() {
    if (playerModule.isStopped) startPlayer();
  }

  void onPauseResumePlayerPressed() {
    if (playerModule.isPaused || playerModule.isPlaying) pauseResumePlayer();
  }

  void onStopPlayerPressed() {
    if (playerModule.isPlaying || playerModule.isPaused) stopPlayer(true);
  }

  void pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pause();
    } else {
      playerModule.resume();
    }
  }

  void pauseResumeRecorder() {
    if (recorderModule.isPaused) {
      recorderModule.resume();
    } else {
      recorderModule.pause();
    }
  }

  void _addListners() {
    _recorderSubscription.listen((disposition) {
      print(
          '_recorderSubscription ${disposition.duration} and ${disposition.decibels}');
      if (e != null && disposition.duration != null) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
            disposition.duration.inMilliseconds,
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        print(txt + ' ' + disposition.decibels.toString());
        setRecorderText(txt?.substring(0, 8));
        setDBLevel(disposition.decibels);
      }
    });
    _playerSubscription.listen((e) {
      if (e != null) {
        print('_playerSubscription ${e.duration}');
        maxDuration = e.duration.inMilliseconds.toDouble();
        if (maxDuration <= 0) maxDuration = 0.0;

        sliderCurrentPosition =
            min(e.position.inMilliseconds.toDouble(), maxDuration);
        if (sliderCurrentPosition < 0.0) {
          sliderCurrentPosition = 0.0;
        }

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.position.inMilliseconds,
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        setPlayerText(txt.substring(0, 8));
      }
    });
  }

  void dispose() {
    if (recordingFile != null) {
      File(recordingFile).delete();
    }
    playerModule?.release();
    recorderModule?.release();
    if (_playerSubscription != null) _playerSubscription = null;
    if (_recorderSubscription != null) _recorderSubscription = null;
  }
}

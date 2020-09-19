import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sound_recorder/models/enums.dart';

part 'recorder_store.g.dart';

class RecorderStore = _RecorderStore with _$RecorderStore;

abstract class _RecorderStore with Store {
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  List<String> _path = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  Media _media = Media.file;
  int playerID;

  @observable
  bool isRecording = false;

  @observable
  PlayerState playerState = PlayerState.isStopped;

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

  // @observable
  Codec codec = Codec.aacADTS;

  @observable
  bool encoderSupported = true; // Optimist

  @observable
  bool decoderSupported = true; // Optimist

  @action
  setIsRecording(bool r) => isRecording = r;

  // @action
  setPath(int i, String p) {
    this._path[i] = p;
  }

  @action
  setRecorderText(String t) => recorderTxt = t;

  @action
  setPlayerText(String p) => playerTxt = p;

  @action
  setDBLevel(double d) => dbLevel = d;

  @action
  setDuration(double d) => duration = d;

  @action
  setPlayerState(PlayerState p) => playerState = p;

  // @action
  Future<void> setCodec(Codec c) async {
    encoderSupported = await recorderModule.isEncoderSupported(c);
    decoderSupported = await playerModule.isDecoderSupported(c);
    codec = c;
  }

  Future<void> init() async {
    //playerModule = await FlutterSoundPlayer().openAudioSession();
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    recorderModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _initializeExample();
  }

  Future<void> _initializeExample() async {
    await playerModule.closeAudioSession();
    await playerModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
    await recorderModule.setSubscriptionDuration(Duration(milliseconds: 10));
    initializeDateFormatting();
    setCodec(codec);
  }

  void startRecorder() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException("Microphone permission not granted");
      }
      playerID = 100;

      Directory tempDir = await getTemporaryDirectory();
      String path =
          '${tempDir.path}/${recorderModule.slotNo}-flutter_sound${ext[codec.index]}';
      print(path);
      print(tempDir.path);
      print(recorderModule.slotNo);
      setIsRecording(true);
      await recorderModule.startRecorder(
        toFile: path,
        codec: codec,
        bitRate: 8000,
        sampleRate: 8000,
      );
      print('startRecorder');
      setPath(codec.index, path);
      _recorderSubscription = recorderModule.onProgress.listen((e) {
        print('_recorderSubscription ${e.duration} and ${e.decibels}');
        if (e != null && e.duration != null) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          print(txt + ' ' + e.decibels.toString());
          setRecorderText(txt?.substring(0, 8));
          setDBLevel(e.decibels);
        }
      });
    } catch (err) {
      print('startRecorder error: $err');
      stopRecorder();
      setIsRecording(false);
      cancelRecorderSubscriptions();
    }
  }

  void stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder');
      cancelRecorderSubscriptions();
      getDuration();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setIsRecording(false);
  }

  Future<void> startPlayer() async {
    print('start player called');
    try {
      //String path;
      Uint8List dataBuffer;
      String audioFilePath;
      print('_media file ${_media}');
      if (_media == Media.file) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[codec.index]))
          audioFilePath = this._path[codec.index];
      }
      if (audioFilePath != null) {
        await playerModule.startPlayer(
            fromURI: audioFilePath,
            codec: codec,
            whenFinished: () {
              print('Play finished');
              setPlayerState(PlayerState.isStopped);
            });
      }
      _addListeners();
      print('startPlayer');
      // await flutterSoundModule.setVolume(1.0);
    } catch (err) {
      print('error: $err');
    }
    setPlayerState(PlayerState.isPlaying);
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('stopPlayer');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {
      print('error: $err');
    }
    setPlayerState(PlayerState.isStopped);
  }

  Future<void> getDuration() async {
    Duration d = await flutterSoundHelper.duration(this._path[codec.index]);
    setDuration(d != null ? d.inMilliseconds / 1000.0 : 0.0);
  }

  void cancelRecorderSubscriptions() {
    print('cancelRecorderSubscriptions called');
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }



  void onStartRecorderPressed() {
    if (recorderModule == null || !encoderSupported) return null;
    if (recorderModule.isRecording || recorderModule.isPaused) {
      print('_______stopping now_______');
      stopRecorder();
    } else {
      print('_______starting now_______');
      startRecorder();
    }
  }

  void Function() onPauseResumeRecorderPressed() {
    if (recorderModule == null) return null;
    if (recorderModule.isPaused || recorderModule.isRecording) {
      if (recorderModule.isPaused) {
        recorderModule.resumeRecorder();
      } else {
        recorderModule.pauseRecorder();
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
    if (playerModule.isPlaying || playerModule.isPaused) stopPlayer();
  }

  void pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();
    } else {
      playerModule.resumePlayer();
    }
  }

  void pauseResumeRecorder() {
    if (recorderModule.isPaused) {
      recorderModule.resumeRecorder();
    } else {
      recorderModule.pauseRecorder();
    }
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      print('The file is ${contents.length} bytes long.');
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress.listen((e) {
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
    cancelPlayerSubscriptions();
    cancelRecorderSubscriptions();
    releaseFlauto();
  }

  Future<void> releaseFlauto() async {
    try {
      await playerModule.closeAudioSession();
      await recorderModule.closeAudioSession();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }
}

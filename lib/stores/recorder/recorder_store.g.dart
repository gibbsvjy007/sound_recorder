// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recorder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RecorderStore on _RecorderStore, Store {
  final _$isRecordingAtom = Atom(name: '_RecorderStore.isRecording');

  @override
  bool get isRecording {
    _$isRecordingAtom.reportRead();
    return super.isRecording;
  }

  @override
  set isRecording(bool value) {
    _$isRecordingAtom.reportWrite(value, super.isRecording, () {
      super.isRecording = value;
    });
  }

  final _$playerStateAtom = Atom(name: '_RecorderStore.playerState');

  @override
  PlayState get playerState {
    _$playerStateAtom.reportRead();
    return super.playerState;
  }

  @override
  set playerState(PlayState value) {
    _$playerStateAtom.reportWrite(value, super.playerState, () {
      super.playerState = value;
    });
  }

  final _$recorderTxtAtom = Atom(name: '_RecorderStore.recorderTxt');

  @override
  String get recorderTxt {
    _$recorderTxtAtom.reportRead();
    return super.recorderTxt;
  }

  @override
  set recorderTxt(String value) {
    _$recorderTxtAtom.reportWrite(value, super.recorderTxt, () {
      super.recorderTxt = value;
    });
  }

  final _$playerTxtAtom = Atom(name: '_RecorderStore.playerTxt');

  @override
  String get playerTxt {
    _$playerTxtAtom.reportRead();
    return super.playerTxt;
  }

  @override
  set playerTxt(String value) {
    _$playerTxtAtom.reportWrite(value, super.playerTxt, () {
      super.playerTxt = value;
    });
  }

  final _$dbLevelAtom = Atom(name: '_RecorderStore.dbLevel');

  @override
  double get dbLevel {
    _$dbLevelAtom.reportRead();
    return super.dbLevel;
  }

  @override
  set dbLevel(double value) {
    _$dbLevelAtom.reportWrite(value, super.dbLevel, () {
      super.dbLevel = value;
    });
  }

  final _$durationAtom = Atom(name: '_RecorderStore.duration');

  @override
  double get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(double value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  final _$maxDurationAtom = Atom(name: '_RecorderStore.maxDuration');

  @override
  double get maxDuration {
    _$maxDurationAtom.reportRead();
    return super.maxDuration;
  }

  @override
  set maxDuration(double value) {
    _$maxDurationAtom.reportWrite(value, super.maxDuration, () {
      super.maxDuration = value;
    });
  }

  final _$sliderCurrentPositionAtom =
      Atom(name: '_RecorderStore.sliderCurrentPosition');

  @override
  double get sliderCurrentPosition {
    _$sliderCurrentPositionAtom.reportRead();
    return super.sliderCurrentPosition;
  }

  @override
  set sliderCurrentPosition(double value) {
    _$sliderCurrentPositionAtom.reportWrite(value, super.sliderCurrentPosition,
        () {
      super.sliderCurrentPosition = value;
    });
  }

  final _$_RecorderStoreActionController =
      ActionController(name: '_RecorderStore');

  @override
  dynamic setIsRecording(bool r) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setIsRecording');
    try {
      return super.setIsRecording(r);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setRecorderText(String t) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setRecorderText');
    try {
      return super.setRecorderText(t);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPlayerText(String p) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setPlayerText');
    try {
      return super.setPlayerText(p);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDBLevel(double d) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setDBLevel');
    try {
      return super.setDBLevel(d);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDuration(double d) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setDuration');
    try {
      return super.setDuration(d);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPlayState(PlayState p) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.setPlayState');
    try {
      return super.setPlayState(p);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isRecording: ${isRecording},
playerState: ${playerState},
recorderTxt: ${recorderTxt},
playerTxt: ${playerTxt},
dbLevel: ${dbLevel},
duration: ${duration},
maxDuration: ${maxDuration},
sliderCurrentPosition: ${sliderCurrentPosition}
    ''';
  }
}

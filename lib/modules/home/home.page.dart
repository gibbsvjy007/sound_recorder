import 'package:flutter/material.dart';
import 'package:sound_recorder/stores/recorder/recorder_store.dart';
import 'widgets/player_section.dart';
import 'widgets/recorder_section.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RecorderStore recorderStore = RecorderStore();

  @override
  void initState() {
    super.initState();
    recorderStore.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorderStore.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(title: Text('Recording Demo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30.0,),
          RecorderSection(recorderStore: recorderStore,),
          SizedBox(height: 60.0,),
          PlayerSection(recorderStore: recorderStore,),
          SizedBox(height: 20.0,),
          Center(child: Text('By Vijay Rathod', style: TextStyle(fontSize: 20.0, color: Colors.grey.withOpacity(0.4)),))
        ],
      ),
    );
  }
}

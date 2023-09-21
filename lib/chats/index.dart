import 'dart:async';

//import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:elbekgram/chats/videocall.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value

  /// if channel textField is validated to have error
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Calling'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  ListTile(
                    title:
                    Text(ClientRoleType.clientRoleBroadcaster.toString()),
                    leading: Radio(
                      value: ClientRoleType.clientRoleBroadcaster,
                      groupValue: _role,
                      onChanged: (ClientRoleType? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(ClientRoleType.clientRoleAudience.toString()),
                    leading: Radio(
                      value: ClientRoleType.clientRoleAudience,
                      groupValue: _role,
                      onChanged: (ClientRoleType? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: const Text('Video Call'),
                    ),
                    // Expanded(
                    //   child: RaisedButton(
                    //     onPressed: onJoin,
                    //     child: Text('Join'),
                    //     color: Colors.blueAccent,
                    //     textColor: Colors.white,
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
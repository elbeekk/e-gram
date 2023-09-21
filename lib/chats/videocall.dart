import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blur/blur.dart';
import 'package:camera/camera.dart';
import 'package:elbekgram/chats/camerapicker.dart';
import 'package:elbekgram/helpers/api.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class VideoCall extends StatefulWidget {
  final String uid;
  final bool isVideo1;

  const VideoCall({super.key, required this.uid, required this.isVideo1});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final users = [];
  int? remoteUid;
  bool localUserJoined = false;
  bool muteSpeaker = false;
  bool muteMic = false;
  bool isVideo = false;
  bool loading = false;
  bool viewPanel = false;
  late RtcEngine engine;
  double xPosition = 10;
  double yPosition = 10;

  @override
  void initState() {
    initializeAgora();
    super.initState();
  }

  Future<void> initializeAgora() async {
    setState(() {
      loading = true;
    });
    engine = createAgoraRtcEngine();
    await engine.initialize(
      const RtcEngineContext(
        appId: "4bf28133d28647fbbc3e9f192dfcb1ee",
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    engine.joinChannel(
        token:
            '007eJxTYDhaI1GsPt/t5sJm4YaQgp3Ny2TEiusbA99d9X/c2/KumFOBwSQpzcjC0Ng4xcjCzMQ8LSkp2TjVMs3Q0iglLTnJMDV1OxN3akMgI0PwzkgmRgYIBPEZGcoZGADQhh27',
        channelId: API.getConversationId(widget.uid).toString(),
        uid: 0,
        options: const ChannelMediaOptions());
    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        setState(() {
          localUserJoined = true;
        });
        debugPrint('Channel joined');
      },
      onUserJoined: (connection, uid, elapsed) {
        debugPrint('Joined user uid $uid');
          remoteUid = uid;
      },
      onUserOffline: (connection, uid, reason) {
        debugPrint('UserOffline $uid');
        remoteUid = null;

        },
    ));
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (isVideo) await engine.enableVideo();
    if (isVideo) await engine.enableLocalVideo(true);
    await engine.enableAudio();
    await engine.startPreview();
    setState(() {
      loading = false;
    });
    engine.release();
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      isVideo = widget.isVideo1;
    });
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 5,
            ),
            if (!isVideo)
              InkWell(
                onTap: () async {
                  await engine
                      .muteAllRemoteAudioStreams(!muteSpeaker)
                      .whenComplete(() {
                    setState(() {
                      muteSpeaker = !muteSpeaker;
                    });
                  });
                },
                child: Blur(
                    overlay: Icon(
                      !muteSpeaker
                          ? Ionicons.ios_volume_medium
                          : Ionicons.ios_volume_mute,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    blur: 5,
                    blurColor: Colors.grey.shade400,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    )),
              ),
            if (isVideo)
              InkWell(
                onTap: () async {
                  await engine.switchCamera();
                },
                child: Blur(
                    overlay: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    blur: 10,
                    blurColor: Colors.grey.shade400,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    )),
              ),
            InkWell(
              onTap: () async {
                if (!isVideo) {
                  await _handleCameraAndMic(Permission.camera)
                      .whenComplete(() async {
                    await availableCameras().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SwitchCamera(cameras: value),
                        )));
                  });
                } else {
                  await engine.muteLocalVideoStream(!isVideo);
                  setState(() {
                    isVideo = !isVideo;
                  });
                }
              },
              child: Blur(
                  overlay: Icon(
                    !isVideo ? Icons.videocam_off : Ionicons.videocam,
                    color: !isVideo ? Colors.black : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  blur: 5,
                  blurColor: !isVideo ? Colors.white : Colors.grey.shade400,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  )),
            ),
            InkWell(
              onTap: () async {
                await engine.muteLocalAudioStream(!muteMic).whenComplete(() {
                  setState(() {
                    muteMic = !muteMic;
                  });
                });
              },
              child: Blur(
                  overlay: Icon(
                    muteMic ? Ionicons.ios_mic_off : Ionicons.ios_mic,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  blur: 5,
                  blurColor: Colors.grey.shade400,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  )),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              elevation: 0,
              onPressed: () async {
                await engine.disableVideo();
                await engine.disableAudio();
                await engine.leaveChannel();
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
              color: !isVideo
                  ? darkMode
                      ? const Color(0xff47555E)
                      : const Color(0xff7AA5D2)
                  : null,
              height: height,
              width: width,
              child: Center(
                  child: !isVideo
                      ? StreamBuilder(
                          stream: API.getUserSnapshot(widget.uid),
                          builder: (context, snapshot) {
                            UserModel user =
                                UserModel.fromJson(snapshot.data!.docs[0]);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: width * 0.13,
                                      backgroundImage: NetworkImage(
                                          user.userImages[
                                              user.userImages.length - 1]),
                                    child: remoteUid==null ?  SizedBox(
                                      height: width * 0.26,
                                      width: width * 0.26,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,

                                       backgroundColor: darkMode
                                           ? const Color(0xff47555E)
                                           : const Color(0xff7AA5D2),
                                        color: Colors.white,
                                      ),
                                    ):null,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      user.userFName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      remoteUid==null?user.isOnline
                                          ? 'Calling...'
                                          : 'Waiting...':"Connected",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const Text(''),
                                const Text(''),
                                const Text(''),
                              ],
                            );
                          },
                        )
                      : renderRemoteView())),
          Positioned(
            top: height * 0.05,
            left: width * 0.05,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      await engine.disableVideo();
                      await engine.disableAudio();
                      await engine.leaveChannel();
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 50,
                      width: 40,
                      child: currentPlatform == TargetPlatform.android
                          ? Icon(
                              Icons.arrow_back,
                              color: darkMode ? Colors.white : Colors.black,
                            )
                          : Icon(
                              Icons.arrow_back_ios,
                              color: darkMode ? Colors.white : Colors.black,
                            ),
                    ))
              ],
            ),
          ),
          if (isVideo && remoteUid != null)
            Positioned(
              top: yPosition,
              left: xPosition,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    xPosition += details.delta.dx;
                    yPosition += details.delta.dy;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: height * 0.2,
                    width: width * 0.3,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                          rtcEngine: engine,
                          canvas: const VideoCanvas(
                            uid: 0,
                          )),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget renderRemoteView() {
    if (loading) {
      return const CircularProgressIndicator();
    } else {
      if (remoteUid != null) {
        return AgoraVideoView(
            controller: VideoViewController.remote(
                rtcEngine: engine,
                canvas: VideoCanvas(uid: remoteUid),
                connection: RtcConnection(channelId: API.getConversationId(widget.uid).toString())));
      } else {
        return AgoraVideoView(
            controller: VideoViewController(
                rtcEngine: engine, canvas: const VideoCanvas(uid: 0)));
      }
    }
  }
}

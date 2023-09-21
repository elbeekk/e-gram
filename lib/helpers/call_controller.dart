import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:elbekgram/chats/index.dart';
import 'package:get/get.dart';


class CallController extends GetxController{
  RxInt myRemoteId = 0.obs;
  RxBool localUserJoined = false.obs;
  RxBool muted = false.obs;
  RxBool videoPaused = false.obs;
  RxBool switchMainView = false.obs;
  RxBool mutedVideo = false.obs;
  RxBool reConnectingRemoteView = false.obs;
  RxBool isFront = false.obs;
  late RtcEngine engine;
  String appId = "4bf28133d28647fbbc3e9f192dfcb1ee";
  @override
  void onInit() {
    initilize();
    super.onInit();
  }

  @override
  void onClose() {
    clear();
    super.onClose();
  }

  Future<void> initilize()async{
    Future.delayed(Duration.zero,() async {
      initAgoraRtcEngine();
      addAgoraEventHandlers();
      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      VideoEncoderConfiguration configuration = const VideoEncoderConfiguration();
      await engine.setVideoEncoderConfiguration(configuration);
      await engine.leaveChannel();
      await engine.joinChannel(token: '007eJxTYBCZfINV58qy655879Yqrdp7MTPg3MKTS9l0T1Z0vHx+5ugBBQaTpDQjC0Nj4xQjCzMT87SkpGTjVMs0Q0ujlLTkJMPU1DX7uVIbAhkZXE+zMTMyQCCIz8JQWJ5SyMAAAP+HIfM=', channelId: 'channel', uid: 0, options: const ChannelMediaOptions());
      update();
    },);
  }

  clear(){
    engine.leaveChannel();
    isFront.value = false;
    reConnectingRemoteView.value = false;
    videoPaused.value=false;
    muted.value=false;
    mutedVideo.value=false;
    switchMainView.value=false;
    localUserJoined.value=false;
    update();
  }

  Future<void> initAgoraRtcEngine()async{
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting
    ));
    await engine.enableVideo();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

  }

  void addAgoraEventHandlers() {
    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection,int elapsed){
        localUserJoined.value=true;
        update();
      },
      onUserJoined:(RtcConnection connection,int remoteId,int elapsed){
    localUserJoined.value=true;
    myRemoteId.value = remoteId;
    update();
    },
    onUserOffline: (RtcConnection connection,int elapsed,UserOfflineReasonType reasonType){
    if(reasonType == UserOfflineReasonType.userOfflineDropped){
      myRemoteId.value=0;
      onCallEnd();
      update();
    }else{
      myRemoteId.value = 0;
    }},
      onRemoteVideoStats: (RtcConnection connection,RemoteVideoStats stats) {
          if(stats.receivedBitrate==0){
            videoPaused.value=true;
            update();
          }else{
            videoPaused.value=false;
            update();
          }
        },
      onTokenPrivilegeWillExpire: (RtcConnection connection,String token) {},
      onLeaveChannel:(RtcConnection connection, stats) {
      clear();
      onCallEnd();
      update();
      },
    ));
  }
  void onVideoOff(){
    mutedVideo.value = !mutedVideo.value;
    engine.muteLocalVideoStream(mutedVideo.value);
    update();
  }
  void onCallEnd() {
    clear();
    update();
    Get.offAll(()=>IndexPage());
  }
  void onToggleMute(){
    muted.value=!muted.value;
    engine.muteLocalAudioStream(muted.value);
    update();
  }
  void onToggleMuteVideo(){
    mutedVideo.value=!mutedVideo.value;
    engine.muteLocalAudioStream(mutedVideo.value);
    update();
  }
  void onSwitchCamera(){
    engine.switchCamera().then((value) => {}).catchError((err){});
  }
}
import 'package:camera/camera.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SwitchCamera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SwitchCamera({super.key, required this.cameras});

  @override
  State<SwitchCamera> createState() => _SwitchCameraState();
}

class _SwitchCameraState extends State<SwitchCamera> {
  int isSelected = 2;
  late CameraController cameraController;

  Future initCamera(CameraDescription cameraDescription) async {
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);
    try {
      await cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    if(widget.cameras.length>1){
      initCamera(
        widget.cameras[0],
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    if(widget.cameras.isEmpty){
      setState(() {
        isSelected=1;
      });
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: width * 0.08),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                height: 47,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(isSelected == 1
                          ? 'assets/buttonColor2.jpg'
                          : isSelected == 2
                              ? 'assets/buttonColor.jpg'
                              : "assets/buttonColor3.jpg"),
                      fit: BoxFit.cover,
                    )),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Center(
                    child: Text(
                  'Share Video',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          isSelected = 1;
                        });
                      },
                      child: SizedBox(
                          height: 40,
                          width: width * 0.3,
                          child: Center(
                            child: Text(
                              'PHONE SCREEN',
                              style: TextStyle(
                                  color: isSelected == 1
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontWeight: isSelected == 1
                                      ? FontWeight.w600
                                      : FontWeight.w400),
                            ),
                          ))),
                  if(widget.cameras.isNotEmpty)InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          isSelected = 2;
                        });
                        initCamera(
                          widget.cameras![0],
                        );
                      },
                      child: SizedBox(
                          height: 40,
                          width: width * 0.3,
                          child: Center(
                            child: Text(
                              'FRONT CAMERA',
                              style: TextStyle(
                                  color: isSelected == 2
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontWeight: isSelected == 2
                                      ? FontWeight.w600
                                      : FontWeight.w400),
                            ),
                          ))),
                  if(widget.cameras.isNotEmpty)InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          isSelected = 3;
                        });
                        initCamera(
                          widget.cameras[1],
                        );
                      },
                      child: SizedBox(
                          height: 40,
                          width: width * 0.3,
                          child: Center(
                            child: Text(
                              'BACK CAMERA',
                              style: TextStyle(
                                  color: isSelected == 3
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontWeight: isSelected == 3
                                      ? FontWeight.w600
                                      : FontWeight.w400),
                            ),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: widget.cameras.isNotEmpty?!cameraController.value.isInitialized
                ? const Center(
              child: SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator()),
            )
                : isSelected != 1
                ? CameraPreview(cameraController)
                : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height*0.3,
                      child: Lottie.asset('assets/share.json'),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Everything on your screen, including notifications, will be shared.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16,color: Colors.greenAccent.shade200),
                      ),
                    )
                  ],
                )):Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height*0.3,
                      child: Lottie.asset('assets/share.json'),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Everything on your screen, including notifications, will be shared.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16,color: Colors.greenAccent.shade200),
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
            top: height * 0.055,
            left: width * 0.05,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 50,
                      width: 40,
                      child: currentPlatform == TargetPlatform.android
                          ? Icon(
                              Icons.arrow_back,
                              color:isSelected==1?Colors.greenAccent : isSelected==2?Colors.blue : Colors.deepPurpleAccent,
                            )
                          : Icon(
                              Icons.arrow_back_ios,
                              color:isSelected==1?Colors.greenAccent : isSelected==2?Colors.blue : Colors.deepPurpleAccent,
                            ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

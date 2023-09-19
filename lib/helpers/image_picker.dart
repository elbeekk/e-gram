import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService{
  static Future<XFile?> pickCropImage({required CropAspectRatio cropAspectRatio,required ImageSource imageSource,required bool darkMode}) async {
    XFile? pickImage = await ImagePicker().pickImage(source: imageSource);
    if(pickImage==null)return null;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickImage.path,uiSettings: [
      AndroidUiSettings(
        toolbarColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        statusBarColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        cropGridColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        cropFrameColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        backgroundColor:
        darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        activeControlsWidgetColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
      toolbarWidgetColor: Colors.white,
      lockAspectRatio: true,
        cropGridRowCount: 0,
        cropGridColumnCount: 0
      ),
      IOSUiSettings(
        showCancelConfirmationDialog: true,
        resetAspectRatioEnabled: false,
        aspectRatioLockEnabled: true,
        aspectRatioPickerButtonHidden: false,

        ),
    ],
      aspectRatio: cropAspectRatio,
      compressQuality: 50,
      compressFormat: ImageCompressFormat.jpg,);
    if(croppedFile == null)return null;
    return XFile(croppedFile.path);
  }
}
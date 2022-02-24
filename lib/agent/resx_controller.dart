import 'package:flutter/material.dart';
import 'package:sirius_geo_4/builder/pattern.dart';
import 'package:get/get.dart';

class ResxController extends GetxController {
  ResxController();

  final Map<String, dynamic> resxMap = {};

  Rx addToResxMap(String name, dynamic input) {
    if (input is String) {
      resxMap[name] = RxString(input);
    } else if (input is Map<String, dynamic>) {
      resxMap[name] = RxMap(input);
    } else if (input is int) {
      resxMap[name] = RxInt(input);
    } else if (input is Widget) {
      resxMap[name] = Rx<Widget>(input);
    } else if (input is List<Widget>) {
      resxMap[name] = Rx<List<Widget>>(input);
    } else if (input is double) {
      resxMap[name] = RxDouble(input);
    } else if (input is bool) {
      resxMap[name] = RxBool(input);
    } else if (input is List<int>) {
      resxMap[name] = Rx<List<int>>(input);
    } else if (input is List<String>) {
      resxMap[name] = Rx<List<String>>(input);
    } else if (input is List<dynamic>) {
      resxMap[name] = Rx<List<dynamic>>(input);
    } else if (input is ProcessPattern) {
      resxMap[name] = Rx<ProcessPattern>(input);
    } else {
      resxMap[name] = null;
    }
    return resxMap[name];
  }

  setRxValue(String name, dynamic value) {
    if (value == null) {
      resxMap[name] = null;
      return;
    }
    Rx rx = resxMap[name];
    if (rx != null) {
      rx.value = value;
    }
  }

  dynamic getRx(String name) {
    return resxMap[name];
  }

  dynamic getRxValue(String name) {
    Rx rx = resxMap[name];
    return rx.value;
  }
}
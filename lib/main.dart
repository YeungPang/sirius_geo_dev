import 'package:flutter/material.dart';
import 'package:sirius_geo_4/builder/pattern.dart';
import 'package:sirius_geo_4/model/main_model.dart';
import 'package:sirius_geo_4/ui/views/home_page.dart';
import 'package:get/get.dart';
import 'package:sirius_geo_4/agent/resx_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MainModel model = Get.put(MainModel());
    Get.put(ResxController());
    return GetMaterialApp(
      //title: model.map["title"],
      getPages: [
        GetPage(name: "/home", page: () => HomePage()),
        GetPage(name: "/page", page: () => _getPage(model)),
      ],
      initialRoute: "/home",

      //onGenerateRoute: _routes(),
    );
  }

  Widget _getPage(MainModel model) {
    Widget screen;
    Map<String, dynamic> map = Get.arguments;
    Agent a = model.appActions.getAgent("pattern");

    ProcessEvent event = ProcessEvent(Get.parameters["screen"], map: map);
    var p = a.process(event);

    if (p is ProcessPattern) {
      screen = p.getWidget();
    } else if (p is Widget) {
      screen = p;
    }
    return screen;
  }
}

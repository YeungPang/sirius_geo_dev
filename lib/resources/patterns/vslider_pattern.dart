import 'package:flutter/material.dart';
import 'package:sirius_geo_4/builder/special_pattern.dart';
import 'package:sirius_geo_4/builder/std_pattern.dart';
import 'package:sirius_geo_4/resources/basic_resources.dart';
import 'package:sirius_geo_4/builder/pattern.dart';
import 'package:sirius_geo_4/model/locator.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:sirius_geo_4/resources/fonts.dart';

class VertSlider extends StatelessWidget {
  final Map<String, dynamic> map;
  final double max = 200.0;
  final double lh = 13.0;

  VertSlider(this.map);

  @override
  Widget build(BuildContext context) {
    double h = map["_mv"]["_height"] * 0.8;
    String scale1 = map["_scale1"];
    String scale2 = map["_scale2"];
    int top1 = map["_scale1Top"];
    int bottom1 = map["_scale1Bottom"];
    int top2 = map["_scale2Top"];
    int bottom2 = map["_scale2Bottom"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          map["_largest"],
          style: sliderTextStyle,
        ),
        SizedBox(
          height: h,
          width: map["_mv"]["_width"],
          child: Row(
            children: [
              _scaleWidget(scale1, h, true, top1, bottom1),
              _getSliderView(h),
              _scaleWidget(scale2, h, false, top2, bottom2),
              _buildScaleContainer(scale1, scale2)
            ],
          ),
        ),
        Text(
          map["_smallest"],
          style: sliderTextStyle,
        )
      ],
    );
  }

  Widget _scaleWidget(
      String scale, double height, bool end, int top, int bottom) {
    int div = map["_div"];
    int interval = (bottom - top) ~/ div;
    List<Widget> l = [];
    for (int i = 0; i <= div; i++) {
      int v = top + interval * i;
      l.add(Text(
        v.toString(),
        style: sliderBoldTextStyle,
      ));
    }
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment:
            end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerRight,
              height: 13.0,
              child: Text(
                scale,
                style: sliderBoldTextStyle,
              )),
          SizedBox(
              height: height - 13.0,
              child: Column(
                children: l,
                crossAxisAlignment:
                    end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ))
        ],
      ),
    );
  }

  Widget _getSliderView(double h) {
    ValueNotifier<double> vn = map["_mv"]["_scaleNoti"];
    return ValueListenableBuilder<int>(
      valueListenable: map["_sliderNoti"],
      builder: (BuildContext context, int value, Widget child) => (value > 0)
          ? _getSliderStack(h, value)
          : _sliderWidget(h, vn.value, false),
    );
  }

  Widget _getSliderStack(double h, int sn) {
    ValueNotifier<double> vn = map["_mv"]["_scaleNoti"];
    double value = vn.value;
    int top = map["_scale1Top"];
    int bottom = map["_scale1Bottom"];
    Map<String, dynamic> _mv = map["_mv"];
    double g = ((_mv["_ans1"] - top) * max / (bottom - top)).abs();
    double o = (_mv["_ans1"] == "o") ? value : 0.0;
    double r = (_mv["_resStatus"] == "r") ? value : 0.0;
    if (sn == 2) {
      return _sliderWidget(h, value, true);
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [_buildColorMeters(g, o, r, h), _sliderWidget(h, value, true)],
    );
  }

  Widget _sliderWidget(double h, double s, bool res) {
    double _absoluteSize = s;
    Map<String, dynamic> _mv = map["_mv"];
    return Container(
      margin: res
          ? const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0)
          : const EdgeInsets.only(top: 10.0),
      height: h - lh,
      child: FlutterSlider(
        values: [_absoluteSize],
        axis: Axis.vertical,
        max: max,
        min: 0,
        handlerHeight: res ? 5 : 20,
        handlerWidth: res ? 5 : 20,
        tooltip: FlutterSliderTooltip(
          disabled: true,
        ),
        handler: FlutterSliderHandler(
          opacity: res ? 0 : 1,
          disabled: res,
          child: res
              ? Container()
              : Container(
                  child: Image.asset('assets/images/slider_circle.png'),
                ),
        ),
        hatchMark: FlutterSliderHatchMark(
          labels: _getMarkerList(),
          labelsDistanceFromTrackBar: 1.2,
          linesAlignment: FlutterSliderHatchMarkAlignment.right,
          density: 0.5,
        ),
        trackBar: const FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(
            gradient: blueGradient,
          ),
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          if (_mv["_state"] != "edited") {
            ValueNotifier<double> notifier = _mv["_confirmNoti"];
            notifier.value = 1.0;
            _mv["_state"] = "edited";
          }
          _absoluteSize = lowerValue;
          //print(lowerValue);
          //print(upperValue);
          ValueNotifier<double> vn = map["_mv"]["_scaleNoti"];
          if (vn != null) {
            vn.value = lowerValue;
          }
        },
      ),
    );
  }

  List<FlutterSliderHatchMarkLabel> _getMarkerList() {
    List<FlutterSliderHatchMarkLabel> l = [];
    for (int i = 0; i <= 20; i++) {
      l.add(FlutterSliderHatchMarkLabel(
          percent: i * 5.0,
          label: Container(
            height: 5,
            width: 5,
            margin: const EdgeInsets.only(right: 1),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )),
          )));
    }
    return l;
  }

  Widget _buildScaleContainer(String scale1, String scale2) {
    Map<String, dynamic> m1 = {
      "_converter": scale1Converter,
      "_notifier": map["_mv"]["_scaleNoti"],
      "_textStyle": sliderTextStyle
    };
    ValueText<double> v1 = ValueText<double>(m1);
    Widget sCol1 = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          scale1,
          style: sliderTextStyle,
        ),
        v1
      ],
    );
    Map<String, dynamic> m2 = {
      "_converter": scale2Converter,
      "_notifier": map["_mv"]["_scaleNoti"],
      "_textStyle": sliderTextStyle
    };
    ValueText<double> v2 = ValueText<double>(m2);
    Widget sCol2 = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          scale2,
          style: sliderTextStyle,
        ),
        v2
      ],
    );
    Widget s2 = _buildVSliderScaleValue(sCol1);
    Widget s1 = _buildVSliderScaleValue(sCol2);
    Widget col = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          model.map["text"]["yourSel"],
          style: controlButtonTextStyle,
        ),
        s1,
        s2
      ],
    );
    return _buildVSliderScaleContainer(col);
  }

  String scale1Converter(double value, Map<String, dynamic> smap) {
    int top = map["_scale1Top"];
    int bottom = map["_scale1Bottom"];
    int v = (bottom - top) * value ~/ max + top;
    Map<String, dynamic> _mv = map["_mv"];
    _mv["_in1"] = v;
    return v.toString();
  }

  String scale2Converter(double value, Map<String, dynamic> smap) {
    int top = map["_scale2Top"];
    int bottom = map["_scale2Bottom"];
    int v = (bottom - top) * value ~/ 200.0 + top;
    Map<String, dynamic> _mv = map["_mv"];
    _mv["_in2"] = v;
    return v.toString();
  }

  Widget _buildColorMeters(double g, double o, double r, double h) {
    double sh = (h - lh) / max;
    double gh = (g - o - r) * sh;

    Map<String, dynamic> gmap = {
      "_beginColor": const Color(0xFF4DC591),
      "_endColor": const Color(0xFF82EFC0),
      "_btnBRadius": 4.0,
      "_width": 20.0,
      "_height": (gh > 0.0)
          ? gh
          : (g > 0.0)
              ? g * sh
              : 1.0,
    };
    Widget gc = ColorButton(gmap);
    double fh = (o > 0.0)
        ? o * sh
        : (r > 0.0)
            ? r * sh
            : 0.0;
    List<Widget> l;
    if (fh > 0.0) {
      Map<String, dynamic> fmap = {
        "_beginColor":
            (o > 0.0) ? const Color(0xFFFF9E50) : const Color(0xFFF76F71),
        "_endColor":
            (o > 0.0) ? const Color(0xFFFDBD88) : const Color(0xFFFF9DAC),
        "_btnBRadius": 4.0,
        "_width": 20.0,
        "_height": (gh > 0.0) ? fh : -gh,
      };
      Widget fc = ColorButton(fmap);
      l = (gh > 0.0)
          ? [
              SizedBox(
                height: lh,
              ),
              fc,
              gc
            ]
          : [
              SizedBox(
                height: lh,
              ),
              gc,
              fc
            ];
    } else {
      l = [
        SizedBox(
          height: lh,
        ),
        gc
      ];
    }
    return Column(
      children: l,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget _buildVSliderScaleValue(Widget sCol) {
    Map<String, dynamic> imap = {
      "_height": 0.07143 * model.screenHeight,
      "_width": 0.213333333 * model.screenWidth,
      "_alignment": Alignment.center,
      "_btnBRadius": 10.0,
      "_color": Colors.white,
      "_child": sCol
    };
    return ColorButton(imap);
  }

  Widget _buildVSliderScaleContainer(Widget col) {
    Map<String, dynamic> imap = {
      "_height": 0.2364532 * model.screenHeight,
      "_width": 0.2933333 * model.screenWidth,
      "_alignment": Alignment.center,
      "_btnBRadius": 10.0,
      "_beginColor": colorMap["btnBlue"],
      "_endColor": colorMap["btnBlueGradEnd"],
      "_child": col
    };
    Widget c = ColorButton(imap);
    imap = {
      "_height": 0.61576354 * model.screenHeight,
      "_width": 0.32 * model.screenWidth,
      "_alignment": Alignment.center,
      "_child": c
    };
    return ContainerPattern(imap).getWidget();
  }
}

buildSliderResult(Map<String, dynamic> map) {
  Map<String, dynamic> _mv = map["_mv"];
  Color c = (_mv["_resStatus"] == "g")
      ? colorMap["correct"]
      : (_mv["_resStatus"] == "o")
          ? colorMap["almost"]
          : colorMap["incorrect"];
  TextStyle ts = sliderTextStyle.copyWith(color: c);
  TextStyle ts1 = complTextStyle.copyWith(color: c);
  List<Widget> wl = [
    Text(
      map["_scale1"],
      style: ts,
    ),
    Text(
      _mv["_ans1"].toString(),
      style: ts1,
    ),
  ];
  Map<String, dynamic> m1 = {
    "resColor": c,
    "resCol": Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: wl,
        ))
  };
  Widget w1 = _buildSliderResValue(m1);
  wl = [
    Text(
      map["_scale2"],
      style: ts,
    ),
    Text(
      _mv["_ans2"].toString(),
      style: ts1,
    ),
  ];
  m1["resCol"] = Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: wl,
      ));
  Widget w2 = _buildSliderResValue(m1);
  Widget ansC = Container(
    width: 60.0,
    height: 16.0,
    //margin: EdgeInsets.only(left: 15.0),
    color: Colors.white,
    alignment: const Alignment(-0.9, 0.0),
    child: Text(
      model.map["text"]["Answer"],
      style: ts,
    ),
  );

  Widget ansW = Align(alignment: const Alignment(-0.2, 1.0), child: ansC);
  Widget w = Align(
      alignment: const Alignment(1.0, 0.0),
      child: SizedBox(
          width: 0.133333 * model.screenWidth,
          height: 0.2093596 * model.screenHeight,
          child: OverflowBox(
              maxWidth: 160.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [const SizedBox(height: 60.0), w2, ansW],
                    ),
                    Stack(
                        alignment: Alignment.topLeft,
                        children: [const SizedBox(height: 60.0), w1, ansW])
                  ]))));
  _mv["_res"] = w;
}

Widget _buildSliderResValue(Map<String, dynamic> map) {
  Map<String, dynamic> amap = {
    "_elevation": 4.0,
    "_cardRadius": 20.0,
    "_height": 0.086207 * model.screenHeight,
    "_width": 0.453333 * model.screenWidth,
    "_margin": const EdgeInsets.only(top: 10.0),
    "_btnBRadius": 20.0,
    "_color": Colors.white,
    "_borderColor": map["resColor"],
    "_child": map["resCol"]
  };
  //map.addAll(amap);
  Widget cb = ColorButton(amap);
  Map<String, dynamic> cmap = {};
  cmap.addAll(amap);
  cmap["_child"] = cb;
  return CardPattern(cmap).getWidget();
}

class VertSliderPattern extends ProcessPattern {
  VertSliderPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String name}) {
    return VertSlider(map);
  }
}
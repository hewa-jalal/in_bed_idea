import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:screen/screen.dart';

class BrightnessSlider extends StatefulWidget {
  @override
  _BrightnessSliderState createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  double _brightness = 1.0;


  @override
  void initState() {
    super.initState();
    getBrightness();
  }

  getBrightness() async {
    double brightness = await Screen.brightness;
    setState(() => _brightness = brightness);
    Screen.setBrightness(0.2);
    print('brightness first screen => $_brightness');
  }


  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [0.0, 1.0],
      tooltip: FlutterSliderTooltip(
        disabled: true,
      ),
      max: 1.0,
      min: 0.0,
      step: 0.1,
      onDragging: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          Screen.setBrightness(lowerValue);
        });
      },
      trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(color: Colors.red)),
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(),
        child: Material(
          type: MaterialType.canvas,
          color: Colors.blueGrey[800],
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.brightness_7,
              size: 25,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';

typedef ResponsiveBuilder = Widget Function(BuildContext context, Size size);

class ResponsiveSafeArea extends StatelessWidget {
  final ResponsiveBuilder responsiveBuilder;

  ResponsiveSafeArea({@required ResponsiveBuilder builder})
      : responsiveBuilder = builder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return responsiveBuilder(context, constraints.biggest);
      }),
    );
  }
}

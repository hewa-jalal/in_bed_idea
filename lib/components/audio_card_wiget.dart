import 'package:flutter/material.dart';
import 'package:inbedidea/size_config.dart';

class AudioCard extends StatelessWidget {
  final Function onTap;
  final String imagePath;

  const AudioCard({this.onTap, this.imagePath});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.grey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 170,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Image.asset('assets/images/$imagePath', fit: BoxFit.scaleDown),
          ),
        ),
      ),
    );
  }
}

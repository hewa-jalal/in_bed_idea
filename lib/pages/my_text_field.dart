import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String title;
  final Function onChange;
  final bool isPassword;

  MyTextField(this.title, this.onChange, {this.isPassword = false});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: widget.onChange,
              obscureText: !showPassword && widget.isPassword,
              decoration: InputDecoration(
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: showPassword ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => showPassword = !showPassword);
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
}

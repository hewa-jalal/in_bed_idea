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
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() {});
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 2),
          TextField(
            controller: _controller,
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
                    : IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: _controller.text.isEmpty
                              ? Colors.grey
                              : Colors.blue,
                        ),
                        onPressed: () => _controller.clear()),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
                filled: true),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

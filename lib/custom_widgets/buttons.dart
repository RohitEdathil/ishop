import 'package:flutter/material.dart';

class FancyButtonOne extends StatefulWidget {
  final Widget child;
  final Function onPressed;

  const FancyButtonOne({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  _FancyButtonOneState createState() => _FancyButtonOneState();
}

class _FancyButtonOneState extends State<FancyButtonOne> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 40,
      child: RaisedButton(
        onPressed: widget.onPressed,
        child: widget.child,
        shape: StadiumBorder(),
        color: Colors.purple,
        elevation: 20,
      ),
    );
  }
}

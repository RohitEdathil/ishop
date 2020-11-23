import 'package:flutter/material.dart';
import 'package:ishop/custom_widgets/buttons.dart';
import 'package:ishop/custom_widgets/textFields.dart';
import 'package:ishop/data/firebase_authentication.dart';
import 'package:ishop/data/firebase_firestore.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  GlobalKey<ScaffoldState> _state = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _state,
      floatingActionButton: RawMaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: Colors.white,
              ),
              Text(
                '  Login',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        fillColor: Colors.blue,
        splashColor: Colors.blue[200],
        onPressed: () {
          Navigator.popAndPushNamed(context, '/login');
        },
        shape: StadiumBorder(),
        elevation: 20,
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
                flex: 2,
              ),
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 40),
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
                flex: 1,
              ),
              FancyTextFieldOne(
                placeholder: "Owner's Name",
                controller: _userNameController,
              ),
              FancyTextFieldOne(
                placeholder: "Shop's Name",
                controller: _shopNameController,
              ),
              FancyTextFieldOne(
                placeholder: "Email Id",
                controller: _emailController,
              ),
              FancyTextFieldOne(
                placeholder: "Password",
                controller: _passwordController,
                isObscured: true,
              ),
              FancyTextFieldOne(
                placeholder: "Confirm Password",
                isObscured: true,
                controller: _confirmController,
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
                flex: 1,
              ),
              FancyButtonOne(
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: handleInput,
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleInput() {
    if (!isNull(_userNameController.text) &&
        !isNull(_shopNameController.text) &&
        !isNull(_emailController.text) &&
        !isNull(_passwordController.text) &&
        !isNull(_confirmController.text)) {
      if (isEmail(trim(_emailController.text))) {
        if (_passwordController.text == _confirmController.text) {
          signUp(trim(_emailController.text), _passwordController.text)
              .then((value) {
            if (value == 'OK') {
              createUser(_userNameController.text, _shopNameController.text,
                      _emailController.text)
                  .then((value) => {
                        if (value == 'OK')
                          {Navigator.popAndPushNamed(context, '/home')}
                        else
                          {showBar(value)}
                      });
            } else {
              showBar(value);
            }
          });
        } else {
          showBar("Passwords don't match");
        }
      } else {
        showBar('Enter a valid email ID');
      }
    } else {
      showBar('Please Fill up all the fields');
    }
  }

  showBar(String message) {
    _state.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}

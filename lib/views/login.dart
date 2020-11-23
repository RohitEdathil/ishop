import 'package:flutter/material.dart';
import 'package:ishop/custom_widgets/buttons.dart';
import 'package:ishop/custom_widgets/textFields.dart';
import 'package:ishop/data/firebase_authentication.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
                Icons.person_add,
                color: Colors.white,
              ),
              Text(
                '  SignUp',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        fillColor: Colors.blue,
        splashColor: Colors.blue[200],
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/signup');
        },
        shape: StadiumBorder(),
        elevation: 20,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image(
                  image: AssetImage('images/logo.png'),
                  height: 200,
                ),
              ),
              Container(
                width: 300,
                child: Column(
                  children: [
                    FancyTextFieldOne(
                      controller: _usernameController,
                      placeholder: 'Email Id',
                    ),
                    FancyTextFieldOne(
                      controller: _passwordController,
                      placeholder: 'Password',
                      isObscured: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FancyButtonOne(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: handleInput,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleInput() {
    if (!isNull(_usernameController.text) &&
        !isNull(_passwordController.text)) {
      login(trim(_usernameController.text), _passwordController.text)
          .then((value) => {
                if (value == 'OK')
                  {Navigator.popAndPushNamed(context, '/home')}
                else
                  {showBar(value)}
              });
    } else {
      showBar('Please fill up everything');
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

import 'package:flutter/material.dart';
import 'package:pro1/Home_Page/Parent_Version/parent_home.dart';
import 'package:pro1/Home_Page/Single_User_Version/single_user_home.dart';
import 'package:pro1/Home_Page/Menu_Pages/add_account.dart';
import 'package:pro1/Registration/Forgot_Password/verify_email.dart';
import 'package:pro1/Registration/choose_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pro1/Theme/app_themes.dart';

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({Key? key}) : super(key: key);

  @override
  State<SwitchAccount> createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  final Themes _themes = Themes();

// user input stored for comparison with the data stored in the database
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  final Map<String, String> _authData = {
    'email/username': '',
    'password': '',
  };
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background1,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                    color: Colors.transparent, elevation: 40, child: appLogo()),
                Container(
                  padding: const EdgeInsets.all(15),
                  height: 775,
                  decoration: _themes.screenDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close_outlined,
                              color: Colors.blue[900],
                            ),
                          )
                        ],
                      ),
                      Material(
                        color: Colors.transparent,
                        elevation: 40,
                        child: _themes.title('LOGIN'),
                      ),
                      Material(
                          color: Colors.transparent,
                          elevation: 40,
                          child: _themes
                              .trailing('Login With a Different Account')),
                      const SizedBox(
                        height: 70,
                      ),
                      Material(
                        color: Colors.transparent,
                        elevation: 40,
                        child: TextFormField(
                          //email/username text field
                          controller: _emailInput,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.dark,
                          decoration: _themes.textFormFieldDecoration('Email'),
                          style: TextStyle(
                            color: fontColor4,
                          ),
                          obscureText: false,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.com') ||
                                value.length < 12) {
                              if (value.isEmpty) {
                                return 'This field is required!';
                              } else {
                                return 'Invalid email/username';
                              }
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _authData['email/username'] = newValue!;
                            _emailInput.text = newValue;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        color: Colors.transparent,
                        elevation: 40,
                        child: TextFormField(
                          //password text field
                          keyboardAppearance: Brightness.dark,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            color: fontColor4,
                          ),
                          controller: _passwordInput,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: fontColor4,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                visible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: background5,
                              ),
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                            ),
                          ),
                          obscureText: visible,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              if (value.isEmpty) {
                                return 'This field is required!';
                              } else {
                                return 'Short password';
                              }
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _authData['password'] = newValue!;
                            _passwordInput.text = newValue;
                          },
                        ),
                      ),
                      Row(
                        /**Forgot Password Link*/
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 40,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const VerifyEmail(),
                                  ),
                                );
                              },
                              child: _themes.resetLink('Forgot Password'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        color: Colors.transparent,
                        elevation: 40,
                        child: TextButton(
                          /**Login button */
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();
                            if (isValid) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_emailInput.text != '' &&
                                          _passwordInput.text != '')
                                      ? (context) => swtch()
                                      : ((context) => const SwitchAccount()),
                                ),
                              );
                              getData;
                            }
                          },
                          child: _themes.textButtonStyle('LOGIN'),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        elevation: 40,
                        child: Row(
                          /**Swich to Sign up */
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _themes.linkText1('New User?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => const AddAccount()),
                                  ),
                                );
                              },
                              child: _themes.linkText2('ADD ACCOUNT'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //getter method to save the login user data/input
  get getData async {
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    loginPrefs.setString('user', _emailInput.text);
    loginPrefs.setString('password', _passwordInput.text);
  }

  Widget swtch() {
    if (userMode == 'family') {
      return SingleUserHomePage();
    }
    if (userMode == 'personal') {
      return ParentHomePage();
    } else {
      return const SwitchAccount();
    }
  }
}

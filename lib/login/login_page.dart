import 'package:flutter/material.dart';
import 'package:lgp/main_page.dart';
import 'package:lgp/login/my_session.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Image.asset(
                    'images/splash_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value == '') {
                          return 'Silahkan Masukkan Username';
                        }
                      },
                      controller: username,
                      decoration: const InputDecoration(
                          hintText: "Masukkan Username",
                          prefixIcon: Icon(Icons.people)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (password == '') {
                          return 'Silahkan Masukkan Password';
                        }
                      },
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Masukkan Password",
                          prefixIcon: Icon(Icons.lock)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 47, 60, 240)),
                          onPressed: () {
                            this._dologin();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _dologin() async {
    EasyLoading.show(status: 'Silahkan Tunggu...');
    if (username.text == "sakti" && password.text == "masuk135") {
      EasyLoading.dismiss();
      MySession.instance.setStringValue('username', 'sakti');
      MySession.instance.setBooleanValue("loggedin", true);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ));
      // Alert(
      //   context: context,
      //   title: "Success",
      //   content: Text("Berhasil Login"),
      //   type: AlertType.success,
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "OK",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //       onPressed: () {},
      //       width: 120,
      //     )
      //   ],
      // ).show();
    } else {
      EasyLoading.dismiss();
      Alert(
        context: context,
        title: "Gagal",
        content: const Text("Username dan Password Tidak Valid."),
        type: AlertType.error,
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
      return;
    }
  }
}

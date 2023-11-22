import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../models/profilModel.dart';
import '../../../service/links.dart';
import '../../sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    _Data = getClientById();
    print(sharedPref?.getString("id"));
  }

  late Future<profilModel> _Data;
  late profilModel profil;
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0xFF4A3298) : Colors.green,
        ),
      );
    },
  );

  Future<profilModel> getClientById() async {
    String Url = "$getAgentByID${sharedPref?.getString("id")}";
    http.Response futureprofil = await http.get(Uri.parse(Url));
    print(futureprofil.statusCode);
    print(futureprofil.body);
    if ((futureprofil.statusCode == 200) || (futureprofil.statusCode == 201)) {
      return profilModel.fromJson(json.decode(futureprofil.body));
    } else {
      throw Exception('can not load post data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          opacity: 0.2,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            FutureBuilder<profilModel>(
              future: _Data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      ProfilePic(),
                      SizedBox(height: 20),
                      ProfileMenu(
                        text: snapshot.data!.Name,
                        icon: "assets/icons/User Icon.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: snapshot.data!.email,
                        icon: "assets/icons/User Icon.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: snapshot.data!.phone.toString(),
                        icon: "assets/icons/Phone.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Se Déconnecter",
                        icon: "assets/icons/Log out.svg",
                        press: () {
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Verifer votre connexion");
                }
                return spinkit;
              },
            ),
          ],
        ),
      ),
    );
  }
}

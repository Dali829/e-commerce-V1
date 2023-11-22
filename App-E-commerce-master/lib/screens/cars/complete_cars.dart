import 'package:intl/intl.dart'; //Import intl in the file this is being done
import 'package:flutter/material.dart';
import 'package:ecommerce/components/coustom_bottom_nav_bar.dart';
import 'package:ecommerce/enums.dart';
import '../../main.dart';
import '../../models/productModel.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';
import 'dart:convert';
import '../../service/links.dart';

class CarsScreen extends StatefulWidget {
  final String idCategory;
  final String nameCategory;
  const CarsScreen(
      {Key? key, required this.idCategory, required this.nameCategory})
      : super(key: key);
  @override
  State<CarsScreen> createState() => _CarsScreenState(idCategory, nameCategory);
}

class _CarsScreenState extends State<CarsScreen> {
  _CarsScreenState(this.idCategory, this.nameCategory);
  String idCategory;
  String nameCategory;

  @override
  void initState() {
    super.initState();
    print(idCategory);
    _Datas = getAll();
  }

  String _dateCount = "";
  String _range = "";
  Future<void> _selectDate(BuildContext context, DateTime dateTest) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      print(pickedDate);
      setState(() {
        dateTest = pickedDate;
      });
    }
  }

  Future addReservation(prix, productID) async {
    print('bonjour');

    DateTime dt1 = DateTime.parse(dateFin.toString().substring(0, 19));

    DateTime dt2 = DateTime.parse(dateDeb.toString().substring(0, 19));
    print(dateDeb);
    print(dateFin);
    // print(daysBetween(dateDeb, dateFin));

    Duration diff = dt1.difference(dt2);

    print(diff.inDays);
    //print(dateFin.difference(dateDeb));
    try {
      /*  print(dateDeb.difference(dateFin).inDays);
      final Duration duration = dateFin.difference(dateDeb);*/
      String Url = "$postReservation";
      //Duration diff = dateFin.difference(dateDeb);
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "datedebut": "22/11/2023",
                "datefin": "23/11/2023",
                "agent": sharedPref?.getString("id"),
                "product": productID,
                "prix": 40,
                "numbrJour": 1
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "rented !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
          setState(() {
            _Datas = getAll();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "error !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  List<ProductModel> mesData = [];
  void _onSelectionChanged() {}

  late Future<List<ProductModel>> _Datas;
  Future<void> _showAlertDialog(String idElem, double width, prix) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Formulaire de reservation'),
          content: SingleChildScrollView(
            child: Container(
              width: width * 0.8,
              child: Column(
                children: [
                  Text(
                    "Prix par jour : 40Dt",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Color(0xFF5E40B8)),
                  ),
                  SizedBox(height: 20),
                  Text("Date de début :"),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Réserver'),
              onPressed: () {
                addReservation(prix, idElem);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<ProductModel>> getAll() async {
    String Url = "$linkProductByCategory${idCategory}";
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return mesData = parsed
          .map<ProductModel>((json) => ProductModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  DateTime? dateDeb;
  DateTime? dateFin;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCategory),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<ProductModel>>(
                future: _Datas,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.8,
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Center(
                                  /** Card Widget **/
                                  child: Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth * 1,
                                      height: 390,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                              child: Image(
                                                image: NetworkImage(snapshot
                                                    .data![index].productImage),
                                              ),
                                            ),
                                            //CircleAvatar
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Text(
                                              snapshot.data![index].productName,
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Color(0xFF5E40B8),
                                                fontWeight: FontWeight.w500,
                                              ), //Textstyle
                                            ), //Text
                                            const SizedBox(
                                              height: 20,
                                            ), //SizedBox
                                            Expanded(
                                              child: Text(
                                                snapshot.data![index]
                                                    .productDescription,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ), //Textstyle
                                              ),
                                            ), //Text
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Container(
                                              width: SizeConfig.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 130,

                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          _showAlertDialog(
                                                              snapshot
                                                                  .data![index]
                                                                  .id,
                                                              width,
                                                              snapshot
                                                                  .data![index]
                                                                  .unitPrice),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .touch_app),
                                                            Text('Reserve')
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // RaisedButton is deprecated and should not be used
                                                    // Use ElevatedButton instead

                                                    // child: RaisedButton(
                                                    //   onPressed: () => null,
                                                    //   color: Colors.green,
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.all(4.0),
                                                    //     child: Row(
                                                    //       children: const [
                                                    //         Icon(Icons.touch_app),
                                                    //         Text('Visit'),
                                                    //       ],
                                                    //     ), //Row
                                                    //   ), //Padding
                                                    // ), //RaisedButton
                                                  ),
                                                  /* IconButton(
                                                    icon: SvgPicture.asset(
                                                        "assets/icons/Heart Icon.svg"),
                                                    onPressed: () {},
                                                  ),*/
                                                ],
                                              ),
                                            ) //SizedBox
                                          ],
                                        ), //Column
                                      ), //Padding
                                    ), //SizedBox
                                  ), //Card
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Verifer votre connexion");
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}

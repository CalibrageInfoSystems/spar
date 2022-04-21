import 'dart:convert';


import 'package:alsadhan/home/home_screen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/CartModel_data.dart';
import 'package:alsadhan/models/PlaceOrdermodel.dart';
import 'package:alsadhan/models/ProductsModel.dart';

import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/widgets/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'package:alsadhan/models/CityModel.dart';
import 'package:alsadhan/models/CountryModel.dart';
import 'package:alsadhan/services/api_constants.dart';

import 'package:gradient_text/gradient_text.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as date;
// import 'package:intl/intl.dart';

// import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


Countrymodel countryModel;
String selectedvalue;
List countyrsArray;
TextDirection textDirection;
CityModel cityModel;
String selectcityvalue;
bool isArabic = false;

class ReviewCartScreen extends StatefulWidget {
  double totalprice;
  int storemodel;
  List<ListResultProduct> items = [];
  String deliveryTimeSlot;
  DateTime deliveryDate;
  ReviewCartScreen(
      {Key key,
      this.items,
      this.storemodel,
      this.totalprice,
      this.deliveryTimeSlot,
      this.deliveryDate})
      : super(key: key);
  @override
  _ReviewCartScreenState createState() => _ReviewCartScreenState();
}

class _ReviewCartScreenState extends State<ReviewCartScreen> {
  var formatter = new date.DateFormat('dd-MM-yyyy');
  String dropdownError;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  ApiConnector api = new ApiConnector();
  LocalData localData = new LocalData();
  int _userid;
  String _mySelection;
  final countryurl = BASEURL + COUNTRY_URL;
  final cityurl = BASEURL + CITYBYCOUNTRY_URL;
  CartModel cartitemsfromApi;
  int _userIDLocal;
TextEditingController landmarkControler = new TextEditingController();
TextEditingController addressControler = new TextEditingController();
TextEditingController areaControler = new TextEditingController();

  Future getAllCountries() async {
    var res = await http.get(Uri.encodeFull(countryurl),
        headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      countryModel = Countrymodel.fromJson(resBody);
      countyrsArray = countryModel.listResult;
    });
    print(resBody);
  }

  _validateForm() {
    bool _isValid = _formKey.currentState.validate();

    if (countryModel == null) {
      setState(() => dropdownError = "Please select an option!");
      _isValid = false;
    }

    if (_isValid) {
      //form is valid
    }
  }

  Future getCitiesByCountryId() async {
    var res = await http
        .get(Uri.encodeFull(cityurl), headers: {"Accept": "application/json"});
    var resCity = json.decode(res.body);
    print("---------->>>>>>>" + resCity.toString());

    setState(() {
      cityModel = CityModel.fromJson(resCity);
    });
    print(resCity);
  }
  
    Future<void> getUserInformation() async {
    await localData.getIntToSF(LocalData.USERID).then((userID) {
      setState(() {
        api.getUserInfo(userID).then((response) {
          setState(() {
            if (response != null) {
 
              addressControler.text = response.listResult[0].address;
              landmarkControler.text = response.listResult[0].landmark;
             areaControler.text=response.listResult[0].locationName1;


            }
            // getAreaNamesAPICalling();
          });
        });
      });
    });
  }
  @override
  void initState() {
    super.initState();
    localData.getIntToSF(LocalData.USERID).then((useridlocal) {
      _userid = useridlocal;
    });
getUserInformation();
    countryModel = new Countrymodel();
    cityModel = new CityModel();
    //countyrsArray = new List();
    // getAllCountries();
    // getCitiesByCountryId();
    localData.getIntToSF(LocalData.USERID).then((userid) {
    _userIDLocal =userid;
      api.getCartInfo(userid).then((cartinfo) {
        setState(() {
          if (cartinfo.result != null) {
           cartitemsfromApi = cartinfo;
          }
        });
      });
    });

      localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityname = TextFormField(
      enabled: false,
      keyboardType: TextInputType.text,
      initialValue: 'Riyadh',
      autofocus: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? "اسم المستخدم"  : 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Colors.green[900],
                  Colors.green[900],
                  Colors.green[900]
                ])),
          ),
        title: Text(isArabic == true ? "مراجعة الطلب"  : 'Review Order' ),
      ),
      body: Directionality(textDirection:  isArabic == true ? TextDirection.rtl :TextDirection.ltr ,
              child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
        Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    enabled: false,
                    initialValue: isArabic == true ? 'المملكة العربية السعودية' : 'Saudi Arabia',
                    decoration: InputDecoration(
                        labelText: isArabic == true ? "بلد"  : 'Country',
                        // labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    enabled: false,
                    initialValue: isArabic == true ? "مدينة الرياض"  : 'Riyadh',
                    decoration: InputDecoration(
                        labelText: isArabic == true ? "مدينة"  : 'City',
                        // labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                    Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    enabled: false,
                    initialValue: date.DateFormat('dd-MM-yyyy').format( this.widget.deliveryDate),
                    decoration: InputDecoration(
                        labelText: isArabic == true ? "تاريخ التسليم او الوصول"  : 'Delivery Date',
                        // labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    enabled: false,
                    initialValue: this.widget.deliveryTimeSlot,
                    decoration: InputDecoration(
                        labelText: isArabic == true ? "فتحة التسليم"  : 'Delivery Slot',
                        // labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              //   Padding(
              //     padding: EdgeInsets.all(15.0),
              //     child: TextFormField(
              //       controller: landmarkControler,
              //       validator: (value) =>
              //           value.isEmpty ? 'Field is required' : null,
              //       decoration: InputDecoration(
              //           labelText: 'Full Address',
              //           // labelStyle: textStyle,
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0))),
              //     ),
              //   ),
              //                    Padding(
              //   padding: EdgeInsets.all(10.0),
              //   child: Container(
                
              //     alignment: Alignment(0.0, 0.0),
                 
              //     height: 60.0,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5.0),
              //         border: Border.all(color: Colors.grey)),
              //     child: areaNamesArray == null
              //         ? Text('')
              //         :
              //          DropdownButton<ListResultAreaModel>(
              //             isExpanded: true,
              //             icon: Icon(
              //               Icons.arrow_drop_down,
              //               size: 24,
              //             ),
              //             hint: Text(
              //               "Select Area",
              //               style: TextStyle(color: Color(0xFF9F9F9F)),
              //             ),
              //             items: areaNamesArray.map((foo) {
              //               return DropdownMenuItem(
              //                 value: foo,
              //                 child: Text(foo.areaName1),
              //               );
              //             }).toList(),
              //             onChanged: (value) {
              //               setState(() {
              //                 selectedcity = value;
              //                  selectedAreaId = selectedcity.cityId;
              //               });
              //             },
              //             value: selectedcity,
              //           ),
                      
              //   ),
              // ),
               Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: areaControler,
                  validator: (value) =>
                      value.isEmpty ? isArabic == true ? "مطلوب منطقة"  : 'Area is required' : null,
                  decoration: InputDecoration(
                      labelText: isArabic == true ? "منطقة"  : 'Area',
                      // labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: addressControler,
                  validator: (value) =>
                      value.isEmpty ? isArabic == true ? "العنوان الكامل مطلوب"  : 'Full Address is required' : null,
                  decoration: InputDecoration(
                      labelText: isArabic == true ? "العنوان الكامل"  : 'Full Address',
                      // labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
                              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: landmarkControler,
                  validator: (value) =>
                      value.isEmpty ? isArabic == true ? "مطلوب معلم"  : 'Landmark is required' : null,
                  decoration: InputDecoration(
                      labelText: isArabic == true ? "معلم معروف"  : 'Landmark',
                      // labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              ],
            ),
          ),
        ),
        GradientText(
          isArabic == true ? "التكلفة الإجمالية"  : 'Total Cost:  ' +
              this.widget.totalprice.toStringAsFixed(2) +
              ' SAR',
           gradient: LinearGradient(
    colors: [Colors.deepPurple, Colors.deepOrange, Colors.pink]),
    style: TextStyle(fontSize: 15),
    textAlign: TextAlign.center),
        Container(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: RaisedGradientButton(
                child: Text(
                  isArabic == true ? "مكان الامر"  : 'Place Order',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.green[900], Colors.green[900]],
                ),
                onPressed: () {
                  _validateForm();
                if (true) {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    localData.addStringToSF(LocalData.CARTINFO, null);
                    PlaceOrdermodel ordermodel = new PlaceOrdermodel();

                    List<Product> products = [];

                    for (int j = 0; j < cartitemsfromApi.result.productsList.length; j++) {
                      products.add(new Product(
                          price: cartitemsfromApi.result.productsList[j].price,
                          productId: cartitemsfromApi.result.productsList[j].productId,
                          quantity: cartitemsfromApi.result.productsList[j].quantity));
                    }
                    ordermodel.order = Order(
                        userId: _userid,
                        address: addressControler.text,
                        cityName: 'Saudi Arabia',
                        deliveryDate: this.widget.deliveryDate,
                        landmark: landmarkControler.value.text,
                        postalCode: isArabic == true ? "الكود البريدى"  : 'Postal code',
                        storeId: this.widget.storemodel,
                        timeSlot: this.widget.deliveryTimeSlot,
                        totalPrice: this.widget.totalprice);
                    ordermodel.products = products;
                    api.placeOrder(ordermodel).then((valcode) {
                      if (valcode == 200) {
                        
                        Toast.show(isArabic == true ? "تم تقديم الطلب بنجاح"  : 'Order Placed Successfully', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM);

                            api.deleteCart(_userIDLocal);
                          Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } else {
                        Toast.show(isArabic == true ? "تعذر تقديم الطلب الآن"  : 'Unable to Place Order now', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.CENTER);
                      }
                    });
                  }
                } else {
                  Toast.show(isArabic == true ? "يرجى تحديد العنوان"  : 'Please Select Address', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                // else {
                //   setState(() {
                //     _autovalidate = true; //enable realtime validation
                //   });
                // }

                //Navigator.push(context, MaterialPageRoute(builder: (context) => DeliverySlotScreen()));
                }),  
          ),
               
        )
              ],
            ),
          ),
      ),
    );
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("SPAR"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}

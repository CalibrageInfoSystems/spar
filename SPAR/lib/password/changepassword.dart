import 'dart:convert';
import 'package:alsadhan/SignUp/SignUpScreen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/login/login.dart';

import 'package:alsadhan/models/ChPasswordModel.dart';
import 'package:alsadhan/models/UserInfoModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/widgets/RaisedGradientButton.dart';
import 'package:alsadhan/widgets/Validator.dart';
import 'package:flutter/material.dart';
import 'package:alsadhan/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

LocalData localData = new LocalData();
UserInfoModel userInfoModel = new UserInfoModel();
ProgressDialog pr;
bool isArabic = false;

String passward;
String userID;
GlobalKey<FormState> key = new GlobalKey();
TextEditingController oldpasswordController = new TextEditingController();
TextEditingController newpasswordController = new TextEditingController();
TextEditingController conpasswordController = new TextEditingController();

 ChPasswordModel chPasswordModel = new ChPasswordModel();

class ChangePasswordScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;

  // const ChangePasswordScreen({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
 
  bool autovalidate = false;
  ApiConnector api = new ApiConnector();
  
  @override
  void initState() {
    super.initState();
    // key = new GlobalKey();
    oldpasswordController.text = "";
    newpasswordController.text = "";
    conpasswordController.text = "";
    chPasswordModel =new ChPasswordModel();
     userInfoModel =new UserInfoModel();

         localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });

     getUserInformation();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(isArabic == true ? "تغيير كلمة السر"  : 'Change Password'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.green[900],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Directionality( textDirection: isArabic == true ? TextDirection.rtl :TextDirection.ltr,
              child:
          Form(
            key: key,
            autovalidate: autovalidate,
            child: Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextFormField(   
                      controller: oldpasswordController, 
                      obscureText: true,
                      validator: oldPasswordValidateOldPassowrd,
                      // (value) =>
                      //     value.isEmpty ? 'Please Enter Old Password' : null,                                      
                      decoration: InputDecoration(
                          labelText: isArabic == true ? "كلمة المرور القديمة"  : 'Old Password *',
                          // labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: newpasswordController, 
                      validator: newPasswordValidatePassowrd,                                             
                      decoration: InputDecoration(
                          labelText: isArabic == true ? "كلمة مرور جديدة"  : 'New Password *',
                          // labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(   
                      obscureText: true,
                      
                      controller: conpasswordController, 
                      validator: conformPasswordValidatePassowrd,                    
                      decoration: InputDecoration(
                          labelText: isArabic == true ? "تأكيد كلمة المرور"  : 'Confirm Password *',                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedGradientButton(
                        child: Text(
                          isArabic == true ? "إرسال"  : 'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.green[900],
                            Colors.green[900]
                          ],
                        ),
                        onPressed: () {
                          if (key.currentState.validate()) {
                            key.currentState.save();  
                            //  if(validateData(context)){
                           if(newpasswordController.text==conpasswordController.text)
                             {
                            // pr.show();                            
                             changePasswordApiCalling(context).then((code){
                             oldpasswordController.clear();
                             newpasswordController.clear();
                             conpasswordController.clear();
                             pr.dismiss();
                             });                             
                             } 
                              else {
                   Toast.show(isArabic == true ? "يجب أن تتطابق كلمة المرور القديمة وكلمة المرور الجديدة"  : "Old Password and New Password Should Match", context,
                   duration: Toast.LENGTH_LONG,
                   gravity: Toast.BOTTOM);
                   }                              
                            }   
                             // });
                           else {
                            autovalidate = true;
                          }
                        }),
                  ),
                ],
              ),
            ),
          )
              )
        ])));
  }

 Future<void> getUserInformation() async {
    await localData.getIntToSF(LocalData.USERID).then((userID) {
      setState(() {
        api.getUserInfo(userID).then((response) {
          setState(() {
            if (response != null) {
              userInfoModel = response;
              print('::: Useinformation :::: ' +
              userInfoModel.listResult.toString());
             
              passward = userInfoModel.listResult[0].password;         

               print("--- PASSWORD --> " + passward);                
            }
           
          });
        });
      });
    });
  }

 }
 
  Future<int> changePasswordApiCalling(BuildContext context) async {
  int code = 101;
  final passwordAPI = BASEURL +CHANGE_PASSWORD;
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
  "UserId": userInfoModel.listResult[0].userId,
	"OldPassword": oldpasswordController.value.text,
	"NewPassword": newpasswordController.value.text,
	"ConfirmPassword":conpasswordController.value.text
   };

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  print('Request body -->> :' + jsonBody);

  Response response = await post(
    passwordAPI,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );
  int statusCode = response.statusCode;
  code = statusCode;
  String responseBody = response.body;

  print('RES--------======--------> :' + responseBody);

  if (statusCode == 200) {
    print('status code 200');
    var userresponce = json.decode(responseBody);
    print('status code 200 -- >> ' + userresponce.toString());

    if (userresponce["IsSuccess"] == true) {
      Toast.show(userresponce["EndUserMessage"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      
    } else {
      Toast.show(userresponce["EndUserMessage"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  } else {
    print('status code not 200 -- >>');
  }
  return code;
}

  bool validateData(BuildContext context) {
  if (Validator.validatePasswordLength(
          context, oldpasswordController.value.text ,isArabic) !=
      null) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(Validator.validatePasswordLength(
            context, oldpasswordController.value.text , isArabic))));
    return false;
    } else if (Validator.validateconfirmPasswordLength(
          context, newpasswordController.value.text , isArabic) !=
      null) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(Validator.validateconfirmPasswordLength(
            context, newpasswordController.value.text ,isArabic))));
    return false;
  } else if (Validator.validateconfirmPasswordLength(
          context, conpasswordController.value.text, isArabic) !=
      null) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(Validator.validateconfirmPasswordLength(
            context, conpasswordController.value.text ,isArabic))));

    return false;
  } else if (newpasswordController.text !=
      conpasswordController.text) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      isArabic == true ? "كلمة المرور الجديدة وتأكيد كلمة المرور يجب أن تتطابق"  : "New Password And Confirm Password Must Match",
      //'Password And Confirm Password Must Match'
    )));
    return false;
  } else {
    return true;
  }
}


  String oldPasswordValidateOldPassowrd(String value) {
    if(value.isEmpty){
      return isArabic == true ? "كلمة المرور القديمة مطلوبة"  : 'Old password is required';
    }    
    else if(oldpasswordController.value.text!=userInfoModel.listResult[0].password){
      return isArabic == true ? "كلمة السر القديمة غير صحيحة"  : 'Incorrect old password';
    }
    else
      return null;
  }

  String newPasswordValidatePassowrd  (String value) {
    if(value.isEmpty){
      return isArabic == true ? "كلمة المرور القديمة مطلوبة"  : 'New password is required';
    }
    else if (value.length < 6)
      return isArabic == true ? "يجب أن تكون كلمة المرور أكثر من 6 أحرف"  : 'New Password must be more than 6 characters';   
    else
      return null;
  }

   String conformPasswordValidatePassowrd (String value) {
    if(value.isEmpty){
      return isArabic == true ? "تأكيد كلمة المرور مطلوب"  : 'Confirm password is required';
    }
    else if (value.length < 6)
      return isArabic == true ? "يجب أن يكون تأكيد كلمة المرور أكثر من 6 أحرف"  : 'Confirm Password must be more than 6 characters';   
    else
      return null;
  }

// String validateConPassowrd(String value) {
//     if(value.isEmpty){
//       return 'Field is required';
//     }    
//     else if(newpasswordController.text!=conpasswordController.text){
//       return 'New Password and Old Password Must match';
//     }
//     else
//       return null;
//   }

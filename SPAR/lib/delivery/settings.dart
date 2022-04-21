
import 'package:alsadhan/home/ProfileScreen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:flutter/material.dart';
import 'package:alsadhan/address.dart';


bool isArabic = false;
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  LocalData localData = new LocalData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(
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
                  title: Center(
                    child: Text(isArabic == true ? "الإعدادات"  : 'Settings'),
                  ),
                  actions: <Widget>[
                IconButton(icon: Icon(Icons.close,size: 30.0), onPressed: () => Navigator.of(context).pop()),        
               ],
 
               
        backgroundColor: Colors.green,
         ),
        body:Directionality( textDirection: isArabic == true ? TextDirection.rtl :TextDirection.ltr,
             child: 
        ListView(
          children: <Widget>[
            ListTile(
              title:  Text(isArabic == true ? "موقع التسليم"  : "Delivery Location", style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold) ),
              subtitle: Text(isArabic == true ? "البلد / المملكة العربية السعودية"  : 'Country/Saudi Arabia'),
              trailing: new IconButton(icon:  Icon(Icons.keyboard_arrow_right,color: Colors.green[900]),
              
             onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
                         })
            ),
            // Divider(color: Colors.green,),
            // ListTile(
            //   title:  Text("Delivery Mode",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold)),
            //   subtitle: Text('Home Delivery'),
            //   trailing: new IconButton(icon:  Icon(Icons.keyboard_arrow_right,color: Colors.green[900]),
            //  onPressed: (){}
            //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
                         
            //              )
            // ),
            
            Divider(color: Colors.green),
            // ListTile(
            //   title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
            //   subtitle: Text('Date Time'),
            //   trailing: new IconButton(icon:  Icon(Icons.keyboard_arrow_right),
            //  onPressed: (){
            //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => DeliverySlotScreen()));
            //              })
            
            // ),
            // Divider(),
            // ListTile(
            //   title:  Text("Language",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold)),
            //   subtitle: Text('English'),
            //   trailing: new IconButton(icon:  Icon(Icons.keyboard_arrow_right, color: Colors.green[900],),
            //  onPressed: (){
                             
            //              })
            // ),
            //  Divider(color: Colors.green),
             ListTile(
              title:  Text(isArabic == true ? 'الملف الشخصي': "Profile",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold)),
              //subtitle: Text('English'),
              trailing: new IconButton(icon:  Icon(Icons.keyboard_arrow_right, color: Colors.green[900],),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                             
                         })
            ),
            Divider(color: Colors.green),
          ],
          
        ))
    );
  }

  
}

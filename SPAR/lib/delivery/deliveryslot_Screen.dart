import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:flutter/material.dart';

bool isArabic = false;

class TabbedAppBarSample extends StatefulWidget {
  @override
  _TabbedAppBarSampleState createState() => _TabbedAppBarSampleState();
}

class _TabbedAppBarSampleState extends State<TabbedAppBarSample> {
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
       return DefaultTabController(
        length: 8,
        child: new Scaffold(
          appBar: new AppBar(
           title: Center(
            child: Text(isArabic == true ? "اختر فتحة التسليم"  : 'Choose Delivery Slot'),
            ),
            bottom: PreferredSize(
              child: TabBar(
              isScrollable: true, 
               unselectedLabelColor: Colors.white.withOpacity(0.3),
               indicatorColor: Colors.white,
              tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
             Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
               Tab(text: 'Tab 3'),
             Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3')
            ]), 
            preferredSize: Size.fromHeight(30.0)),
              
          ),
          body: new TabBarView(
            children: [
              new ListView(
                children: <Widget>[
                 new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
                ]
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
             new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListView(
                children: <Widget>[
                 new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
              new ListTile(
                 title:  Text("Delivery Slot",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text('Date Time'),
              ),
                ]
              ),
            ],
          ),
        ),
       );
    
  }
}

List<Widget> list = <Widget>[
  new ListTile(
    title: new Text('Date Time',
        style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: new Text('Date Time'),
   
  ),
  new ListTile(
    title: new Text('Date Time',
        style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
        subtitle: new Text('Date Time'),
   
  ),
  new Divider(),
  new ListTile(
    title: new Text('Date Time',
        style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: new Text('Date Time'),
    
  ),
  

];


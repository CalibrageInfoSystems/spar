// import 'package:alsadhan/cart/reviewCart.dart';
// import 'package:alsadhan/models/StoreModel.dart';

import 'package:alsadhan/home/DeliverySlotScreen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/ProductsModel.dart';
import 'package:alsadhan/models/StoreModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class StoreScreen extends StatefulWidget {
  double totalprice;
  List<ListResultProduct> items = [];
  StoreScreen({Key key, this.items, this.totalprice}) : super(key: key);
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  Map data;
  List userData;
  bool isArabic = false;
  ApiConnector api;
  StoresModel storeModel;
  LocalData localData = new LocalData();
  @override
  Future<void> initState() {
    super.initState();
    api = new ApiConnector();
    storeModel = new StoresModel();
    super.initState();
    // getstoredata();

    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });

    api.getStores().then((storesmodelfromapi) {
      setState(() {
        storeModel = storesmodelfromapi;
      });
    });
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
        title: new Text(isArabic == true ? 'حدد المتجر' : 'Slect Store'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
            itemCount: storeModel.listResult == null
                ? 0
                : storeModel.listResult.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(1),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(3),
                    //     border: Border.all(color: Colors.green[900])),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliverySlotScreen(
                                    totalprice: this.widget.totalprice,
                                    items: this.widget.items,
                                    storemodel: storeModel.listResult[index])));
                      },
                      leading: Image(width: 80, image: storeModel.listResult[index].filepath  == null ? AssetImage("images/spar_appicon.jpg")  : NetworkImage(storeModel.listResult[index].filepath)),
                      title: Column(
                        children: <Widget>[
                          Text(
                            isArabic == true
                                ? storeModel.listResult[index].name2
                                : storeModel.listResult[index].name1,
                            style: TextStyle(color: Colors.green[900]),
                          ),
                          Divider(),
                        ],
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(storeModel.listResult[index].address == null ? "" : storeModel.listResult[index].address)
                          // Text(
                          //     'Full Address : ' +
                          //     storeModel.listResult[index].fullAddress ==null? '':storeModel.listResult[index].fullAddress+
                          //     '\n' +
                          //     'Land Mark   : ' +
                          //     storeModel.listResult[index].landmark ==null ? '' :storeModel.listResult[index].landmark),
                          //     Text('')
                        ],
                      ),
                    )),
              );
            }),
      ),
    );
  }
}

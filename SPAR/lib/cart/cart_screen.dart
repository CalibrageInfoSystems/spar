import 'dart:convert';


import 'package:alsadhan/home/home_screen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/CartModel_data.dart';
import 'package:alsadhan/models/PostCartModel.dart';
import 'package:alsadhan/models/ProductsModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/store/stores_screen.dart';
import 'package:alsadhan/widgets/RaisedGradientButton.dart';
import 'package:alsadhan/widgets/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:toast/toast.dart';

bool isArabic = false;

class CartItemsScreen extends StatefulWidget {
  String catid;
  String searachstring;
  bool fromproducts;

  CartItemsScreen({Key key, this.catid, this.searachstring, this.fromproducts})
      : super(key: key);
  @override
  _CartItemsScreenState createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  BuildContext ctx;
  String strcartInfo = isArabic == true ? "جلب البيانات" : 'Fetching Data';
  double totalcost = 0.0;
  LocalData localData = new LocalData();
  ApiConnector api;
  CartModel cart;
  @override
  void initState() {
    super.initState();
    api = new ApiConnector();
    double productCost = 0.0;

    localData.getIntToSF(LocalData.USERID).then((userid) {
      api.getCartInfo(userid).then((cartinfo) {
        setState(() {
          cart = cartinfo;
          if (cartinfo.result == null) {
            strcartInfo = isArabic == true ? "لا توجد منتجات متاحة /n  ابدأ التسوق "  : 'No Products Available \n    Start Shopping';
          } else if (cartinfo.result != null) {
            for (int i = 0; i < cartinfo.result.productsList.length; i++) {
              double item = cartinfo.result.productsList[i].discountedPrice *
                  cartinfo.result.productsList[i].quantity;

              productCost += item;
            }
            totalcost = productCost;
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
showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(isArabic == true ? "إلغاء"  : "Cancel"),
    onPressed:  () {
      Navigator.pop(ctx);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(isArabic == true ? "استمر"  : "Continue"),
    onPressed:  () {
      Navigator.pop(ctx);
 api
                          .deleteCart(cart.result.cart.userId)
                          .then((deletecartCode) {
                        if (deletecartCode == 200) {
                          setState(() {
                            strcartInfo = isArabic == true ? "لا توجد منتجات متاحة"  : 'No Products Avaialble';
                            cart = new CartModel();
                            totalcost = 0;
                          });
                        } 
                        else {
                          Toast.show(isArabic == true ? "تعذر مسح السلة"  : 'Unable To Clear Cart', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                          localData.addStringToSF(LocalData.CARTINFO, null);
                        }
                      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(isArabic == true ? "إنذار"  : "Alert"),
    content: Text(isArabic == true ? "هل ترغب في الاستمرار؟"  : "Would you like to continue?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: (){

        print('********* call Home Screen ***********');
     Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeScreen()));
       return Future.value(false);
      },
          child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(isArabic == true ? 'عربة التسوق':'Cart', style: TextStyle(fontSize: 16.0)),
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
          
          actions: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 20, right: 20),
                child: Text(isArabic == true ? 'مجموع : '  + totalcost.toStringAsFixed(2)+' SAR' : 'Total : ' + totalcost.toStringAsFixed(2)+' SAR')),
            Card(
                margin: EdgeInsets.all(10),
                color: Colors.white,
                child: InkWell(
                    onTap: () {
                      if (cart.result != null) {
                        showAlertDialog(ctx);
                       
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(isArabic == true ? 'عربة واضحة':
                          'Clear Cart',
                          style: TextStyle(color: Colors.green[900]),
                        ))))
          ],
        ),
        body: Directionality( textDirection: isArabic == true ? TextDirection.rtl :TextDirection.ltr,
             child:
             Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: cart == null || cart.result == null
                    ? Center(child: Text(strcartInfo))
                    : ListView.builder(
                        itemCount: cart.result == null
                            ? 0
                            : cart.result.productsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: Image(
                                width: 100,
                                height: 250,
                                image: cart.result.productsList[index].filepath  == null ? AssetImage("images/spar_appicon.jpg")  : NetworkImage(
                                    cart.result.productsList[index].filepath),
                              ),
                              title: GradientText(isArabic == true ?cart.result.productsList[index].name2 :
                                  cart.result.productsList[index].name1,
                                  gradient: LinearGradient(colors: [
                                    Colors.green,
                                    Colors.deepOrange,
                                    Colors.pink
                                  ]),
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center),
                              // subtitle: Text(this.widget.items[index].description1),
                              subtitle: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(isArabic == true ? "السعر :" + cart.result.productsList[index].price
                                          .toString() +
                                      ' SAR' : 'Price :' +
                                      cart.result.productsList[index].price
                                          .toString() +
                                      ' SAR'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border:
                                            Border.all(color: Colors.green[900])),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  cart.result.productsList[index]
                                                      .quantity--;
                                                  _removeItem(cart.result
                                                      .productsList[index]);
                                                },
                                                child: Icon(Icons.remove))),
                                        Text(cart
                                            .result.productsList[index].quantity
                                            .toString()),
                                        Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  cart.result.productsList[index]
                                                      .quantity++;

                                                  _additem(cart.result
                                                      .productsList[index]);
                                                },
                                                child: Icon(Icons.add))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),

              // Text('Total Cost :' + totalcost.toStringAsFixed(2)),
              SizedBox(
                width: double.infinity,
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: RaisedGradientButton(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.green, Colors.green[900]],
                      ),
                      child: Text(
                        isArabic == true ? "إرسال"  : 'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (totalcost == 0) {
                          Toast.show(isArabic == true ? "الرجاء تحديد منتج واحد على الأقل"  : 'Please Select Atleast One Product', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                          localData.addStringToSF(LocalData.CARTINFO, null);

                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          PostCartModel cartModel = new PostCartModel();

                          if (cart.result != null) {
                            cartModel.cart = new CartPostInfo(
                                id: cart.result.cart.id,
                                userId: cart.result.cart.userId,
                                name: cart.result.cart.name);
                          }
                          List<ProductsListModelCart> productsforpost = [];

                          for (int i = 0;
                              i < cart.result.productsList.length;
                              i++) {
                            productsforpost.add(new ProductsListModelCart(
                                productId: cart.result.productsList[i].productId,
                                quantity: cart.result.productsList[i].quantity));
                          }
                          cartModel.productsList = productsforpost;
                          api.postCartUpdate(cartModel).then((cartResponce) {
                            if (cartResponce == 200) {
                              Navigator.of(context)
                                  .push(new MaterialPageRoute(
                                      builder: (context) => StoreScreen(
                                            items: null,
                                            totalprice: totalcost,
                                          )));
                            } else {
                              Toast.show(isArabic == true ? "غير قادر على المضي قدما"  : 'Unable to Proceed', context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                          });
                        }
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }

  void saveallproductsincart(List<ListResultProduct> data) {
    String dataString = placeOrdermodelToJson(data);
    print('------> orders String :' + dataString);
    localData.addStringToSF(LocalData.CARTINFO, dataString);
  }

  String placeOrdermodelToJson(List<ListResultProduct> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  void _removeItem(ProductsList fromlist) {
    setState(() {
      var items = cart.result.productsList
          .where((p) => p.productId == fromlist.productId)
          .toList();
      if (items != null && items.length > 0) {
        int index = cart.result.productsList
            .indexWhere((pro) => pro.productId == fromlist.productId);
        cart.result.productsList
            .removeWhere((pro) => pro.productId == fromlist.productId);
        if (fromlist.quantity > 0) {
          cart.result.productsList.insert(index, fromlist);
        } else {
          print("not more than One");
        }

        print('Removed item ');
      } else {
        print('Not exist in list  ');
      }

      double productCost = 0.0;
      for (int i = 0; i < cart.result.productsList.length; i++) {
        double item = cart.result.productsList[i].discountedPrice *
            cart.result.productsList[i].quantity;

        productCost += item;
      }
      totalcost = productCost;
    });
  }

  void _additem(ProductsList additem) {
    setState(() {
      var items = cart.result.productsList
          .where((p) => p.productId == additem.productId)
          .toList();

      if (items != null && items.length > 0) {
        int index = cart.result.productsList
            .indexWhere((pro) => pro.productId == additem.productId);
        cart.result.productsList
            .removeWhere((item) => item.productId == additem.productId);
        cart.result.productsList.insert(index, additem);
        print('Item Update   (+++)**************************** ID :' +
            additem.productId.toString());
      } else {
        cart.result.productsList.add(additem);
        print('Item Added   (+++)**************************** ID :' +
            additem.productId.toString());
      }

      // cartitemcount = cartProducts.length;
      double productCost = 0.0;
      for (int i = 0; i < cart.result.productsList.length; i++) {
        double item = cart.result.productsList[i].discountedPrice *
            cart.result.productsList[i].quantity;

        productCost += item;
      }
      totalcost = productCost;
    });
  }
}

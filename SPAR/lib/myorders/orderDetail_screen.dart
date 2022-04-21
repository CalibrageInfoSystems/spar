import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/DeliveryOrder.dart';
import 'package:alsadhan/models/MyordersModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Datetime;

bool isArabic = false;

class OrderDetailViewScreen extends StatefulWidget {
  ListResultMyorder order;
  OrderDetailViewScreen({this.order});

  @override
  _OrderDetailViewScreenState createState() => _OrderDetailViewScreenState();
}

class _OrderDetailViewScreenState extends State<OrderDetailViewScreen> {
    LocalData localData = new LocalData();
  ApiConnector apiConnector;
  DeliveryOrder orderDetails;
    var formatter = new Datetime.DateFormat('dd-MM-yyyy HH:mm aa');

  @override
  void initState() {    
    super.initState();
    apiConnector = new ApiConnector();
    apiConnector
        .getOrderDetails(this.widget.order.id.toString())
        .then((orderDetailsfromapi) {
      setState(() {
        orderDetails = orderDetailsfromapi;
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
        title: new Text(isArabic == true ?"تفاصيل الطلب " :'Order Details'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Directionality( textDirection: isArabic == true ? TextDirection.rtl : TextDirection.ltr,
      child:  Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(isArabic == true ?"معلومات الطلب " :'Order Info ', style: TextStyle(color: Colors.green)),
                  Card(
                    margin: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(isArabic == true ?"رقم التعريف الخاص بالطلب :  " : 'Order ID : '),
                              Text(
                                this.widget.order.code,
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text(isArabic == true ?"اسم المتجر : " : 'Store Name  : '),
                              Text(
                                this.widget.order.storeName1,
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text(isArabic == true ?"عنوان :   " : 'Address  : '),
                               Expanded(
                                child: Text(
                                  
                                  this.widget.order.shippingAddress,
                                  style: TextStyle(color: Colors.green, ),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text(isArabic == true ?"تاريخ التسليم او الوصول : " :'Delivery Date  : '),
                              Text(
                                mainDate(this.widget.order.deliveryDate) + "   " + this.widget.order.timeSlot ,
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text(isArabic == true ?"السعر الكلي : " :'Total Price  : '),
                              Text(
                                this.widget.order.totalPrice.toStringAsFixed(2) + ' SAR',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: this.widget.order.deliveryAgentName == null
                          ? Divider()
                          : Card(
                              margin: EdgeInsets.all(5),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(isArabic == true ?   'اسم الوكيل :':'Delivery AgentName : '),
                                        Text(this.widget.order.deliveryAgentName, style: TextStyle(color: Colors.green),)
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: <Widget>[
                                        Text(isArabic == true ? 'رقم الاتصال :': 'ContactNumber : '),
                                        Text(this.widget.order.deliveryAgentContactNumber, style: TextStyle(color: Colors.green),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                ],
              ),
            ),
           
           
           SizedBox(
                        child: Text(isArabic == true ?"معلومات المنتجات " :
                          'Products Info',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
           
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: orderDetails == null
                        ? 0
                        : orderDetails.listResult.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Card(margin: EdgeInsets.all(2), child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(children: <Widget>[
                          Text(orderDetails.listResult[index].name1, style: TextStyle(color: Colors.green),),
                          Divider(),
                          Row( 
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(children: <Widget>[
Text(isArabic == true ?"السعر : " :'Price : ' + orderDetails.listResult[index].price.toStringAsFixed(2)),
                            SizedBox(width: 10,),
                            Text((isArabic == true ?"كمية : ":'Quantity : ') + orderDetails.listResult[index].quantity.toString()),
                              ],),
                              Row(children: <Widget>[
                                Text(isArabic == true ? "مجموع : " :'Total : '),
                                Text((orderDetails.listResult[index].quantity * orderDetails.listResult[index].price).toStringAsFixed(2) + ' SAR',style: TextStyle(color: Colors.green),)
                              ],)
                            
                          ],)
                          ,
                          SizedBox(height: 10)


                        ],),
                      ),);
                    }),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }

    mainDate(DateTime date) {
    var formatter = new Datetime.DateFormat('d MMMM y');
    String dates = formatter.format(date);
    print(dates); // something like 2013-04-20
    return dates;
  }
}

import 'package:alsadhan/home/FlutterExample.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:flutter/material.dart';

bool isArabic = false;

class AllCategoriesScreennew extends StatefulWidget {
  @override
  _AllCategoriesScreennewState createState() => _AllCategoriesScreennewState();
}

class _AllCategoriesScreennewState extends State<AllCategoriesScreennew> {
  LocalData localData = new LocalData();
  @override
    void initState() {  
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
      appBar:AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  
                  Colors.green[900]
                ])),
          ),
        title: Text(isArabic == true ? "جميع الفئات" : 'ALL CATEGORIES'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => Example(
                                from: null,
                                catids:
                                    "1,2,3,4,5,6,7,8,9,10,11,12,13,14,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,138,139,140,141,142,143,144,130,131,132,133,134,135,136,137,123,124,125,126,127,128,129,114,115,116,117,118,119,120,121,122,100,101,102,103,104,105,106,107,108,109,110,111,112,113,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,80,81,82,83,84,71,72,73,74,75,76,77,78,79,68,69,70,65,66,67,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43",
                                searchtext: null)));
                      },
                      child: Container(
                          padding: EdgeInsets.all(3),
                          child: Image(
                            image: isArabic == true ? AssetImage('images/spar-fresh-food-ar.jpg'): AssetImage('images/fresh-food-A.jpg'),
                          )))),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => Example(
                                from: null,
                                catids:
                                    "317,318,319,320,321,322,323,324,325,326,327,374,375,376,377,378,379,368,369,370,371,372,373,367,366,365,355,356,357,358,359,360,361,362,363,364,346,347,348,349,350,351,352,353,354,342,343,344,345,334,335,336,337,338,339,340,341,328,329,330,331,332,333",
                                searchtext: null)));
                      },
                      child: Container(
                          margin: EdgeInsets.all(3),
                          child: Image(
                             image:isArabic == true ? AssetImage('images/Category/spar-non-food-ar.jpg') : AssetImage('images/non_food_new2.jpg'),
                          ))))
            ],
          ),
          Container(
              margin: EdgeInsets.all(3),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => Example(
                            from: null,
                            catids:
                                "176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,315,316,308,309,310,311,312,313,314,303,304,305,306,307,289,290,291,292,293,294,295,296,297,298,299,300,301,302,281,282,283,284,285,286,287,288,268,269,270,271,272,273,274,275,276,277,278,279,280,264,265,266,267,261,262,263,253,254,255,256,257,258,259,260,247,248,249,250,251,252,238,239,240,241,242,243,244,245,246,233,234,235,236,237,226,227,228,229,230,231,232,221,222,223,224,225,215,216,217,218,219,220,201,202,203,204,205,206,207,208,209,210,211,212,213,214,194,195,196,197,198,199,200",
                            searchtext:   
                            null)));
                  },
                  child: Image(
                    image:isArabic == true ? AssetImage('images/Category/spar-food-beverages-ara.jpg') : AssetImage('images/food-beeverages-A.jpg'),
                  ))),
         

        ],
      )),
    );
  }
}

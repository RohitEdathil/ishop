import 'package:flutter/material.dart';
import 'package:ishop/custom_widgets/stat_cards.dart';
import 'package:ishop/data/firebase_authentication.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 45, 15, 0),
            height: 45,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  iconSize: 35,
                  color: Colors.grey,
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                )
              ],
            ),
          ),
          StatCard(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(15),
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                      children: [
                        HomeScreenButton(
                          icon: (Icons.inventory),
                          text: 'Inventory',
                        ),
                        HomeScreenButton(
                          icon: (Icons.shopping_cart),
                          text: 'Sales',
                        ),
                        HomeScreenButton(
                          icon: (Icons.lightbulb),
                          text: 'Products',
                        ),
                        HomeScreenButton(
                          icon: (Icons.exposure_minus_1),
                          text: 'Loss Entry',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButton(
                          onPressed: () {},
                          borderSide:
                              BorderSide(color: Colors.indigoAccent, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.indigoAccent),
                                Icon(
                                  Icons.inventory,
                                  color: Colors.indigoAccent,
                                  size: 35,
                                )
                              ],
                            ),
                          ),
                        ),
                        OutlineButton(
                          onPressed: () {},
                          borderSide:
                              BorderSide(color: Colors.indigoAccent, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.indigoAccent),
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.indigoAccent,
                                  size: 35,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  final IconData icon;
  final String text;
  HomeScreenButton({this.icon, this.text});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            this.icon,
            color: Colors.white,
            size: 30,
          ),
          Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ),
      color: Colors.indigoAccent[100],
      elevation: 0,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      splashColor: Colors.white,
    );
  }
}

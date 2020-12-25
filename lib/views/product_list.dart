import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishop/data/firebase_image_handler.dart';
import 'package:ishop/data/product_modal.dart';
import 'package:loading_animations/loading_animations.dart';

class ProductView extends StatefulWidget {
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String sortBy = 'productName';
  bool descending = false;

  void sort(String s, bool d) {
    setState(() {
      sortBy = s;
      descending = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/product_add');
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              'Products',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          SortBar(
            sortBy: sortBy,
            descending: descending,
            sort: sort,
          ),
          ProductList(
            sortBy: sortBy,
            descending: descending,
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}

class ProductList extends StatefulWidget {
  final String sortBy;
  final bool descending;
  ProductList({this.sortBy, this.descending});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Iterable sort(List<QueryDocumentSnapshot> rawList) {
    rawList[0][widget.sortBy] is String
        ? rawList.sort((a, b) => a[widget.sortBy]
            .toLowerCase()
            .compareTo(b[widget.sortBy].toLowerCase()))
        : rawList.sort((a, b) => a[widget.sortBy].compareTo(b[widget.sortBy]));
    return widget.descending ? rawList.reversed.toList() : rawList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getProductList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Text(
                'Something went wrong :(',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            )
          ]));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<QueryDocumentSnapshot> dataListRaw = snapshot.data.docs;
          List dataList = sort(dataListRaw);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300),
            delegate: SliverChildBuilderDelegate((context, index) {
              Map product = dataList[index].data();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductCard(
                  name: product['productName'],
                  description: product['description'],
                  imageName: product['imageName'],
                  sellingPrice: product['sellingPrice'],
                  id: dataList[index].id,
                ),
              );
            }, childCount: dataList.length),
          );
        }

        return SliverList(
            delegate: SliverChildListDelegate([
          LoadingJumpingLine.circle(
            backgroundColor: Theme.of(context).accentColor,
          )
        ]));
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageName;
  final double sellingPrice;
  final String id;
  ProductCard(
      {this.name,
      this.description,
      this.imageName,
      this.sellingPrice,
      this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product_view', arguments: {'id': id});
        },
        child: Stack(
          children: [
            imageName == ""
                ? Container(
                    color: Theme.of(context).accentColor,
                    child: Center(
                      child: Icon(
                        Icons.lightbulb,
                        color: Theme.of(context).backgroundColor,
                        size: 40,
                      ),
                    ),
                  )
                : FutureBuilder(
                    future: getPhoto('$imageName', 'productImages'),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? Image.network(snapshot.data)
                          : LoadingFlipping.square();
                    }),
            Align(
              alignment: Alignment.bottomLeft,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 50,
                    width: 300,
                    color: Colors.white30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('₹$sellingPrice')
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortBar extends StatefulWidget {
  final String sortBy;
  final bool descending;
  final Function sort;
  SortBar({this.sortBy, this.descending, this.sort});
  @override
  _SortBarState createState() => _SortBarState();
}

class _SortBarState extends State<SortBar> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SortButton(
              descending: widget.descending,
              sortBy: widget.sortBy,
              sort: widget.sort,
              displayName: 'Name',
              propertyName: 'productName',
            ),
            SortButton(
              descending: widget.descending,
              sortBy: widget.sortBy,
              sort: widget.sort,
              displayName: 'Selling Price',
              propertyName: 'sellingPrice',
            ),
            SortButton(
              descending: widget.descending,
              sortBy: widget.sortBy,
              sort: widget.sort,
              displayName: 'Created On',
              propertyName: 'createdOn',
            )
          ],
        ),
      ]),
    );
  }
}

class SortButton extends StatelessWidget {
  final String sortBy;
  final bool descending;
  final Function sort;
  final String propertyName;
  final String displayName;
  SortButton(
      {this.sortBy,
      this.descending,
      this.sort,
      this.propertyName,
      this.displayName});

  bool isActive() {
    return propertyName == sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        sort(propertyName, descending ? false : true);
      },
      child: Row(
        children: [
          Text(
            displayName,
            style: TextStyle(
                color:
                    isActive() ? Theme.of(context).accentColor : Colors.grey),
          ),
          !isActive()
              ? Icon(
                  Icons.minimize,
                  color: Colors.grey,
                  size: 15,
                )
              : descending
                  ? Icon(Icons.keyboard_arrow_down,
                      color: Theme.of(context).accentColor)
                  : Icon(Icons.keyboard_arrow_up,
                      color: Theme.of(context).accentColor),
        ],
      ),
    );
  }
}

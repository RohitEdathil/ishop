import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishop/data/firebase_image_handler.dart';
import 'package:ishop/data/product_modal.dart';
import 'package:loading_animations/loading_animations.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map lookUp = {
    'g': 'Weight/gram',
    'kg': 'Weight/Kg',
    'L': 'Volume/Litre',
    'm': 'Length/Metre',
    'no': 'Number/No.'
  };
  @override
  Widget build(BuildContext context) {
    Map values = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: FutureBuilder(
          future: getProductById(values['id']),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              DocumentSnapshot product = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          child: product['imageName'] == ""
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
                                  future: getPhoto('${product['imageName']}',
                                      'productImages'),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.done
                                        ? Image.network(
                                            snapshot.data,
                                            height: 300,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : LoadingFlipping.square();
                                  }),
                        ),
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 300,
                              width: double.maxFinite,
                              color: Colors.white30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product['productName'],
                                      style: TextStyle(fontSize: 35),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InfoTile(
                          item: 'Description',
                          value:
                              'jwbf fbqwfbuwi ifiqohf iwhqf owfhqo fwqfuhuqw fuqgqw ufuwqg ugwfuqg',
                        ),
                        InfoTile(
                          item: 'Unit',
                          value: lookUp[product['measure']],
                        ),
                        InfoTile(
                          item: 'Selling Price',
                          value: '₹' + product['sellingPrice'].toString(),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error'));
            }
            return Center(
              child: LoadingJumpingLine.circle(
                backgroundColor: Theme.of(context).accentColor,
              ),
            );
          }),
    );
  }
}

class InfoTile extends StatelessWidget {
  final item;
  final value;
  InfoTile({this.item, this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Text(
              '$item:',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$value',
              maxLines: 4,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

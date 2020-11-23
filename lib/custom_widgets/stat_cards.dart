import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  @override
  _StatCardState createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  final List<Widget> _cards = [
    generateCard(Text('Card1')),
    generateCard(Text('Card2')),
    generateCard(Text('Card3')),
    generateCard(Text('Card4')),
  ];

  int currentPageValue = 0;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 230,
          child: PageView.builder(
            itemCount: _cards.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (int page) {
              getChangedPageAndMoveBar(page);
            },
            itemBuilder: (context, index) {
              return _cards[index];
            },
          ),
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < _cards.length; i++)
                    if (i == currentPageValue) ...[circleBar(true)] else
                      circleBar(false),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

Widget generateCard(Widget content) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(child: content),
      ),
    ),
  );
}

Widget circleBar(bool isActive) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 8),
    height: isActive ? 12 : 8,
    width: isActive ? 12 : 8,
    decoration: BoxDecoration(
        color: isActive ? Colors.indigoAccent : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12))),
  );
}

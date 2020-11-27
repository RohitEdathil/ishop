import 'package:flutter/material.dart';

class ProductAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add a Product',
        ),
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: ProductForm(),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Form(
        child: Column(
          children: [
            ProductFormField(
              placeholder: 'Product Name',
            ),
            ProductFormField(
              placeholder: 'Description',
            ),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(
                  child: Text('Weight/Kg'),
                  value: 'kg',
                ),
                DropdownMenuItem(
                  child: Text('Weight/gram'),
                  value: 'g',
                ),
                DropdownMenuItem(
                  child: Text('Number'),
                  value: 'no',
                ),
                DropdownMenuItem(
                  child: Text('Litre'),
                  value: 'L',
                ),
                DropdownMenuItem(
                  child: Text('Metre'),
                  value: 'm',
                ),
              ],
              onChanged: (value) {},
              style: TextStyle(color: Theme.of(context).backgroundColor),
              dropdownColor: Theme.of(context).accentColor,
              iconEnabledColor: Colors.black,
              decoration: InputDecoration(
                  hintStyle:
                      TextStyle(color: Theme.of(context).backgroundColor),
                  hintText: 'Measured by',
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Theme.of(context).backgroundColor,
                      width: 5,
                    ),
                  )),
            ),
            ProductFormField(
              placeholder: 'Selling Price Per Unit',
              type: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductFormField extends StatefulWidget {
  final String placeholder;
  final TextInputType type;
  ProductFormField({this.placeholder, this.type});
  @override
  _ProductFormFieldState createState() => _ProductFormFieldState();
}

class _ProductFormFieldState extends State<ProductFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).backgroundColor),
      keyboardType: widget.type == null ? TextInputType.text : widget.type,
      decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: TextStyle(color: Theme.of(context).backgroundColor),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: 5,
            ),
          )),
    );
  }
}

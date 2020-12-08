import 'package:flutter/material.dart';
import 'package:ishop/custom_widgets/image_picker.dart';
import 'package:ishop/data/product_modal.dart';
import 'package:loading_animations/loading_animations.dart';

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
      body: SingleChildScrollView(child: ProductForm()),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final List textFieldsValue = [];
  bool loading = false;
  String measureChoice;
  Image productImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Form(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProductFormField(
                placeholder: 'Product Name',
                dataList: textFieldsValue,
              ),
              ProductFormField(
                placeholder: 'Description',
                dataList: textFieldsValue,
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
                    child: Text('Number/No.'),
                    value: 'no',
                  ),
                  DropdownMenuItem(
                    child: Text('Volume/Litre'),
                    value: 'L',
                  ),
                  DropdownMenuItem(
                    child: Text('Length/Metre'),
                    value: 'm',
                  ),
                ],
                onChanged: (value) {
                  measureChoice = value;
                },
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
                dataList: textFieldsValue,
                type: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  productImage = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImagePicker()));
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(100, 100, 100, 0.5),
                  ),
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OutlineButton(
                disabledBorderColor: Theme.of(context).backgroundColor,
                onPressed: loading
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          createProduct(textFieldsValue[0], textFieldsValue[1],
                                  measureChoice, textFieldsValue[2])
                              .then((value) {
                            if (value == 'OK') {
                              Navigator.pop(context);
                            }
                          });
                          setState(() {
                            loading = true;
                          });
                        }
                        textFieldsValue.clear();
                      },
                child: loading
                    ? LoadingBumpingLine.circle(
                        backgroundColor: Theme.of(context).backgroundColor,
                      )
                    : Text(
                        'Create',
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                borderSide:
                    BorderSide(color: Theme.of(context).backgroundColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductFormField extends StatefulWidget {
  final String placeholder;
  final TextInputType type;
  final List dataList;
  ProductFormField({this.placeholder, this.type, this.dataList});
  @override
  _ProductFormFieldState createState() => _ProductFormFieldState();
}

class _ProductFormFieldState extends State<ProductFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Field must not be empty';
          }
          widget.dataList.add(input);
          return null;
        },
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
            ),
            errorStyle: TextStyle(color: Theme.of(context).backgroundColor)),
      ),
    );
  }
}

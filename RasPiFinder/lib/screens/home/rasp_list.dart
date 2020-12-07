import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/screens/components/text_input_field.dart';
import 'package:RasPiFinder/screens/home/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RaspList extends StatefulWidget {
  final bool showSearch;

  RaspList({this.showSearch}) : super();

  @override
  _RaspListState createState() => _RaspListState();
}

class _RaspListState extends State<RaspList> {
  bool loading = false;
  String keyword;
  Future<QuerySnapshot> searchResult;
  List<Rasp> products = [];

  Widget noResult() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Icon(
            Icons.group,
            color: Colors.grey,
            size: 200,
          ),
          Text(
            'No results',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget renderProductsList() {
    List<Rasp> filteredProducts = products;
    if (keyword != '' && keyword != null) {
      filteredProducts = products
          .where((rasp) => rasp.getValuesString().contains(keyword))
          .toList();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        if (keyword != '' && keyword != null && filteredProducts.length == 0) {
          return noResult();
        }
        return ProductTile(rasp: filteredProducts[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showSearch = widget.showSearch;
    setState(() {
      products = Provider.of<List<Rasp>>(context) ?? [];
      keyword = showSearch ? keyword : '';
    });
    return Container(
      child: Column(
        children: <Widget>[
          showSearch
              ? TextInputField(
                  hintText: "Search for Pi",
                  icon: Icons.search,
                  onChanged: (value) {
                    setState(() {
                      keyword = value.toLowerCase().trim();
                    });
                  },
                )
              : Container(),
          Expanded(child: renderProductsList()),
        ],
      ),
    );
  }
}

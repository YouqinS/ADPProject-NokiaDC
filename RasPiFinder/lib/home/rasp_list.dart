import 'package:RasPiFinder/models/rasps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/home/product_tile.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/services/database.dart';

class RaspList extends StatefulWidget {
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(rasp: products[index]);
      },
    );
  }

  Widget _renderResults(BuildContext context) {
    if (keyword != '' && keyword != null) {
      return searchResult == null
          ? noResult()
          : FutureBuilder(
              future: searchResult,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                products = [];
                snapshot.data.documents.forEach((document) {
                  Rasp rasp = Rasp(
                    address: document['address'],
                    software: document['software'],
                    modelNumber: document['modelNumber'],
                  );
                  if (!products.contains(rasp)) {
                    products.add(rasp);
                  }
                });
                if (products.length == 0) {
                  return noResult();
                }
                return renderProductsList();
              },
            );
    } else {
      setState(() {
        products = Provider.of<List<Rasp>>(context) ?? [];
      });
      return renderProductsList();
    }
  }

  void _onSearch() async {
    if (keyword != '' && keyword != null) {
      setState(() {
        searchResult = DatabaseService().searchRasps(keyword);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              TextInputField(
                hintText: "Search by Pi name",
                icon: Icons.search,
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _onSearch,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Expanded(child: _renderResults(context)),
        ],
      ),
    );
  }
}

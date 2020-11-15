import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/database.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  String keyword;
  Future<QuerySnapshot> searchResult;
  final _biggerFont = TextStyle(fontSize: 18);

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

  Widget _renderResults() {
    return searchResult == null
        ? noResult()
        : FutureBuilder(
            future: searchResult,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              List<Rasp> _raspsList = [];
              snapshot.data.documents.forEach((document) {
                Rasp rasp = Rasp(
                  address: document['address'],
                  software: document['software'],
                  modelNumber: document['modelNumber'],
                );
                if (!_raspsList.contains(rasp)) {
                  _raspsList.add(rasp);
                }
              });
              if (_raspsList.length == 0) {
                return noResult();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _raspsList.length,
                itemBuilder: (context, i) {
                  return _buildRow(_raspsList[i]);
                },
                padding: EdgeInsets.all(16),
              );
            },
          );
  }

  Widget _buildRow(Rasp rasp) {
    return GestureDetector(
      onTap: () {
        //TODO prepare data needed for PiData Screen
        // navigateToPage(
        //     context,
        //     PiData(
        //       showUpdateBtn: false,
        //       showUnregisterBtn: false,
        //     ));
      },
      child: ListTile(
        title: Text(rasp.modelNumber.toString(), style: _biggerFont),
      ),
    );
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
        centerTitle: true,
      ),
      body: Container(
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
            Expanded(child: _renderResults()),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

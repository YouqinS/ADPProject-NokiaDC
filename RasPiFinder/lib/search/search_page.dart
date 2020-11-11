import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  String keyword;
  List<String> _results = [];
  final _biggerFont = TextStyle(fontSize: 18);

  Widget _renderResults() {
    return _results.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _results.length,
            itemBuilder: (context, i) {
              return _buildRow(_results[i]);
            },
            padding: EdgeInsets.all(16),
          )
        : Center();
  }

  Widget _buildRow(String name) {
    return GestureDetector(
      onTap: () {
       // navigateToPage(context, PiData(showUpdateBtn: false, showUnregisterBtn: false,));
      },
      child: ListTile(
        title: Text(name, style: _biggerFont),
      ),
    );
  }

  void _onSearch() {
    setState(() {
      _results.addAll(List<String>.generate(100, (i) => "Item $i"));
    });
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
                  onSaved: (value) {
                    keyword = value;
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

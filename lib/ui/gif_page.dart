import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

 final Map _gifData;

 GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"].toUpperCase(), style: TextStyle(fontSize: 15.0),),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            icon: Icon(Icons.share, color: Colors.white, size: 30.0),
          onPressed: (){
            Share.share(_gifData["images"]["fixed_height"]["url"]);
          },
          )],
      ),
      backgroundColor: Colors.black54,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

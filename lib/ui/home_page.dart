import 'dart:convert';
import 'package:share/share.dart';
import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _procurar;
  int _deslocar = 0;

  final _textoControle = TextEditingController();

  Future<Map> _pegarGifs() async {
    http.Response response;

    if (_procurar == null || _procurar.isEmpty) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=spVhCRTGr2XogoAmvjbO5F5NuZVzmYj1&limit=20&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=spVhCRTGr2XogoAmvjbO5F5NuZVzmYj1&q=$_procurar&limit=19&offset=$_deslocar&rating=G&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          Expanded(
              child: IconButton(
            iconSize: 400.0,
            icon: Image.network(
                "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
            onPressed: () {
              setState(() {
                _procurar = null;
                _textoControle.text = "";
              });
            },
          ))
        ],
      ),
      backgroundColor: Colors.black54,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquisar Gifs...",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              controller: _textoControle,
              onSubmitted: (text) {
                setState(() {
                  _procurar = text;
                  _deslocar = 0;
                });
                _textoControle.text = "";
              },
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0),
                child: Text(
                  "${_tituloBusca()}".toUpperCase(),
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: _pegarGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _criarTabelaGif(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  int _pegarCount(List data) {
    if (_procurar == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _criarTabelaGif(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data["data"].length == 0)
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, color: Colors.white, size: 50.0),
            Padding(
              padding: EdgeInsets.all(10.0),
              child:
              Text("SEM RESULTADOS",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            )],
        ),
      );
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _pegarCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_procurar == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
                Vibration.vibrate(duration: 50);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.expand_less, color: Colors.white, size: 70.0),
                    Text("VER OUTROS",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _deslocar += 19;
                  });
                },
              ),
            );
        });
  }

  String _tituloBusca() {
    if (_procurar == null)
      return "em alta";
    else
      return _procurar;
  }
}

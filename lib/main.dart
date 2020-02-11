import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:buscador_gifs/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
      home: HomePage(),
    theme: ThemeData(
        cursorColor: Colors.white, //cor do cursor piscando de textfilds
        textSelectionHandleColor: Colors.white, //cor das pazinhas de seleção de texto
        textSelectionColor: Colors.white70, //cor do texto selecionado
        accentColor: Colors.white, //cor de primeiro plano para widgets (botões, texto, efeito de borda de deslocamento excessivo, etc.).
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))
    ),
  ));
}


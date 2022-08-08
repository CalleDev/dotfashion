

import 'package:flutter/material.dart';
import 'package:ntlm/ntlm.dart';
import 'package:dotfashion/global.dart';
import 'dart:developer';
import 'package:xml/xml.dart';


class Authentication{
  CurrentUser currentUser =  CurrentUser();

  NTLMClient _client = new NTLMClient(
    domain: "LC",
    workstation: "",
    username: "",
    password: "",
  );

  void checkLogin(String user, String password){
    if (_client.username == "" || _client.username != user) {
      _client.username = user;
    }
    if (_client.password == "" || _client.password != password) {
      _client.password = password;
    }
    try {
      _client.get(Uri.parse("http://dotfashion.lanificiocolombo.it/Home/GetUtenteLoggato")).then((res) {
        if(res != null && res.statusCode!=200){
            AlertDialog(
            title: Text("Errore"),
            content: Text(
                'Utente o password errati'
            ),
            actions:[
              TextButton(
              child: Text('OK'),
              onPressed:()=> Navigator.pop
              )
            ],
            elevation: 24.0,
          );

        }
        if(res != null && res.statusCode==200){
          currentUser.user = user;
          currentUser.password = password;
        }
        final mail = XmlDocument.parse(res.body).findAllElements("MAIL").map((node) => node.text).first;
        final puntoVendita = XmlDocument.parse(res.body).findAllElements("PUNTOVENDITA").map((node) => node.text).first;
        final id = XmlDocument.parse(res.body).findAllElements("ID").map((node) => node.text).first;
        if (mail.toString().isNotEmpty){
          currentUser.email = mail.toString();
        }
        if (puntoVendita.toString().isNotEmpty){
          currentUser.pvId = int.parse(puntoVendita.toString());
        }
        if (id.toString().isNotEmpty){
          currentUser.id = int.parse(id.toString());
        }

        print(res.body);
        print(currentUser.toString());
        inspect(currentUser);
      });
    } catch (e, s) {

      print('error caught: $e');
      print('stack: $s');
    }

  }
}


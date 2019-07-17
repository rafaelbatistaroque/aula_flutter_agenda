import 'dart:io';

import 'package:aula_flutter_agenda/utils/utils.contact.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null)
      _editContact = Contact();
    else
      _editContact = Contact.fromMap(widget.contact.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildBotton(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(_editContact.name ?? "Novo Contato"),
      centerTitle: true
    );
  }
  Widget _buildBody(){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                image: DecorationImage(
                  image: _editContact.img != null
                    ? FileImage(File(_editContact.img))
                    : AssetImage("images/customer-512.png")
                )
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildBotton(){
    return FloatingActionButton(
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
      onPressed: (){},
    );
  }
}
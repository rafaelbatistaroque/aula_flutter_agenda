import 'dart:io';
import 'package:aula_flutter_agenda/utils/utils.contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameCrtl = TextEditingController();
  final _emailCrtl = TextEditingController();
  final _phoneCrtl = TextEditingController();

  final _focusName = FocusNode();

  bool _userEdited = false;
  Contact _editContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null)
      _editContact = Contact();
    else
      _editContact = Contact.fromMap(widget.contact.toMap());

      _nameCrtl.text = _editContact.name;
      _emailCrtl.text = _editContact.email;
      _phoneCrtl.text = _editContact.phone;
  }
//Page to edit and new contacts
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildButtonSave(),
      ),
      onWillPop: _requestPop,
    );
  }
//Builder AppBar
  Widget _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(_editContact.name ?? "Novo Contato"),
      centerTitle: true
    );
  }
//Builer Body page
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _editContact.img != null
                    ? FileImage(File(_editContact.img))
                    : AssetImage("images/customer-512.png")
                )
              ),
            ),
            onTap: (){
              ImagePicker.pickImage(source: ImageSource.camera).then((file){
                if(file == null) return;
                setState(() {
                _editContact.img = file.path;
                });
              });
            },  
          ),
          TextField(
            decoration: InputDecoration(labelText: "Nome"),
            controller: _nameCrtl,
            focusNode: _focusName,
            onChanged: (text){
              _userEdited = true;
              setState(() {
                _editContact.name = text;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Email"),
            controller: _emailCrtl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (text){
              _userEdited = true;
              _editContact.email = text;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Fone"),
            controller: _phoneCrtl,
            onChanged: (text){
              _userEdited = true;
              _editContact.phone = text;
            },
          )
        ],
      ),
    );
  }

  Widget _buildButtonSave(){
    return FloatingActionButton(
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
      onPressed: (){
        if(_editContact.name != null && _editContact.name.isNotEmpty)
          Navigator.pop(context, _editContact);
        else
          FocusScope.of(context).requestFocus(_focusName);
      }
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair, as alterações serão perdindas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    }else
    return Future.value(true);
  }
}
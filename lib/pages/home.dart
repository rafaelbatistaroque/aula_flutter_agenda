import 'dart:io';
import 'package:aula_flutter_agenda/utils/utils.contact.dart';
import 'package:flutter/material.dart';
import 'contact.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();
  
  @override
  void initState() {
    super.initState();

    helper.getAllContacts().then((list){
      setState(() {
       contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBodyApp(),
      floatingActionButton: _buildButtonAdd(),
    );
  }

// Builder AppBar.
  Widget _buildAppBar(){
    return AppBar(
      title: Text("Contatos"),
      backgroundColor: Colors.red,
      centerTitle: true
    );
  }
//Builder body and other structures.
  Widget _buildBodyApp(){
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: contacts.length,
      itemBuilder: (context, index){
        return _contactCard(context, index);
      },
    );
  }
//Builder buttom float to add contact.
  Widget _buildButtonAdd(){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      onPressed: (){
        _showContactPage();
      },
    );
  }
//Builder data cards
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
        _showContactPage(contact: contacts[index]);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: contacts[index].img != null
                      ? FileImage(File(contacts[index].img))
                      : AssetImage("images/customer-512.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 16.0)),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 16.0))
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact contact}){
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
  }
}
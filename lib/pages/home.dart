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
    _getAllContacts();
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
        _showOptions(context, index);
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
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 16.0))
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: (){},
                      child: Text("Ligar",
                        style: TextStyle(color: Colors.black54, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text("Editar",
                        style: TextStyle(color: Colors.black54, fontSize: 20.0),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text("Excluir",
                        style: TextStyle(color: Colors.black54, fontSize: 20.0),
                      ),
                      onPressed: (){
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact!= null){
      
      if(contact != null)
        await helper.updateContact(recContact);
      else
        await helper.saveContact(recContact);
      
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }
}
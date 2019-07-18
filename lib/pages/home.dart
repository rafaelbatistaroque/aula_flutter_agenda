import 'dart:io';
import 'package:aula_flutter_agenda/utils/utils.contact.dart';
import 'package:flutter/material.dart';
import 'contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aula_flutter_agenda/utils/enum.dart';

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
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton<OrderOptions>(
          itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
            const PopupMenuItem<OrderOptions>(
              child: Text("Ordenar A-Z"),
              value: OrderOptions.orderAZ,
            ),
            const PopupMenuItem<OrderOptions>(
              child: Text("Ordenar Z-A"),
              value: OrderOptions.orderZA,
            )
          ],
          onSelected: _orderList
        )
      ],
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
        elevation: 8,
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
                    fit: BoxFit.cover,
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
              padding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.green),
                        iconSize: 35.0,
                        onPressed: (){
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                      Text("Ligar", style: TextStyle(fontSize: 12.0),)
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black54),
                        iconSize: 35.0,
                        onPressed: (){
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        }
                      ),
                      Text("Editar", style: TextStyle(fontSize: 12.0),)
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black54),
                        iconSize: 35.0,
                        onPressed: (){
                          helper.deleteContact(contacts[index].id);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                        },
                      ),
                      Text("Excluir", style: TextStyle(fontSize: 12.0),)
                    ],
                  ),
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

  void _orderList(OrderOptions result){
    switch (result) {
      case OrderOptions.orderAZ:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState((){});
  }
}
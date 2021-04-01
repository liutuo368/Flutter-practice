import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        home: UserInfo(),
    );
  }
}

class ListData {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;
  ListData(this.id, this.name, this.username, this.email, this.address, this.phone, this.website, this.company);
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;
  Address(this.street, this.suite, this.city, this.zipcode, this.geo);
}

class Geo {
  final String lat;
  final String lng;
  Geo(this.lat, this.lng);
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;
  Company(this.name, this.catchPhrase, this.bs);
}


class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<ListData> _list = [];

  _loadData() async {
    String url = "https://jsonplaceholder.typicode.com/users";
    http.Response response = await http.get(url);
    setState(() {
      final data = jsonDecode(response.body);
      for (var _data in data) {
        Geo geo = Geo(_data['address']['geo']['lat'],_data['address']['geo']['lng']);
        Address address = Address(_data['address']['street'],_data['address']['suite'],_data['address']['city'],_data['address']['zipcode'],geo);
        Company company = Company(_data['company']['name'],_data['company']['catchPhrase'],_data['company']['bs']);
        _list.add(ListData(_data["id"],_data["name"],_data['username'],_data['email'],address,_data['phone'],_data['website'],company));
      }
    });
  }

  Widget _buildRow(int index) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListTile(
        title: Text(_list[index].name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
        body: ListView.separated(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) => InkWell(onTap: (){
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new UserDetail(userInfo: _list[index]),
              ),
            );
          }, child: _buildRow(index)),
          separatorBuilder: (BuildContext context,int index) => Divider(),
        ),
    );
  }

}

class UserDetail extends StatelessWidget {
  final ListData userInfo;

  UserDetail({Key key, @required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("User Detail"),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Text(
            'Name: ${userInfo.name}\n' +
            'Username: ${userInfo.username}\n' +
            'Email: ${userInfo.email}\n' +
            'Address: ${userInfo.address.street} ${userInfo.address.suite} ${userInfo.address.city} ${userInfo.address.zipcode}\n' +
            'Phone: ${userInfo.phone}\n' +
            'Website: ${userInfo.website}\n' +
            'Company: ${userInfo.company.name}\n',
          textScaleFactor: 1.5,
        ),
      ),
    );
  }
}
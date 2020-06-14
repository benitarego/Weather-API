import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S4S Test',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position _currentPosition;
  var temp_now;
  var temp_one_hour;
  var temp_tomorrow;

  @override
  void initState() {
    // TODO: implement initState
    this._getCurrentLocation();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S4S Test", textAlign: TextAlign.center,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text("Benita Rego", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  textAlign: TextAlign.center,),
            SizedBox(height: 10.0),
            if (_currentPosition != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Text("Latitude: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                  Text("${_currentPosition.latitude}", style: TextStyle(fontSize: 15.0),),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0),
                Text("Longitude: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                Text("${_currentPosition.longitude}", style: TextStyle(fontSize: 15.0),),
              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0),
                Text("Current Temperature: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                Text("${temp_now}", style: TextStyle(fontSize: 15.0),),
              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0),
                Text("Next Hour's Temperature: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                Text("${temp_one_hour}", style: TextStyle(fontSize: 15.0),),
              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0),
                Text("Next Day's Temperature: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                Text("${temp_tomorrow}", style: TextStyle(fontSize: 15.0),),
              ],),
          ],
        ),
      ),
    );
  }

 _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      this._getTemp();
    }).catchError((e) {
      print(e);
    });
  }

   Future<String> _getTemp() async{
    print(_currentPosition.latitude);
    print(_currentPosition.longitude);
//    String api_key = 'b84db996860b750f8377d4e258097435';
    String url = 'https://api.openweathermap.org/data/2.5/onecall?lat='+ _currentPosition.latitude.toString() +'&lon='+ _currentPosition.longitude.toString()+ '&units=metric&exclude=minutely&appid=b84db996860b750f8377d4e258097435';
    var response = await http.get(Uri.encodeFull(url),headers: {"Accept": "application/json"});
    var data = json.decode(response.body);
    print(data["current"]["temp"]);
    print(data["hourly"][1]["temp"]);
     print(data["daily"][1]["temp"]["max"]);
     setState(() {
       this.temp_now = data["current"]["temp"];
       this.temp_one_hour=data["hourly"][1]["temp"];
       this.temp_tomorrow = data["daily"][1]["temp"]["max"];
     });
    return "success";

  }
}
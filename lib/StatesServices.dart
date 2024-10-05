import 'dart:convert';
import 'package:covid19_app/AppUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'WorldStatesApi.dart';
class StatesService{
  Future<WorldStatesApi> Fetchdatacountries() async{
     final response=await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));
     if(response.statusCode==200){
       var data=jsonDecode(response.body);
       return WorldStatesApi.fromJson(data);

     }
     else {
       throw Exception('Error!');

     }
  }
  Future<List<dynamic>> FetchdCountries() async{
    var data;
    final response=await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));
    if(response.statusCode==200){
       data=jsonDecode(response.body);
      return data;
    }
    else {
      throw Exception('Error!');

    }
  }
}
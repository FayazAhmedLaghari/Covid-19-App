import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'WorldStatesScreen.dart';
class CountriesData extends StatefulWidget {
  String image;
  String name;
  int totalCases, totalDeaths, totalRecovered,critical,todayRecovered, test ,deaths,active;
   CountriesData({
    required this.image,
     required this.name,
     required this.totalCases,
     required this.totalDeaths,
     required this.totalRecovered,
     required this.critical,
     required this.todayRecovered,
     required this.test,
     required this.deaths,
     required this.active
});

  @override
  State<CountriesData> createState() => _CountriesDataState();
}

class _CountriesDataState extends State<CountriesData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.064),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      ResuableRow(title: 'Cases',value: widget.totalCases.toString(),),
                      ResuableRow(title: 'Today Deaths', value: widget.totalDeaths.toString()),
                      ResuableRow(title: 'Deaths', value: widget.deaths.toString()),
                      ResuableRow(title: 'Total Recovered', value: widget.totalRecovered.toString()),
                      ResuableRow(title: 'Critical', value: widget.critical.toString()),
                      ResuableRow(title:'Active', value: widget.active.toString()),
                      ResuableRow(title: 'Test', value: widget.test.toString())
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.image),
              )
            ],
          )
        ],
      ),
    );
  }
}

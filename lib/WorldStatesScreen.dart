import 'package:covid19_app/WorldStatesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid19_app/StatesServices.dart';

import 'CountriesListScreen.dart';

class WorldStatesScreen extends StatefulWidget {
  WorldStatesScreen({super.key});
  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    StatesService statesService = StatesService();
    return Scaffold(
      appBar: AppBar(
        title: Text('World States Screen'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Expanded(
                child: FutureBuilder<WorldStatesApi>(
                  future: statesService.Fetchdatacountries(),
                  builder: (context, AsyncSnapshot<WorldStatesApi> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading spinner while waiting for data
                      return Center(
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 40,
                          controller: _controller,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Handle errors
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
                            child: PieChart(
                              dataMap: {
                                'Total': double.parse(data!.cases!.toString()),
                                'Recovered': double.parse(data.recovered.toString()),
                                'Deaths': double.parse(data.deaths.toString())
                              },
                              chartRadius: MediaQuery.of(context).size.width / 3.2,
                              legendOptions: LegendOptions(
                                legendPosition: LegendPosition.left,
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              animationDuration: Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Card(
                                child: Column(
                                  children: [
                                    ResuableRow(title: 'Total', value: data.cases.toString()),
                                    ResuableRow(title: 'Deaths', value: data.deaths.toString()),
                                    ResuableRow(title: 'Recovered', value: data.recovered.toString()),
                                    ResuableRow(title: 'Active', value: data.active.toString()),
                                    ResuableRow(title: 'Critical', value: data.critical.toString()),
                                    ResuableRow(title: 'Today Deaths', value: data.todayDeaths.toString()),
                                    ResuableRow(title: 'Today Recovered', value: data.todayRecovered.toString()),
                                    ResuableRow(title: 'Today Cases', value: data.todayCases.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesListScreen()));
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Track Countries',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResuableRow extends StatelessWidget {
  final String title, value;
  ResuableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8, right: 10, left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}

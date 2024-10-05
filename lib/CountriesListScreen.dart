import 'package:covid19_app/CountriesData.dart';
import 'package:covid19_app/StatesServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  late Future<List<dynamic>> _countriesFuture;
  List<dynamic> _allCountries = [];
  List<dynamic> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countriesFuture = _fetchCountries(); // Initialize Future here
    _searchController.addListener(_filterCountries); // Add listener for search
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCountries); // Remove listener
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _fetchCountries() async {
    try {
      StatesService statesService = StatesService();
      final data = await statesService.FetchdCountries();
      setState(() {
        _allCountries = data;
        _filteredCountries = data; // Initialize filtered list
      });
      return data;
    } catch (e) {
      // Handle errors here
      print('Error fetching countries: $e');
      return []; // Return an empty list on error
    }
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        final countryName = country['country'].toLowerCase();
        return countryName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Countries List'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Country',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _countriesFuture, // Use the initialized Future
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display shimmer effect while waiting
                    return ListView.builder(
                      itemCount: 6, // Number of shimmer placeholders
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListTile(
                            leading: Container(
                              color: Colors.grey,
                              width: 50,
                              height: 50,
                            ),
                            title: Container(
                              color: Colors.grey,
                              height: 20,
                              width: double.infinity,
                            ),
                            subtitle: Container(
                              color: Colors.grey,
                              height: 15,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_filteredCountries.isEmpty) {
                    return Center(child: Text('No countries found'));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>CountriesData(
                                  image: country['countryInfo']['flag'],
                                   name: country['country'],
                                  totalCases: snapshot.data![index]['cases'],
                                  deaths: snapshot.data![index]['deaths'],
                                  totalDeaths: snapshot.data![index]['todayDeaths'],
                                  totalRecovered: snapshot.data![index]['recovered'],
                                  critical:snapshot.data![index]['critical'],
                                  active: snapshot.data![index]['deaths'],
                                  todayRecovered:snapshot.data![index]['todayRecovered'],
                                  test:snapshot.data![index]['tests']))
                            );
                          },
                          child: ListTile(
                            leading: Image.network(
                              country['countryInfo']['flag'],
                              height: 50,
                              width: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(country['country']),
                            subtitle: Text(country['cases'].toString()),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

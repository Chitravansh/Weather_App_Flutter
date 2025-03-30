import 'package:flutter/material.dart';
import 'dart:ui';
import './hourly_forecast.dart';
import './additional_Information.dart';
import './api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? temp;
  String? weather;
  String? humidity;
  String? windSpeed;
  String? pressure;
  String? iconCode;
  String? city;
  String? country;
  String? iconUrl;
  List<dynamic>? hourlyData;
  List<dynamic> citySuggestions = [];
  TextEditingController searchController = TextEditingController();

  void fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        citySuggestions.clear();
      });
      return;      
    }
     try {
      final suggestions = await getCitySuggestions(query);
      setState(() {
        citySuggestions = suggestions;
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('Weather App',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final response = await getWeather(city!, country!);
              final forecast = await getForecast(city!, country!);

              setState(() {
                temp = response['main']['temp'] - 273.15;
                weather = response['weather'][0]['main'];
                humidity = response['main']['humidity'].toString();
                windSpeed = (response['wind']['speed'] * 3.6).toString();
                pressure = response['main']['pressure'].toString();
                iconCode = response['weather'][0]['icon'].toString();
                hourlyData = forecast['list'];
                iconUrl = "https://openweathermap.org/img/wn/$iconCode@2x.png";

                // temp = temp! - 272.15;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // main card
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon:   IconButton(
            onPressed: () async {
              final response = await getWeather(city!, country!);
              final forecast = await getForecast(city!, country!);

              setState(() {
                temp = response['main']['temp'] - 273.15;
                weather = response['weather'][0]['main'];
                humidity = response['main']['humidity'].toString();
                windSpeed = (response['wind']['speed'] * 3.6).toString();
                pressure = response['main']['pressure'].toString();
                iconCode = response['weather'][0]['icon'].toString();
                hourlyData = forecast['list'];
                iconUrl = "https://openweathermap.org/img/wn/$iconCode@2x.png";

                // temp = temp! - 272.15;
              });
            },
            icon: const Icon(Icons.search),
          ),
                    ),
                    onChanged: fetchCitySuggestions,
                  ),
                ),
                    if (citySuggestions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height : 100,
                    child: ListView.builder(
                      itemCount: citySuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = citySuggestions[index];
                        return ListTile(
                          title: Text("${suggestion['name']}, ${suggestion['country']}"),
                          onTap: () {
                            setState(() {
                              city = suggestion['name'];
                              country = suggestion['country'];
                              searchController.text = "$city, $country";
                              citySuggestions.clear();
                            });
                            getWeather(city!,country!);
                          },
                        );
                      },
                    ),
                  ),
                ),
        
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '${temp?.toStringAsFixed(3) ?? 'Loading...'}° C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
        
                              if (iconUrl != null)
                                Image.network(
                                  iconUrl!,
                                  width: 98,
                                ),
                              // Icon(
                              //   Icons.cloud,
                              //   size: 98,
                              // ),
                              const SizedBox(height: 10),
                              Text('$weather', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
        
                Container(
                  height: 150,
                  child: hourlyData == null
                      ? Center(child: Text('Loading'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final forecast = hourlyData![index];
                            final time = forecast['dt_txt']
                                .toString()
                                .split(' ')[1]
                                .substring(0, 5);
                            final temp = (forecast['main']['temp'] - 273.15)
                                .toStringAsFixed(1);
                            final iconCode = forecast['weather'][0]['icon'];
        
                            return HourlyForecastItem(
                              time: time,
                              temperature: '$temp°C',
                              iconUrl:
                                  'https://openweathermap.org/img/wn/$iconCode@2x.png',
                            );
                          }),
                )
        
                //Aditional Informatione
                ,
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Aditional Informmation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        
                //Additonal Information Card
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop_sharp,
                      title: 'Humidity',
                      value: ' $humidity',
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      title: 'Wind Speed',
                      value: '$windSpeed',
                    ),
                    AdditionalInformation(
                      icon: Icons.timer_outlined,
                      title: 'Pressure',
                      value: '$pressure',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

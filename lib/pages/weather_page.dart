import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService =
      WeatherService('43dec1749438b30efe72d41229c2432b');
  Weather? _weather;

  // Fetch weather
  Future<void> _fetchWeather() async {
    final String? cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    if (cityName != null) {
      try {
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        print(e);
      }
    } else {
      // Handle case where cityName is null
      print("City name is null");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch weather on startup
    _fetchWeather();
  }

// weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/cloudy.json'; // default is cloudy

    switch (mainCondition.toLowerCase()) {
      case 'cloudy':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name
              
              Center(
                child: Row(
                  children: [
                    Icon(Icons.location_on), // Icon widget
                    SizedBox(width: 8),
                    Text(_weather?.cityName ?? "Loading city..."),
                  ],
                ),
              ),
          
              // animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          
              // Temperature
              Text('${_weather?.temparature.round()}°C'),
          
              Text(_weather?.mainCondition ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}

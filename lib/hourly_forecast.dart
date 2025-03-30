import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  // final IconData icon;
  final String iconUrl;

  const HourlyForecastItem(
      {super.key,
      required this.time,
      required this.temperature,
      // required this.icon,
      required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              iconUrl,
              width : 50
            ), //Weather Icon
            const SizedBox(height: 8),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}

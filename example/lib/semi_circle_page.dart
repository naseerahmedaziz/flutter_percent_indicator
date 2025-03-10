import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SemiCirclePage extends StatelessWidget {
  const SemiCirclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SemiCircleProgressIndicator(
          radius: 100,
          percent: 0.2,
          lineWidth: 12,
          progressColor: Colors.redAccent,
          backgroundColor: Colors.grey[300]!,
          animation: true,
          animationDuration: 1000,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("20",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("At Risk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

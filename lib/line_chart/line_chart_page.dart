import 'package:flutter/material.dart';

import 'samples/line_chart_sample1.dart';

class LineChartPage extends StatelessWidget {
  const LineChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 22, 22, 24),
      child: ListView(
        children: const <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Line Chart',
                style: TextStyle(
                  color: Color.fromARGB(255, 128, 192, 158),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
            ),
            child: LineChartSample(type: 'temperature'),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              // child: Text(
              //   'Line Chart',
              //   style: TextStyle(
              //     color: Color(
              //       0xff6f6f97,
              //     ),
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
            ),
            child: LineChartSample(type: 'humidity'),
          ),
        ],
      ),
    );
  }
}

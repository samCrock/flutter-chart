import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

class _LineChart extends StatelessWidget {
  const _LineChart(
      {required this.data,
      required this.currentDatasetIndex,
      required this.datasetSymbol,
      required this.ctx});

  final List<dynamic> data;
  final int currentDatasetIndex;
  final String datasetSymbol;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 95,
        maxY: getMaxY(),
        // maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
          // sideTitles: rightTitles(),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 188, 188, 197),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    text = '';
    if (value.toInt() > 0) {
      text = '${value.toInt()} $datasetSymbol';
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: getYInterval(),
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 188, 188, 197),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(getDateFromIndex(data, value.toInt()), style: style),
    );
  }

  double getYInterval() {
    var windowWidth = MediaQuery.of(ctx).size.width;
    var interval = 10;
    if (windowWidth < 800) {
      interval = 20;
    }
    if (windowWidth > 1400) {
      interval = 5;
    }
    return interval.toDouble();
  }

  double getMaxY() {
    // log('$data');
    double max = 0.0;
    if (data.isEmpty) return max;
    data
        .map((d) => {
              if (d[currentDatasetIndex] > max)
                max = d[currentDatasetIndex].toDouble(),
            })
        .toList();

    var x = 5;
    max = max + x / 2;
    max = max - (max % x);
    return max.toDouble();
  }

  getDateFromIndex(List data, index) {
    var windowWidth = MediaQuery.of(ctx).size.width;
    var interval = 10;
    if (windowWidth < 800) {
      interval = 20;
    }
    if (windowWidth > 1400) {
      interval = 5;
    }
    if (data.asMap()[index] != null) {
      DateTime startingDay;
      var currentDate = DateTime.parse(data.asMap()[index][0]);
      // var startingDay = DateTime.parse(data.asMap()[0][0]);
      if (index == 0) {
        startingDay = DateTime.parse(data.asMap()[index][0]);
      }

      if (index % interval == 0 &&
          currentDate.difference(DateTime.parse(data.asMap()[0][0])).inHours ==
              0) {
        return DateFormat("MMM d hh:mm a")
            .format(DateTime.parse(data.asMap()[index][0]));
      }
      if (index % interval == 0) {
        return DateFormat("hh a")
            .format(DateTime.parse(data.asMap()[index][0]));
      }
    }
    return '';
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: const Color.fromARGB(255, 188, 188, 197).withOpacity(.5),
              width: 1),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: false,
        color: const Color.fromARGB(255, 128, 192, 158),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: getFLSpots(currentDatasetIndex),
      );

  List<FlSpot> getFLSpots(int dataset) {
    List<FlSpot> spots = [];
    if (data.isEmpty) return [];

    final dataIndexes =
        data.mapIndexed((index, element) => index).toList().sublist(0, 95);

    dataIndexes
        .map((i) =>
            {spots.add(FlSpot(i.toDouble(), data[i][dataset].toDouble()))})
        .toList();
    // log('$spots');
    return spots;
  }
}

class LineChartSample extends StatefulWidget {
  final String type;
  final String? restorationId = 'main';

  const LineChartSample({Key? key, required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSampleState();
}

class LineChartSampleState extends State<LineChartSample>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  List<List<dynamic>> _data = [];
  String _currentDataset = '';
  List _datasets = [];
  int _currentDatasetIndex = 0;
  int _selectedDateIndex = 0;
  String _datasetSymbol = '';

  List _formattedData = [];

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2022, 7, 18));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2023),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
      _loadCSV();
    }
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/data.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter(eol: "\n", fieldDelimiter: ",")
            .convert(_rawData);
    setState(() {
      _data = _listData;
      _currentDataset = widget.type;
      _datasets = [];
      _currentDatasetIndex = 0;
      // _formattedData = _data.take(50).toList();
      _formattedData = _data.toList();
      _datasets = _formattedData.first;
      // _datasets.removeAt(0);
      _currentDatasetIndex = _datasets.indexOf(_currentDataset);
      bool selectedDateIndexFound = false;
      _selectedDateIndex = 0;
      switch (widget.type) {
        case 'humidity':
          _datasetSymbol = '%';
          break;
        case 'temperature':
          _datasetSymbol = '°';
          break;
        default:
          _datasetSymbol = '';
      }
      // log('datasets -> $_datasets');
      // log('currentDataset -> $_currentDataset');
      // log('currentDatasetIndex -> $_currentDatasetIndex');
      _formattedData.removeAt(0);

      _formattedData.asMap().entries.map((entry) {
        int idx = entry.key;
        List val = entry.value;

        if (selectedDateIndexFound == false &&
            val[0].substring(0, 10) ==
                _selectedDate.value.toString().substring(0, 10)) {
          _selectedDateIndex = idx;
          selectedDateIndexFound = true;
        }
      }).toList();

      _formattedData =
          _formattedData.sublist(_selectedDateIndex, _selectedDateIndex + 95);

      log('_formattedData ${_formattedData.length}');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 22, 22, 24),
              Color.fromARGB(255, 50, 50, 58),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '2022',
                  style: TextStyle(
                    color: Color.fromARGB(255, 188, 188, 197),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.type.toUpperCase(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 188, 188, 197),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(
                        data: _formattedData,
                        currentDatasetIndex: _currentDatasetIndex,
                        datasetSymbol: _datasetSymbol,
                        ctx: context),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                _restorableDatePickerRouteFuture.present();
              },
              child: const Text('Open Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

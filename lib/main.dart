import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  MyHomePageState();

 final List<SalesData> _salesData = <SalesData>[];

  Future<String> _loadSalesDataAsset() async {
    return await rootBundle.loadString('assets/salesData.json');
  }

  Future _loadSalesData() async {
    final String jsonString = await _loadSalesDataAsset();
    final dynamic jsonObject = json.decode(jsonString);
    setState(() {
     for(final Map<dynamic, dynamic> obj in jsonObject){
      _salesData.add(SalesData.fromJson(obj));
     }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _buildCartesianChart(),
    ));
  }

  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      key: GlobalKey(),
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Load Data In Flutter Chart'),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      primaryXAxis: DateTimeAxis(
        name: 'Years',
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          name: 'Sales',
          minimum: 75,
          maximum: 95,
          interval: 10,
          rangePadding: ChartRangePadding.none,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          labelFormat: '{value}M',
          numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
      series: _getFastLineSeries(),
    );
  }

  /// The method returns line series to chart.
  List<FastLineSeries<SalesData, DateTime>> _getFastLineSeries() {
    return <FastLineSeries<SalesData, DateTime>>[
      FastLineSeries<SalesData, DateTime>(
        name: 'Sales',
        dataSource: _salesData,
        xValueMapper: (SalesData data, int index) => data.year,
        yValueMapper: (SalesData data, int index) => data.sales,
      )
    ];
  }

  @override
  void dispose() {
    _salesData.clear();
    super.dispose();
  }

}

class SalesData {
  SalesData(this.year, this.sales);

  DateTime year;
  num sales;

  factory SalesData.fromJson(Map<dynamic, dynamic> parsedJson){
    return SalesData(
      DateTime.parse(parsedJson['year']),
      parsedJson['sales']
    );
  }
}

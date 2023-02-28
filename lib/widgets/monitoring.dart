import 'package:flutter/material.dart';
import 'package:mycaleg/models/kelurahan.dart';
import 'package:mycaleg/services/database.dart';
import 'package:mycaleg/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Monitoring extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Monitoring({Key? key}) : super(key: key);

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {

  /*late List<_ChartData> data;
  late TooltipBehavior _tooltip;*/

  @override
  void initState() {

    /*data = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),*/
      body: Stack(
        children: <Widget>[

          // back image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pelangi_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // grafik monitoring
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<Iterable<Kelurahan>>(
                stream: DatabaseService().kelurahanGraph,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Kelurahan> listKelurahan = snapshot.data!.toList();
                    return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis:
                            NumericAxis(minimum: 0, maximum: 10, interval: 2),
                        // tooltipBehavior: _tooltip,
                        series: <ChartSeries<Kelurahan, String>>[
                          BarSeries<Kelurahan, String>(
                              dataSource: listKelurahan,
                              xValueMapper: (Kelurahan data, _) =>
                                  data.namakelurahan,
                              yValueMapper: (Kelurahan data, _) =>
                                  data.jumlahAnggota,
                              name: 'Gold',
                              color: Colors.deepPurpleAccent),
                        ]);
                  } else {
                    return const Loading();
                  }
                }),
          ),

        ],
      ),
    );
  }
}

/*class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}*/

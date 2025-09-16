import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StockDetailScreen(),
    );
  }
}

class StockDetailScreen extends StatelessWidget {
  const StockDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample chart data
    List<ChartData> chartData = [
      ChartData(0, 1),
      ChartData(1, 1.5),
      ChartData(2, 1.4),
      ChartData(3, 3.4),
      ChartData(4, 2),
      ChartData(5, 2.2),
      ChartData(6, 1.8),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          Icon(Icons.alarm, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.bookmark_border, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUZLON',
              style: TextStyle(color: Colors.greenAccent, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Suzlon Energy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '₹59.01',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '+1.40 (2.43%) 1W',
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
            SizedBox(height: 16),

            // Syncfusion Chart
            // Container(
            //   height: 200,
            //   child: SfCartesianChart(
            //     backgroundColor: Colors.black,
            //     primaryXAxis: NumericAxis(isVisible: false),
            //     primaryYAxis: NumericAxis(isVisible: false),
            //     series: <ChartSeries>[
            //       LineSeries<ChartData, double>(
            //         dataSource: chartData,
            //         xValueMapper: (ChartData data, _) => data.x,
            //         yValueMapper: (ChartData data, _) => data.y,
            //         color: Colors.greenAccent,
            //         width: 2,
            //         markerSettings: MarkerSettings(isVisible: false),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    ['1D', '1W', '1M', '3M', '6M', '1Y', '5Y', 'All']
                        .map(
                          (e) => ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  e == '1W' ? Colors.white : Colors.grey[800],
                            ),
                            child: Text(
                              e,
                              style: TextStyle(
                                color: e == '1W' ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('15 Shares', style: TextStyle(color: Colors.grey)),
                      Text(
                        'Avg price ₹56.70',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    '+₹34.65 (4.07%)',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border.all(color: Colors.grey),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(Icons.add, color: Colors.red),
                label: Text(
                  'Create Stock SIP',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Overview',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'News',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Events',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'F & O',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(190, 50),
                  ),
                  child: Text('Sell', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(190, 50),
                  ),
                  child: Text('Buy', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;
  ChartData(this.x, this.y);
}

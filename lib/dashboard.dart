import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

final monthMap = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December'
};

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentYear = DateTime.now().year;

  Future<bool> isDataAvailable(int year, int month) async {
    var res = await get(Uri.parse(
        'https://solatapi.iqfareez.com/api/v2/solat/ngs02?year=$year&month=$month'));
    return res.statusCode == 200;
  }

  int getAxisCount() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth <= 280) {
      return 1;
    } else if (screenWidth < 420) {
      return 2;
    } else if (screenWidth < 821) {
      return 3;
    } else {
      return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MPT Health Dashboard'),
        actions: [
          TextButton(
              onPressed: () {
                launchUrl(Uri.parse('https://mpt-server.vercel.app'));
              },
              child: const Text('MPT-Server')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.outlined(
                onPressed: currentYear < 2023
                    ? null
                    : () => setState(() => currentYear--),
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                currentYear.toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton.outlined(
                onPressed: () => setState(() => currentYear++),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getAxisCount(), childAspectRatio: 3 / 2),
            itemBuilder: (context, index) {
              var month = index + 1;
              var monthName = monthMap[month];
              return Card(
                child: FutureBuilder(
                    future: isDataAvailable(currentYear, month),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Error',
                          style: Theme.of(context).textTheme.headline5,
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            snapshot.data! ? Icons.check : Icons.close,
                            color: snapshot.data! ? Colors.green : Colors.red,
                            size: 56,
                          ),
                          Text(
                            monthName!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      );
                    }),
              );
            },
          ),
          const SizedBox(height: 10),
          const Text('All data is check based on NGS02 zone')
        ],
      ),
    );
  }
}

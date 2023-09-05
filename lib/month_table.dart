import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class MonthTable extends StatefulWidget {
  const MonthTable({super.key, required this.year});

  final int year;

  @override
  State<MonthTable> createState() => _MonthTableState();
}

class _MonthTableState extends State<MonthTable> {
  late List<Future<bool>> futureData;
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

  Future<bool> isDataAvailable(int year, int month) async {
    var res = await http.get(Uri.parse(
        'https://mpt-server.vercel.app/api/v2/solat/ngs02?year=$year&month=$month'));
    return res.statusCode == 200;
  }

  @override
  void initState() {
    super.initState();
    futureData = List.generate(12, (index) {
      var month = index + 1;
      return isDataAvailable(widget.year, month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
              future: futureData[index],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }
}

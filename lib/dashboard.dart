import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mpt_data_health/month_table.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentYear = DateTime.now().year;

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
          MonthTable(key: ValueKey(currentYear), year: currentYear),
          const SizedBox(height: 10),
          const MarkdownBody(data: 'All data is checked:'),
          const MarkdownBody(data: '- based on `NGS02` zone'),
          MarkdownBody(
            data:
                '- againts [v2 solat API](https://github.com/mptwaktusolat/mpt-server/issues/3). Hence, data prior May 2023 is expected to be not available',
            onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
          ),
          const SizedBox(height: 10),
          MarkdownBody(
            data:
                'Prayer time database is [updated periodically](https://github.com/mptwaktusolat/waktusolat-fetcher). Fetched from [e-solat](https://www.e-solat.gov.my/) JAKIM portal.',
            onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
          ),
        ],
      ),
    );
  }
}

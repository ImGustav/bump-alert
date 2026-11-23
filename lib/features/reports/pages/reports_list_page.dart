import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../viewmodels/reports_list_view_model.dart';
import '../widgets/report_card.dart';
import 'report_detail_page.dart';

class ReportsListPage extends StatefulWidget {
  const ReportsListPage({super.key});

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  late final _vm = ReportsListViewModel(deps.reportRepository);

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas denúncias')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          final reports = _vm.reports;
          if (reports.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Nenhuma denúncia ainda.\nUse o botão "Denunciar" no mapa '
                  'ou ligue o Modo Trajeto.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reports.length,
            itemBuilder: (_, i) => ReportCard(
              report: reports[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportDetailPage(report: reports[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

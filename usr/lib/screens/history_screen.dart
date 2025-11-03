import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/roster_provider.dart';
import '../services/pdf_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _shareRoster(BuildContext context, Roster roster) async {
    final pdfService = PdfService();
    await pdfService.generateAndSharePdf(roster);
  }

  void _showRosterDetails(BuildContext context, Roster roster) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Roster for ${DateFormat('yyyy-MM-dd').format(roster.date)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShiftDetails(roster.morningShift),
              const Divider(),
              _buildShiftDetails(roster.afternoonShift),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _shareRoster(context, roster);
            },
            icon: const Icon(Icons.share),
            label: const Text('Share as PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftDetails(Shift shift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${shift.icon} ${shift.name} Shift (${shift.timing})', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (shift.remarks.isNotEmpty) Text('Remarks: ${shift.remarks}'),
        const SizedBox(height: 8),
        const Text('North Ops Room:', style: TextStyle(fontWeight: FontWeight.w600)),
        ...shift.northOps.map((a) => Text('• ${a.employee.rank} ${a.employee.name} ${a.remarks.isNotEmpty ? "(${a.remarks})" : ""}')).toList(),
        const SizedBox(height: 8),
        const Text('South Ops Room:', style: TextStyle(fontWeight: FontWeight.w600)),
        ...shift.southOps.map((a) => Text('• ${a.employee.rank} ${a.employee.name} ${a.remarks.isNotEmpty ? "(${a.remarks})" : ""}')).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<RosterProvider>(
        builder: (context, provider, child) {
          final rosters = provider.rosters..sort((a, b) => b.date.compareTo(a.date));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rosters.length,
            itemBuilder: (context, index) {
              final roster = rosters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(DateFormat('yyyy-MM-dd').format(roster.date)),
                  subtitle: Text('Employees: ${roster.totalEmployees}, Shifts: ${roster.shiftCount}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.share, color: Colors.blue),
                    onPressed: () => _shareRoster(context, roster),
                  ),
                  onTap: () => _showRosterDetails(context, roster),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
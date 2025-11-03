import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/roster_provider.dart';
import '../widgets/assignment_modal.dart';

class CreateDutyScreen extends StatefulWidget {
  const CreateDutyScreen({super.key});

  @override
  State<CreateDutyScreen> createState() => _CreateDutyScreenState();
}

class _CreateDutyScreenState extends State<CreateDutyScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _morningRemarksController = TextEditingController();
  final TextEditingController _afternoonRemarksController = TextEditingController();

  List<Assignment> _morningNorthOps = [];
  List<Assignment> _morningSouthOps = [];
  List<Assignment> _afternoonNorthOps = [];
  List<Assignment> _afternoonSouthOps = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAssignmentModal(List<Assignment> assignments, String title, Function(List<Assignment>) onUpdate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AssignmentModal(
        currentAssignments: assignments,
        title: title,
        onSave: onUpdate,
      ),
    );
  }

  void _createRoster() {
    final roster = Roster(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      morningShift: Shift(
        name: 'Morning',
        timing: 'Briefing to 13:30',
        icon: '🌞',
        northOps: _morningNorthOps,
        southOps: _morningSouthOps,
        remarks: _morningRemarksController.text,
      ),
      afternoonShift: Shift(
        name: 'Afternoon',
        timing: '13:30 to Return Completion',
        icon: '🌛',
        northOps: _afternoonNorthOps,
        southOps: _afternoonSouthOps,
        remarks: _afternoonRemarksController.text,
      ),
    );
    context.read<RosterProvider>().addRoster(roster);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duty Roster Created Successfully')),
    );
    // Reset form
    setState(() {
      _morningNorthOps = [];
      _morningSouthOps = [];
      _afternoonNorthOps = [];
      _afternoonSouthOps = [];
      _morningRemarksController.clear();
      _afternoonRemarksController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Duty'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            Card(
              child: ListTile(
                title: const Text('Select Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 20),
            // Morning Shift
            Text('🌞 Morning Shift (Briefing to 13:30)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildOpsCard('North Ops Room', _morningNorthOps, () => _showAssignmentModal(_morningNorthOps, 'Morning - North Ops', (assignments) => setState(() => _morningNorthOps = assignments))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildOpsCard('South Ops Room', _morningSouthOps, () => _showAssignmentModal(_morningSouthOps, 'Morning - South Ops', (assignments) => setState(() => _morningSouthOps = assignments))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _morningRemarksController,
              decoration: const InputDecoration(
                labelText: 'Morning Shift Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Afternoon Shift
            Text('🌛 Afternoon Shift (13:30 to Return Completion)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildOpsCard('North Ops Room', _afternoonNorthOps, () => _showAssignmentModal(_afternoonNorthOps, 'Afternoon - North Ops', (assignments) => setState(() => _afternoonNorthOps = assignments))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildOpsCard('South Ops Room', _afternoonSouthOps, () => _showAssignmentModal(_afternoonSouthOps, 'Afternoon - South Ops', (assignments) => setState(() => _afternoonSouthOps = assignments))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _afternoonRemarksController,
              decoration: const InputDecoration(
                labelText: 'Afternoon Shift Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createRoster,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create Duty Roster'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpsCard(String title, List<Assignment> assignments, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${assignments.length} assigned'),
              if (assignments.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...assignments.map((a) => Text('${a.employee.rank} ${a.employee.name}')).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
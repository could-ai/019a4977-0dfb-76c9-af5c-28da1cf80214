import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/roster_provider.dart';

class AssignmentModal extends StatefulWidget {
  final List<Assignment> currentAssignments;
  final String title;
  final Function(List<Assignment>) onSave;

  const AssignmentModal({
    super.key,
    required this.currentAssignments,
    required this.title,
    required this.onSave,
  });

  @override
  State<AssignmentModal> createState() => _AssignmentModalState();
}

class _AssignmentModalState extends State<AssignmentModal> {
  late List<Assignment> _assignments;
  final Map<String, TextEditingController> _remarksControllers = {};

  @override
  void initState() {
    super.initState();
    _assignments = List.from(widget.currentAssignments);
  }

  void _addEmployee(Employee employee) {
    setState(() {
      _assignments.add(Assignment(employee: employee, remarks: ''));
      _remarksControllers[employee.id] = TextEditingController();
    });
  }

  void _removeEmployee(int index) {
    setState(() {
      final employeeId = _assignments[index].employee.id;
      _assignments.removeAt(index);
      _remarksControllers[employeeId]?.dispose();
      _remarksControllers.remove(employeeId);
    });
  }

  void _updateRemarks(String employeeId, String remarks) {
    setState(() {
      final index = _assignments.indexWhere((a) => a.employee.id == employeeId);
      if (index != -1) {
        _assignments[index] = Assignment(
          employee: _assignments[index].employee,
          remarks: remarks,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableEmployees = context.read<RosterProvider>().getAvailableEmployees()
        .where((e) => !_assignments.any((a) => a.employee.id == e.id))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                if (_assignments.isNotEmpty) ...[
                  const Text('Assigned Employees:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._assignments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final assignment = entry.value;
                    return Card(
                      child: ListTile(
                        title: Text('${assignment.employee.rank} ${assignment.employee.name}'),
                        subtitle: TextField(
                          controller: _remarksControllers.putIfAbsent(
                            assignment.employee.id,
                            () => TextEditingController(text: assignment.remarks),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Remarks (optional)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => _updateRemarks(assignment.employee.id, value),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeEmployee(index),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                ],
                const Text('Available Employees:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...availableEmployees.map((employee) => ListTile(
                  title: Text('${employee.rank} ${employee.name}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () => _addEmployee(employee),
                  ),
                )).toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_assignments);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _remarksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
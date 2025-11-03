import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/roster_provider.dart';
import '../widgets/employee_list_item.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _rankController = TextEditingController();
  final _nameController = TextEditingController();

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _rankController,
              decoration: const InputDecoration(
                labelText: 'Rank',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addEmployee,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addEmployee() {
    if (_rankController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      final employee = Employee(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        rank: _rankController.text,
        name: _nameController.text,
        dutyHours: '9:00 AM–5:00 PM',
      );
      context.read<RosterProvider>().addEmployee(employee);
      _rankController.clear();
      _nameController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<RosterProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.employees.length,
            itemBuilder: (context, index) {
              final employee = provider.employees[index];
              return EmployeeListItem(
                employee: employee,
                onEdit: (updatedEmployee) {
                  provider.updateEmployee(employee.id, updatedEmployee);
                },
                onDelete: () {
                  provider.deleteEmployee(employee.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEmployeeDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
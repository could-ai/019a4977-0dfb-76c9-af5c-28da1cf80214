import 'package:flutter/material.dart';
import '../models/models.dart';

class EmployeeListItem extends StatefulWidget {
  final Employee employee;
  final Function(Employee) onEdit;
  final VoidCallback onDelete;

  const EmployeeListItem({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<EmployeeListItem> createState() => _EmployeeListItemState();
}

class _EmployeeListItemState extends State<EmployeeListItem> {
  final _rankController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rankController.text = widget.employee.rank;
    _nameController.text = widget.employee.name;
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Employee'),
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
            onPressed: _editEmployee,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editEmployee() {
    if (_rankController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      final updatedEmployee = Employee(
        id: widget.employee.id,
        rank: _rankController.text,
        name: _nameController.text,
        dutyHours: widget.employee.dutyHours,
      );
      widget.onEdit(updatedEmployee);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('${widget.employee.rank} ${widget.employee.name}'),
        subtitle: Text('Duty Hours: ${widget.employee.dutyHours}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: _showEditDialog,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
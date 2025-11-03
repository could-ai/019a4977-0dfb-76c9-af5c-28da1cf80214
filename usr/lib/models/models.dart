class Employee {
  final String id;
  final String rank;
  final String name;
  final String dutyHours;

  Employee({
    required this.id,
    required this.rank,
    required this.name,
    required this.dutyHours,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rank': rank,
      'name': name,
      'dutyHours': dutyHours,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      rank: map['rank'],
      name: map['name'],
      dutyHours: map['dutyHours'],
    );
  }
}

class Assignment {
  final Employee employee;
  final String remarks;

  Assignment({
    required this.employee,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'employee': employee.toMap(),
      'remarks': remarks,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      employee: Employee.fromMap(map['employee']),
      remarks: map['remarks'],
    );
  }
}

class Shift {
  final String name;
  final String timing;
  final String icon;
  final List<Assignment> northOps;
  final List<Assignment> southOps;
  final String remarks;

  Shift({
    required this.name,
    required this.timing,
    required this.icon,
    required this.northOps,
    required this.southOps,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timing': timing,
      'icon': icon,
      'northOps': northOps.map((a) => a.toMap()).toList(),
      'southOps': southOps.map((a) => a.toMap()).toList(),
      'remarks': remarks,
    };
  }

  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      name: map['name'],
      timing: map['timing'],
      icon: map['icon'],
      northOps: (map['northOps'] as List<dynamic>).map((a) => Assignment.fromMap(a)).toList(),
      southOps: (map['southOps'] as List<dynamic>).map((a) => Assignment.fromMap(a)).toList(),
      remarks: map['remarks'],
    );
  }
}

class Roster {
  final String id;
  final DateTime date;
  final Shift morningShift;
  final Shift afternoonShift;

  Roster({
    required this.id,
    required this.date,
    required this.morningShift,
    required this.afternoonShift,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'morningShift': morningShift.toMap(),
      'afternoonShift': afternoonShift.toMap(),
    };
  }

  factory Roster.fromMap(Map<String, dynamic> map) {
    return Roster(
      id: map['id'],
      date: DateTime.parse(map['date']),
      morningShift: Shift.fromMap(map['morningShift']),
      afternoonShift: Shift.fromMap(map['afternoonShift']),
    );
  }

  int get totalEmployees {
    return morningShift.northOps.length +
           morningShift.southOps.length +
           afternoonShift.northOps.length +
           afternoonShift.southOps.length;
  }

  int get shiftCount {
    return 2; // Morning and Afternoon
  }
}
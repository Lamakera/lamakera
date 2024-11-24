class ToDo {
  int? id;
  String todoText;
  bool isDone;
  String deadline; // Tambahkan atribut untuk tanggal

  ToDo({
    this.id,
    required this.todoText,
    this.isDone = false,
    required this.deadline, // Wajib saat membuat tugas
  });

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] == 1,
      deadline: map['deadline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone ? 1 : 0,
      'deadline': deadline,
    };
  }
}

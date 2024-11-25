class ToDo {
  int? id;
  String todoText;
  bool isDone;
  String deadline; // Tanggal dalam bentuk String

  ToDo({
    this.id,
    required this.todoText,
    this.isDone = false,
    required this.deadline, // Deadline harus ada saat membuat tugas
  });

  // Pemetaan data dari database ke objek ToDo
  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] == 1, // Mengonversi 1/0 ke bool
      deadline: map['deadline'], // Deadline dalam bentuk String
    );
  }

  // Pemetaan data dari objek ToDo ke format map yang bisa disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone ? 1 : 0, // Mengonversi bool ke 1/0
      'deadline': deadline, // Deadline tetap dalam bentuk String
    };
  }
}

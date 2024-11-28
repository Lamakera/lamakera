class ToDo {
  int? id;
  String todoText;
  bool isDone;
  String deadline;
  String category; 
  int notification; 

  ToDo({
    this.id,
    required this.todoText,
    this.isDone = false,
    required this.deadline,
    required this.category, 
    required this.notification, 
  });

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] == 1, // Mengonversi 1/0 ke bool
      deadline: map['deadline'],
      category: map['category'], // Memetakan kategori
      notification: map['notification'], // Memetakan status notifikasi
    );
  }

  // Pemetaan data dari objek ToDo ke format map yang bisa disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone ? 1 : 0, // Mengonversi bool ke 1/0
      'deadline': deadline,
      'category': category, // Menambahkan kategori ke map
      'notification': notification, // Menambahkan status notifikasi ke map
    };
  }
}

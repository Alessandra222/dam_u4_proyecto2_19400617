class Asistencia {
  String fecha;
  String revisor;

  Asistencia({
        required this.fecha,
        required this.revisor
      });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'revisor': revisor
    };
  }
}
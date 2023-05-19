import 'package:dam_u4_proyecto2_19400617/Asistencia/asistencia.dart';

class Asignacion {
  String? id1;
  String docente;
  String edificio;
  String horario;
  String materia;
  String salon;
  List<Asistencia>? asistencia;

  Asignacion(
      {
        this.id1,
        required this.docente,
        required this.edificio,
        required this.horario,
        required this.materia,
        required this.salon,
        this.asistencia
      });

  Map<String, dynamic> toMap() {
    return {
      'docente': docente,
      'edificio': edificio,
      'horario': horario,
      'materia': materia,
      'salon':salon
    };
  }
}
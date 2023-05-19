import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u4_proyecto2_19400617/Asignacion/asignacion.dart';
import 'package:dam_u4_proyecto2_19400617/Asistencia/asistencia.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference crAsignacion = db.collection('asignacion');
CollectionReference crAsis = db.collection('asistencia');

Future<List<Map<String, dynamic>>> getAsignacion() async {
  List<Map<String, dynamic>> asignacion = [];

  QuerySnapshot qAsig = await crAsignacion.get();

  await Future.forEach(qAsig.docs, (documento) async {
    List<Map<String, dynamic>> asistencias = [];

    QuerySnapshot qAsis = await crAsignacion.doc(documento.id).collection('asistencia').get();
    await Future.forEach(qAsis.docs, (asisDocumento) async {
      Map<String, dynamic> asisData = asisDocumento.data() as Map<String, dynamic>;
      asistencias.add(asisData);
    });
    Map<String, dynamic> ids = {'id1': documento.id};
    Map<String, dynamic> cont = documento.data() as Map<String, dynamic>;
    Map<String, dynamic> asis = {'asistencias': asistencias};
    ids.addAll(cont);
    ids.addAll(asis);
    asignacion.add(ids);
  });

  return asignacion;
}

Future<int> insertarAsignacion(Asignacion a) async {
  try {
    DocumentReference asig= await crAsignacion.add(a.toMap());
    CollectionReference crAsis= asig.collection('asistencias');
    return 1;
  } catch (e) {
    return 0;
  }
}

Future<int> actualizarAsignacion(Asignacion a, String id) async {
  await crAsignacion.doc(id).set(a.toMap());
  return 1;
}
Future<void> eliminarAsignacion(String p) async {
    await crAsignacion.doc(p).delete();
}

Future<void> InsertarAsist(Asistencia ast,String id) async{
  DocumentReference asis= await crAsignacion.doc(id);
  await  asis.collection('asistencia').add(ast.toMap());
}

Future<List<String>> getDocente() async {
  List<String> docentes = [];
  QuerySnapshot query = await crAsignacion.get();
  query.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String docente = data['docente'];

    // Verificar si el docente ya existe en la lista
    if (!docentes.contains(docente)) {
      docentes.add(docente);
    }
  });
  return docentes;
}

Future<List<Map<String, dynamic>>> getAsisDocente(String docente) async {
  List<Map<String, dynamic>> asignacion = [];

  QuerySnapshot qAsig = await crAsignacion.where('docente', isEqualTo: docente).get();

  await Future.forEach(qAsig.docs, (documento) async {
    List<Map<String, dynamic>> asistencias = [];

    QuerySnapshot qAsis = await crAsignacion.doc(documento.id).collection('asistencia').get();
    await Future.forEach(qAsis.docs, (asisDocumento) async {
      Map<String, dynamic> asisData = asisDocumento.data() as Map<String, dynamic>;
      asistencias.add(asisData);
    });
    Map<String, dynamic> ids = {'id1': documento.id};
    Map<String, dynamic> cont = documento.data() as Map<String, dynamic>;
    Map<String, dynamic> asis = {'asistencias': asistencias};
    ids.addAll(cont);
    ids.addAll(asis);
    asignacion.add(ids);
  });

  return asignacion;
}


Future<List<Map<String, dynamic>>> getAsisEdificio(String edificio) async {
  List<Map<String, dynamic>> asignacion = [];

  QuerySnapshot qAsig = await crAsignacion.where('edificio', isEqualTo: edificio).get();

  await Future.forEach(qAsig.docs, (documento) async {
    List<Map<String, dynamic>> asistencias = [];

    QuerySnapshot qAsis = await crAsignacion.doc(documento.id).collection('asistencia').get();
    await Future.forEach(qAsis.docs, (asisDocumento) async {
      Map<String, dynamic> asisData = asisDocumento.data() as Map<String, dynamic>;
      asistencias.add(asisData);
    });
    Map<String, dynamic> ids = {'id1': documento.id};
    Map<String, dynamic> cont = documento.data() as Map<String, dynamic>;
    Map<String, dynamic> asis = {'asistencias': asistencias};
    ids.addAll(cont);
    ids.addAll(asis);
    asignacion.add(ids);
  });

  return asignacion;
}



Future<List<Map<String, dynamic>>> getfechaIF(String fi, String ff) async {
  List<Map<String, dynamic>> asignacion = [];
  DateFormat formatter = DateFormat('yyyy/MM/dd');

  DateTime fechaInicial = formatter.parse(fi);
  DateTime fechaFinal = formatter.parse(ff);
  print(fechaInicial);
  print(fechaFinal);

  QuerySnapshot qAsig = await crAsignacion.get();

  await Future.wait(qAsig.docs.map((documento) async {
    List<Map<String, dynamic>> asistencias = [];

    QuerySnapshot qAsis = await crAsignacion.doc(documento.id).collection('asistencia').get();
    print(qAsis.size);
    await Future.wait(qAsis.docs.map((asisDocumento) async  {
      Map<String, dynamic> asisData = asisDocumento.data() as Map<String, dynamic>;
      String fechaHora = asisData['fecha'];
      String fechaSplit = fechaHora.split(' ')[0];
      print(fechaSplit);
      //DateFormat formatter2 = DateFormat('yyyy/MM/dd');
      DateTime fecha = DateTime.parse(fechaSplit);
      print(fecha);

      if (fecha.isAfter(fechaInicial) && fecha.isBefore(fechaFinal)) {
        asistencias.add(asisData);
      }
    }));
    Map<String, dynamic> ids = {'id1': documento.id};
    Map<String, dynamic> cont = documento.data() as Map<String, dynamic>;
    Map<String, dynamic> asis = {'asistencias': asistencias};
    ids.addAll(cont);
    ids.addAll(asis);
    if(asistencias.isNotEmpty){
      asignacion.add(ids);
    }

  }));

  return asignacion;
}

import 'package:dam_u4_proyecto2_19400617/Asignacion/actualizarAsig.dart';
import 'package:dam_u4_proyecto2_19400617/Asignacion/asignacion.dart';
import "package:dam_u4_proyecto2_19400617/bd.dart";
import 'package:dam_u4_proyecto2_19400617/Asignacion/capturarAsis.dart';
import "package:flutter/material.dart";

class intAsignacion extends StatefulWidget {
  const intAsignacion({Key? key}) : super(key: key);

  @override
  State<intAsignacion> createState() => _intAsignacionState();
}


class _intAsignacionState extends State<intAsignacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: getAsignacion(),
              builder: ((context, snapshot) {
                return ListView.separated(
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(color: Color(0xFF8CC0DE)),
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        return InkWell(
                          child: ListTile(
                              leading: Icon(Icons.panorama_outlined),
                            title:
                                Text("${snapshot.data?[index]['materia']}    ${snapshot.data?[index]['horario']}   "),
                            subtitle: Text(
                                " ${snapshot.data?[index]['docente']} \n Edificio: ${snapshot.data?[index]['edificio']}   Salón:${snapshot.data?[index]['salon']} \n  "),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: Icon(Icons.edit, color: Color(0xFF667761)),
                                    onPressed: () async {

                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ActualizarAsig(as:
                                      Asignacion(
                                          docente:snapshot.data?[index]['docente'],
                                          edificio: snapshot.data?[index]['edificio'],
                                          horario:snapshot.data?[index]['horario'] ,
                                          materia:snapshot.data?[index]['materia']  ,
                                          salon: snapshot.data?[index]['salon'] ,
                                          id1: snapshot.data?[index]['id1']))
                                      ));
                                      setState((){});
                                    }
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete, color: Color(0xFF850E35)),
                                    onPressed: ()  {alert(index,snapshot);}),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (builder) => CapturarAsig())).then((value) => setState((){}));
          //setState((){});
          //actPlacas();
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void alert(int index,AsyncSnapshot<dynamic> snapshot) {
    showDialog(context: context, builder: (builder) {
          return AlertDialog(
            title: Text("ATENCION"),
            content:
            Text("¿Seguro que desea eliminar a ${snapshot.data?[index]
            ['docente']}?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await eliminarAsignacion(snapshot.data?[index]['id1']).then((_) => setState(() {}));
                    Navigator.pop(context);
                  },
                  child: Text("Sí")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
            ],
          );
        });
  }
}

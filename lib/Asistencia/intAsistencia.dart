import "package:dam_u4_proyecto2_19400617/Asistencia/asistencia.dart";
import "package:dam_u4_proyecto2_19400617/bd.dart";
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:mask_text_input_formatter/mask_text_input_formatter.dart";

class intAsistencia extends StatefulWidget {
  const intAsistencia({Key? key}) : super(key: key);

  @override
  State<intAsistencia> createState() => _intAsistenciaState();
}


String FechaActual() {
  final ahora = DateTime.now();
  final formato = DateFormat('yyyy-MM-dd HH:mm:ss');
  final fechaHoraActual = formato.format(ahora);
  return fechaHoraActual;
}

class _intAsistenciaState extends State<intAsistencia> {
  List<String> _docente = [];
  int interfaz=0;
  String? selectedD;
  final List<String> _edificio = ['A', 'CB', 'G', 'J', 'K','LC', 'UD', 'UVP','X'];
  String? selectedE;
  TextEditingController buscarD = TextEditingController();
  TextEditingController buscarE = TextEditingController();

  TextEditingController fechafinC = TextEditingController();
  TextEditingController fechainiC = TextEditingController();

  var dateMask = MaskTextInputFormatter(
      mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    actDocente();
  }

  Future<void> actDocente() async {
    await getDocente().then((docente) {
      setState(() {
        _docente = docente;
      });
    });
  }

  String convertirAsistencia(List<Map<String, dynamic>> asistencia) {
    String cadena = '';

    asistencia.forEach((map) {
      String fecha = map['fecha'] ?? '';
      String supervisor = map['revisor'] ?? '';
      cadena += '*' + fecha + '\n     Revisor: ' + supervisor + '\n';
    });

    return cadena;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.sync,color: Color(0xFF667761)),
                    onPressed: () {
                      setState(() {
                        interfaz=0;
                      });
                    },
                    tooltip: 'Recargar'
                ),
                SizedBox(width: 15,),
                DropdownButtonHideUnderline(
                  child: Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton(
                            hint: Text('Filtrar por docente', style: TextStyle(fontSize: 14)),
                            items: _docente
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,style:TextStyle(fontSize: 14)),
                            ))
                                .toList(),
                            value: selectedD,
                            onChanged: (value) {
                              setState(() {
                                selectedD = value as String;
                                buscarD.text = selectedD!;
                                interfaz=1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ), //FILTRAR DOCENTE
                SizedBox(width: 15,),
                DropdownButtonHideUnderline(
                  child: Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton(
                            hint: Text('Filtrar por edificio', style: TextStyle(fontSize: 14)),
                            items: _edificio
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,style:TextStyle(fontSize: 14)),
                            ))
                                .toList(),
                            value: selectedE,
                            onChanged: (value) {
                              setState(() {
                                selectedE = value as String;
                                buscarE.text = selectedE!;
                                interfaz=2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ), //FILTRAR EDIFICIO
                SizedBox(width: 15,),
                ElevatedButton(onPressed: (){
                  setState(() {
                    _FehaR();
                  });
                }, child: Text("FECHA")),
                SizedBox(width: 15,),
              ]),
      SizedBox(height: 15,),
          Expanded(
            child: FutureBuilder(
              future: interfaz==0 ? getAsignacion() : interfaz==1 ? getAsisDocente(buscarD.text) : interfaz==2 ? getAsisEdificio(buscarE.text) : getfechaIF(fechainiC.text,fechafinC.text),
              builder: ((context, snapshot) {
                return ListView.separated(
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(color: Color(0xFF8CC0DE)),
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap:(){
                            _ModalAsis(index,snapshot);
                          },
                          child: ListTile(
                            leading: Icon(Icons.account_balance_wallet_outlined),
                            title: Text("${snapshot.data?[index]['docente']}   Edificio:${snapshot.data?[index]['edificio']}  "),
                            subtitle:Text("${convertirAsistencia(snapshot.data?[index]['asistencias'])} "),
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
    );
  }


  void _ModalAsis(int index, AsyncSnapshot<List> snapshot, ) {
    final superC = TextEditingController();
    final idC = TextEditingController();

    idC.text = snapshot.data?[index]['id1'];
    print(idC.text);

    showModalBottomSheet(
        elevation: 20,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: MediaQuery.of(context).viewInsets.bottom + 30
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Insertar Revisor"),
                SizedBox(height: 10),
                TextField(controller: superC,
                    decoration: InputDecoration(labelText: "REVISOR")),
                SizedBox(height: 10),
                FilledButton(onPressed: () async {
                  Asistencia asi = Asistencia(
                      fecha: FechaActual(),
                      revisor: superC.text);
                 await  InsertarAsist(asi, idC.text).then((value) {setState((){});});
                  Navigator.pop(context);
                }, child: Text("Guardar Cambios")),
              ],
            ),
          );
        });
  }

  void _FehaR() {
    showModalBottomSheet(
        elevation: 20,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: MediaQuery.of(context).viewInsets.bottom + 30
          ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("FILTRAR POR RANGO DE FECHAS"),
                SizedBox(height: 10),
                TextField(
                 //   onSubmitted: (value) async {
                      //await getBitacoraPorFecha(value);
                 //     setState(() {
                 //       interfaz=3;
                 //     });
                  //  },
                    controller: fechainiC,
                    keyboardType: TextInputType.number,
                    inputFormatters: [dateMask],
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "2023/11/04",
                      labelText: "Fecha Inicio",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_available),
                    )),
                SizedBox(height: 10),
                TextField(
                  //  onSubmitted: (value) async {
                      //await getBitacoraPorFecha(value);
                  //    setState(() {
                  //      interfaz=3;
                  //    });
                   // },
                    controller: fechafinC,
                    keyboardType: TextInputType.number,
                    inputFormatters: [dateMask],
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "2023/11/07",
                      labelText: "Fecha Fin",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_available),
                    )),
                SizedBox(height: 10),
                FilledButton(onPressed: () {
                  setState(() {
                   interfaz=3;
                  });
                  Navigator.pop(context);
                }, child: Text("Buscar")),
              ],
            ),
          );
        });
  }
}

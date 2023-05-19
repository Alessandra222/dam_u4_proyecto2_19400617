import 'package:dam_u4_proyecto2_19400617/Asignacion/asignacion.dart';
import 'package:dam_u4_proyecto2_19400617/bd.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CapturarAsig extends StatefulWidget {
  const CapturarAsig({Key? key}) : super(key: key);

  @override
  State<CapturarAsig> createState() => _CapturarAsigState();
}

final docenteC = TextEditingController(); final salonC = TextEditingController();
final horarioC = TextEditingController(); final edificioC = TextEditingController();
final materiaC = TextEditingController();

final List<String> _edificio = ['A', 'CB', 'G', 'J', 'K','LC', 'UD', 'UVP','X'];
String? selectedE;

final List<String> _materia = ['ADMON. DE RES', 'B.D. NOSQL', 'DES. AP. MULT', 'DES. SERV. WEV', 'ECUACIONES DIF.','LENGUAJES DE INTERFAZ', 'MAT. DISCRETAS', 'P.O.O','TALLER DE INV. II','T.S.O'];
String? selectedM;

var horarioMask = MaskTextInputFormatter(
    mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

class _CapturarAsigState extends State<CapturarAsig> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insertar Asignación"), centerTitle: true, backgroundColor: Color(0xFF434371),),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('Materia', style: TextStyle(fontSize: 14)),
              items: _materia
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 14)),))
                  .toList(),
              value: selectedM,
              onChanged: (value) {
                setState(() {
                  selectedM = value as String;
                  materiaC.text = selectedM!;
                });
              },
            ),
          ),
          TextField(
              controller: docenteC,
              autofocus: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.camera_front_outlined), labelText: "DOCENTE")),
          TextField(
              controller: horarioC,
              keyboardType: TextInputType.number,
              inputFormatters: [horarioMask],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month),
                  labelText: "HORARIO",hintText: "08:00")),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('EDIFICIO', style: TextStyle(fontSize: 14)),
              items: _edificio
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 14))))
                  .toList(),
              value: selectedE,
              onChanged: (value) {
                setState(() {
                  selectedE = value as String;
                  edificioC.text = selectedE!;
                });
              },
            ),
          ),
          TextField(
              controller: salonC,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.home_work_outlined),
                  labelText: "SALON")),
          SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF850E35), // Color de fondo del botón
              ),
              onPressed: () async {
                if (materiaC.text.isEmpty || docenteC.text.isEmpty ||
                    horarioC.text.isEmpty || edificioC.text.isEmpty || salonC.text.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Por favor, llene todos los campos.")));
                } else {
                  Asignacion as = Asignacion(
                      materia: materiaC.text,
                      docente: docenteC.text,
                      horario: horarioC.text,
                      edificio: edificioC.text,
                      salon: salonC.text,
                      asistencia: []);

                  await insertarAsignacion(as).then((value) {
                    if (value > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("INSERTADO CON EXITO!")));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("ERROR al insertar el vehiculo x.x")));
                    }
                  });
                }
              },
              child: Text("INSERTAR"))
        ],
      ),
    );
  }
}

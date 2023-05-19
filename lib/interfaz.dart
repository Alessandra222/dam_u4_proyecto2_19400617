import 'package:dam_u4_proyecto2_19400617/Asignacion/intAsignacion.dart';
import 'package:dam_u4_proyecto2_19400617/Asistencia/intAsistencia.dart';
import "package:flutter/material.dart";
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class Interfaz extends StatefulWidget {
  const Interfaz({Key? key}) : super(key: key);

  @override
  State<Interfaz> createState() => _InterfazState();
}

class _InterfazState extends State<Interfaz> {
  int _indice = 0;

  void _cambiarIndice(int indice) {
    setState(() {
      _indice = indice;
    });
  }

  final List<Widget> _paginas = [
    intAsignacion(),
    intAsistencia()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgendaTec"),
        centerTitle: true,
        backgroundColor: Color(0xFF434371),
      ),
      body: _paginas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_sharp), label: "Asignacion"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Asistencia")
        ],
        currentIndex: _indice,
        onTap: _cambiarIndice,
        iconSize: 30,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFF434371),
        selectedItemColor: Color(0xFFF26B87),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

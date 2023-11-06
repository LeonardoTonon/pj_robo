import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

const step = 10.0;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const JoystickExample(),
      ),
    );
  }
}

class JoystickExample extends StatefulWidget {
  const JoystickExample({Key? key}) : super(key: key);

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 0;
  double _y = 0;

  // Endpoints para motores e direção
  static const String motorEndpoint = 'http://endereco-do-seu-motor';
  static const String direcaoEndpoint = 'http://endereco-da-direcao';

  void _sendPosition(String endpoint, double x, double y) async {
    final response = await http.post(
      Uri.parse(endpoint),
      body: {'x': x.toString(), 'y': y.toString()},
    );

    if (response.statusCode == 200) {
      print('Posição enviada com sucesso para $endpoint: $x, $y');
    } else {
      print('Falha ao enviar a posição para $endpoint: ${response.statusCode}');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: JoystickContainer(
                JoystickMode.horizontal,
                motorEndpoint, // Especifica o endpoint para o motor
                _sendPosition,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: JoystickContainer(
                JoystickMode.all,
                direcaoEndpoint, // Especifica o endpoint para a direção
                _sendPosition,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoystickContainer extends StatefulWidget {
  final JoystickMode mode;
  final String endpoint; // Novo: endpoint para onde enviar os dados
  final Function(String, double, double) onPositionChanged;

  const JoystickContainer(this.mode, this.endpoint, this.onPositionChanged,
      {Key? key})
      : super(key: key);

  @override
  State<JoystickContainer> createState() => _JoystickContainerState();
}

class _JoystickContainerState extends State<JoystickContainer> {
  @override
  void initState() {
    super.initState();
  }

  void _sendPosition(double x, double y) {
    widget.onPositionChanged(widget.endpoint, x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Joystick(
      mode: widget.mode,
      listener: (details) {
        _sendPosition(details.x, details.y);
        print('Posição atual: ${details.x}, ${details.y}');
      },
    );
  }
}

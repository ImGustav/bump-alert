import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../viewmodels/sensor_view_model.dart';
import '../widgets/axis_bar.dart';

/// X, Y e Z do acelerômetro em tempo real + teste de notificação.
class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  late final _vm = SensorViewModel(deps.notifications);

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acelerômetro')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_vm.error != null) Text(_vm.error!),
            const Text('Valores em m/s² (inclui a gravidade ≈ 9,81).'),
            const SizedBox(height: 16),
            AxisBar(label: 'X', value: _vm.x, color: Colors.red),
            AxisBar(label: 'Y', value: _vm.y, color: Colors.green),
            AxisBar(label: 'Z', value: _vm.z, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              'Intensidade total: ${_vm.magnitude.toStringAsFixed(2)} m/s²',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _vm.testNotification,
              icon: const Icon(Icons.notifications_active),
              label: const Text('Testar notificação local'),
            ),
          ],
        ),
      ),
    );
  }
}

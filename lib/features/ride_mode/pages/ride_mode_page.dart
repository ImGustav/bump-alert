import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/dependencies.dart';
import '../../../app/navigation.dart';
import '../viewmodels/ride_mode_view_model.dart';

/// Modo Trajeto: com o celular no carro/bike, um solavanco forte
/// indica um possível buraco.
class RideModePage extends StatefulWidget {
  const RideModePage({super.key});

  @override
  State<RideModePage> createState() => _RideModePageState();
}

class _RideModePageState extends State<RideModePage> {
  late final _vm = RideModeViewModel(deps.location, deps.notifications);

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_vm.active) return _vm.stop();
    final error = await _vm.start();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Trajeto')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          final e = _vm.sample;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: _vm.active ? scheme.primaryContainer : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        _vm.active
                            ? Icons.directions_car
                            : Icons.directions_car_outlined,
                        size: 56,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _vm.active
                            ? 'Detectando solavancos...'
                            : 'Coloque o celular no suporte do carro ou da bike e ligue o modo.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _vm.starting ? null : _toggle,
                        icon: Icon(_vm.active ? Icons.stop : Icons.play_arrow),
                        label: Text(_vm.active ? 'Parar' : 'Iniciar trajeto'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_vm.active && e != null) ...[
                const SizedBox(height: 12),
                Text(
                  'X ${e.x.toStringAsFixed(2)}   Y ${e.y.toStringAsFixed(2)}   Z ${e.z.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_vm.deviation / _vm.threshold).clamp(0.0, 1.0),
                  minHeight: 10,
                  color: _vm.deviation > _vm.threshold
                      ? Colors.red
                      : scheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Força do impacto (vermelho = solavanco)',
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Sensibilidade: limiar de ${_vm.threshold.toStringAsFixed(1)} m/s²',
              ),
              Slider(
                min: 3,
                max: 20,
                divisions: 34,
                value: _vm.threshold,
                label: _vm.threshold.toStringAsFixed(1),
                onChanged: (v) => _vm.threshold = v,
              ),
              const Text(
                'Menor = mais sensível. Para a demo, chacoalhe o celular.',
                style: TextStyle(fontSize: 12),
              ),
              const Divider(height: 32),
              Text(
                'Solavancos neste trajeto: ${_vm.bumps.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final b in _vm.bumps)
                ListTile(
                  leading: const Icon(Icons.vibration),
                  title: Text(
                    '${DateFormat.Hms().format(b.time)} — '
                    '${b.intensity.toStringAsFixed(1)} m/s²',
                  ),
                  subtitle: Text(
                    '${b.latitude.toStringAsFixed(6)}, '
                    '${b.longitude.toStringAsFixed(6)}',
                  ),
                  trailing: TextButton(
                    onPressed: () => openBumpReport(b.latitude, b.longitude),
                    child: const Text('Registrar'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

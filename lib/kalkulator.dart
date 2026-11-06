import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'profile.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key, this.onSaveResult});

  final ValueChanged<double>? onSaveResult;

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final _distanceController = TextEditingController(text: '12');
  String _vehicle = 'Sepeda motor';
  double? _result;

  static const _factors = <String, double>{
    'Sepeda motor': .103,
    'Mobil': .192,
    'Bus': .089,
    'Kereta': .041,
    'Berjalan / Bersepeda': 0,
  };

  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }

  void _calculate() {
    final distance =
        double.tryParse(_distanceController.text.replaceAll(',', '.')) ?? 0;
    final total = distance * _factors[_vehicle]!;

    setState(() => _result = total);

    if (widget.onSaveResult != null) {
      widget.onSaveResult!(total);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result ?? 0;

    // Pengecekan breakpoint responsif
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    // Spacing adaptif berdasarkan ukuran layar
    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 24),
      ],
    ).value;

    final form = _CalculatorForm(
      vehicle: _vehicle,
      vehicles: _factors.keys.toList(),
      distanceController: _distanceController,
      onVehicleChanged: (value) {
        setState(() {
          _vehicle = value!;
          _result = null;
        });
      },
      onCalculate: _calculate,
      isMobile: isMobile,
    );

    final output = _ResultCard(
      calculated: _result != null,
      vehicle: _vehicle,
      distance: _distanceController.text,
      result: result,
      isMobile: isMobile,
    );

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Ukur dampakmu',
            title: 'Kalkulator Jejak Karbon',
            description:
                'Hitung perkiraan emisi dari perjalanan harian dan dapatkan rekomendasi personal.',
          ),
          SizedBox(height: spacing),

          // Layout menyamping pada Desktop/Tablet Besar & menumpuk pada Mobile
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: form,
              ),
              ResponsiveRowColumnItem(
                child: SizedBox(
                  width: isDesktop ? spacing : 0,
                  height: isDesktop ? 0 : spacing,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: output,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalculatorForm extends StatelessWidget {
  const _CalculatorForm({
    required this.vehicle,
    required this.vehicles,
    required this.distanceController,
    required this.onVehicleChanged,
    required this.onCalculate,
    required this.isMobile,
  });

  final String vehicle;
  final List<String> vehicles;
  final TextEditingController distanceController;
  final ValueChanged<String?> onVehicleChanged;
  final VoidCallback onCalculate;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('01 — Transportasi'),
            const SizedBox(height: 8),
            Text(
              'Bagaimana kamu bepergian?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: isMobile ? 18 : 22,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Jenis kendaraan',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: vehicle,
              items: vehicles
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onVehicleChanged,
            ),
            const SizedBox(height: 18),
            const Text(
              'Jarak perjalanan per hari',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: distanceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                suffixText: 'km',
                isDense: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCalculate,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.forestLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Hitung & simpan emisi saya'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.calculated,
    required this.vehicle,
    required this.distance,
    required this.result,
    required this.isMobile,
  });

  final bool calculated;
  final String vehicle;
  final String distance;
  final double result;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(isMobile ? 22 : 30),
      decoration: BoxDecoration(
        color: calculated ? const Color(0xFF174333) : const Color(0xFF31584A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 52 : 62,
            height: isMobile ? 52 : 62,
            decoration: BoxDecoration(
              color: const Color(0xFF285C48),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.directions_car_outlined,
              color: const Color(0xFFD4EF86),
              size: isMobile ? 26 : 31,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PERKIRAAN EMISI HARIAN',
            style: TextStyle(
              color: Color(0xFF9BC2AE),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            calculated ? '${result.toStringAsFixed(2)} kg CO₂e' : '— kg CO₂e',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 26 : 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            calculated
                ? 'Setara dengan emisi dari penggunaan ${vehicle.toLowerCase()} sejauh $distance km.'
                : 'Isi jarak perjalanan, lalu tekan tombol hitung untuk melihat perkiraan emisi.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFAEC6BA),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          if (calculated) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF3A6654)),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco_outlined, color: Color(0xFFC8E675), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kurangi hingga ${(result * 0.65).toStringAsFixed(2)} kg dengan mengganti 2 perjalanan menggunakan transportasi umum atau sepeda.',
                      style: const TextStyle(
                        color: Color(0xFFB7CFC3),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _calculationType = 'Area';
  final TextEditingController _length = TextEditingController();
  final TextEditingController _width = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  String _result = '';

  void _calculate() {
    try {
      double length = double.tryParse(_length.text) ?? 0;
      double width = double.tryParse(_width.text) ?? 0;
      double height = double.tryParse(_height.text) ?? 0;
      double quantity = double.tryParse(_quantity.text) ?? 0;
      double rate = double.tryParse(_rate.text) ?? 0;

      double calculatedValue = 0;
      String unit = '';

      switch (_calculationType) {
        case 'Area':
          calculatedValue = length * width;
          unit = 'sq. ft';
          break;
        case 'Volume':
          calculatedValue = length * width * height;
          unit = 'cu. ft';
          break;
        case 'Concrete':
          // Calculate cubic yards for concrete
          calculatedValue = (length * width * height) / 27;
          unit = 'cu. yards';
          break;
        case 'Bricks':
          // Calculate number of bricks (assuming 1 sq ft = 7 bricks)
          calculatedValue = (length * width) * 7;
          unit = 'bricks';
          break;
        case 'Paint':
          // Calculate paint area (2 coats)
          calculatedValue = (length * width) * 2;
          unit = 'sq. ft';
          break;
        case 'Cost':
          calculatedValue = quantity * rate;
          unit = 'total cost';
          break;
      }

      setState(() {
        _result = '${calculatedValue.toStringAsFixed(2)} $unit';
      });
    } catch (e) {
      setState(() {
        _result = 'Error in calculation';
      });
    }
  }

  void _clear() {
    setState(() {
      _length.clear();
      _width.clear();
      _height.clear();
      _quantity.clear();
      _rate.clear();
      _result = '';
    });
  }

  @override
  void dispose() {
    _length.dispose();
    _width.dispose();
    _height.dispose();
    _quantity.dispose();
    _rate.dispose();
    super.dispose();
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calculation Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _calculationType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Area', child: Text('Area (sq. ft)')),
                        DropdownMenuItem(value: 'Volume', child: Text('Volume (cu. ft)')),
                        DropdownMenuItem(value: 'Concrete', child: Text('Concrete (cu. yards)')),
                        DropdownMenuItem(value: 'Bricks', child: Text('Bricks Required')),
                        DropdownMenuItem(value: 'Paint', child: Text('Paint Area')),
                        DropdownMenuItem(value: 'Cost', child: Text('Cost Calculation')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _calculationType = value!;
                          _clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Input Values',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_calculationType == 'Cost') ..[
                      _buildInputField('Quantity', _quantity),
                      _buildInputField('Rate per Unit', _rate),
                    ] else ..[
                      _buildInputField('Length (ft)', _length),
                      _buildInputField('Width (ft)', _width),
                      if (_calculationType == 'Volume' ||
                          _calculationType == 'Concrete')
                        _buildInputField('Height (ft)', _height),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Card(
                elevation: 4,
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Result',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

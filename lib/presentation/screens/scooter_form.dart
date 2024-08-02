import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:scooter_app/model/scooter_model.dart';
import 'package:scooter_app/presentation/cubits/scooter_cubit.dart';

class ScooterForm extends StatefulWidget {
  final ScooterModel? scooter;

  const ScooterForm({super.key, this.scooter});

  @override
  // ignore: library_private_types_in_public_api
  _ScooterFormState createState() => _ScooterFormState();
}

class _ScooterFormState extends State<ScooterForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _autonomyController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.scooter?.brand ?? '');
    _modelController = TextEditingController(text: widget.scooter?.model ?? '');
    _autonomyController = TextEditingController(text: widget.scooter?.autonomy.toString() ?? '');
    _weightController = TextEditingController(text: widget.scooter?.weight.toString() ?? '');
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _autonomyController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _brandController.clear();
    _modelController.clear();
    _autonomyController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scooter == null ? 'New Scooter' : 'Edit Scooter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField(
                  label: 'Brand',
                  controller: _brandController,
                  maxLength: 255,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Model',
                  controller: _modelController,
                  maxLength: 255,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Autonomy (km)',
                  controller: _autonomyController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mandatory field';
                    }
                    final doubleValue = double.parse(value);
                    if (doubleValue <= 0) {
                      return 'Autonomy must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Weight (kg)',
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mandatory field';
                    }
                    final doubleValue = double.parse(value);
                    if (doubleValue <= 0) {
                      return 'Weight must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final scooter = ScooterModel(
                            id: widget.scooter?.id ?? 0,
                            brand: _brandController.text,
                            model: _modelController.text,
                            autonomy: double.parse(_autonomyController.text),
                            weight: double.parse(_weightController.text),
                          );
                          if (widget.scooter == null) {
                            context.read<ScooterCubit>().saveScooter(scooter);
                          } else {
                            context.read<ScooterCubit>().updateScooter(scooter);
                          }
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _clearForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 92, 92, 92), width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator ?? (value) => value!.isEmpty ? 'Mandatory field' : null,
      ),
    );
  }
}
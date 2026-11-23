import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _company = "";
  String _position = "";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day-$month-${d.year}';
  }

  Future<DateTime?> _pickDate(DateTime? initial) {
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
  }

  String? _validateRequired(String? value, String label, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return "$label tidak boleh kosong!";
    }
    if (value.trim().length > maxLength) {
      return "$label maksimal $maxLength karakter!";
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pengalaman berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perusahaan: ${_company.trim()}'),
                Text('Posisi: ${_position.trim()}'),
                Text('Tanggal Mulai: ${_formatDate(_startDate)}'),
                Text(
                  'Tanggal Selesai: '
                  '${_endDate == null ? 'Masih berlangsung' : _formatDate(_endDate)}',
                ),
                Text(
                  'Deskripsi: '
                  '${_description.trim().isEmpty ? '-' : _description.trim()}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required IconData icon,
    required String? Function(DateTime?) validator,
    required ValueChanged<DateTime> onPicked,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormField<DateTime>(
        validator: (_) => validator(value),
        builder: (state) {
          return InkWell(
            borderRadius: BorderRadius.circular(5.0),
            onTap: () async {
              final picked = await _pickDate(value);
              if (picked != null) {
                onPicked(picked);
                state.didChange(picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                errorText: state.errorText,
                suffixIcon: Icon(icon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(value == null ? 'Pilih tanggal' : _formatDate(value)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Experience Form'),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Perusahaan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: PT Teknologi Nusantara",
                    labelText: "Nama Perusahaan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _company = value ?? "";
                    });
                  },
                  validator: (String? value) =>
                      _validateRequired(value, "Nama perusahaan", 100),
                ),
              ),

              // === Posisi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Mobile Developer Intern",
                    labelText: "Posisi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _position = value ?? "";
                    });
                  },
                  validator: (String? value) =>
                      _validateRequired(value, "Posisi", 100),
                ),
              ),

              // === Tanggal Mulai ===
              _dateField(
                label: "Tanggal Mulai",
                value: _startDate,
                icon: Icons.calendar_today,
                validator: (d) =>
                    d == null ? "Tanggal mulai wajib dipilih!" : null,
                onPicked: (d) => setState(() => _startDate = d),
              ),

              // === Tanggal Selesai (opsional) ===
              _dateField(
                label: "Tanggal Selesai (kosongkan jika masih berlangsung)",
                value: _endDate,
                icon: Icons.event,
                validator: (d) {
                  if (d != null && _startDate != null && d.isBefore(_startDate!)) {
                    return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                  }
                  return null;
                },
                onPicked: (d) => setState(() => _endDate = d),
              ),

              // === Deskripsi (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tugas dan pencapaian (maks. 300 karakter)",
                    labelText: "Deskripsi (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value != null && value.trim().length > 300) {
                      return "Deskripsi maksimal 300 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _save,
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
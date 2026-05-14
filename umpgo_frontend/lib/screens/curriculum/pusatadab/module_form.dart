import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/api.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/adab_nav.dart';

class ModuleForm extends StatefulWidget {
  final Map<String, dynamic>? module;
  const ModuleForm({super.key, this.module});

  @override
  State<ModuleForm> createState() => _ModuleFormState();
}

class _ModuleFormState extends State<ModuleForm> {
  bool loading = false;
  bool isEdit = false;

  final moduleNameController = TextEditingController();
  final moduleCodeController = TextEditingController();
  final startDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endDateController = TextEditingController();
  final endTimeController = TextEditingController();
  final campusController = TextEditingController();
  final venueController = TextEditingController();
  final catsController = TextEditingController();
  final slotsController = TextEditingController();
  final groupLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.module != null) {
      isEdit = true;
      moduleNameController.text = widget.module!['name'] ?? '';
      moduleCodeController.text = widget.module!['code'] ?? '';
      startDateController.text = widget.module!['startDate'] ?? '';
      startTimeController.text = widget.module!['startTime'] ?? '';
      endDateController.text = widget.module!['endDate'] ?? '';
      endTimeController.text = widget.module!['endTime'] ?? '';
      campusController.text = widget.module!['campus'] ?? '';
      venueController.text = widget.module!['venue'] ?? '';
      catsController.text = widget.module!['catsPoint']?.toString() ?? '';
      slotsController.text = widget.module!['maxSlots']?.toString() ?? '';
      groupLinkController.text = widget.module!['groupLink'] ?? '';
    }
  }

  @override
  void dispose() {
    moduleNameController.dispose();
    moduleCodeController.dispose();
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    campusController.dispose();
    venueController.dispose();
    catsController.dispose();
    slotsController.dispose();
    groupLinkController.dispose();
    super.dispose();
  }

  Future<void> pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> pickTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  void saveModule() async {
    if (moduleNameController.text.isEmpty ||
        moduleCodeController.text.isEmpty ||
        startDateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endDateController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        campusController.text.isEmpty ||
        venueController.text.isEmpty ||
        catsController.text.isEmpty ||
        slotsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final body = jsonEncode({
        'name': moduleNameController.text,
        'code': moduleCodeController.text,
        'startDate': startDateController.text,
        'startTime': startTimeController.text,
        'endDate': endDateController.text,
        'endTime': endTimeController.text,
        'campus': campusController.text,
        'venue': venueController.text,
        'catsPoint': int.parse(catsController.text),
        'maxSlots': int.parse(slotsController.text),
        'filledSlots': 0,
        'groupLink': groupLinkController.text,
      });

      http.Response response;

      if (isEdit) {
        response = await http.put(
          Uri.parse('${ApiConfig.baseUrl}/modules/${widget.module!['moduleID']}'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      } else {
        response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/modules'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEdit
                  ? 'Module updated successfully!'
                  : 'Module added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: Column(
        children: [
          // Breadcrumb
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFFD700),
            child: const Text(
              'Menu > Module List',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Edit Module' : 'Add New Module',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildField('Module:', moduleNameController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildField('Module Code:', moduleCodeController)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField('Start Class Date:', startDateController, () => pickDate(startDateController), 'yyyy-mm-dd'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateField('Start Class Time:', startTimeController, () => pickTime(startTimeController), '00:00'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField('End Class Date:', endDateController, () => pickDate(endDateController), 'yyyy-mm-dd'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateField('End Class Time:', endTimeController, () => pickTime(endTimeController), '00:00'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildField('Campus:', campusController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildField('Venue:', venueController)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField('Number of CATS:', catsController, hint: '0', keyboardType: TextInputType.number),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField('Number of Slots:', slotsController, hint: '0', keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField('WhatsApp/Telegram Group Link:', groupLinkController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : saveModule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B9BD5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdabNav(),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
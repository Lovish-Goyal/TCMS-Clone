import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/utils/converter_class.dart';
import '../../../shared/utils/custom_textfield.dart';
import '../../../shared/utils/date_picker.dart';
import '../../../shared/utils/image_picker.dart';
import '../../../shared/utils/show_dailog_box.dart';
import '../db/student_db.dart';
import '../model/student_model.dart';
import '../model/attachment_model.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  // Controllers
  late final TextEditingController studentIdController =
      TextEditingController();
  late final TextEditingController rollNumberController =
      TextEditingController();
  late final TextEditingController studentNameController =
      TextEditingController();
  late final TextEditingController parentsNameController =
      TextEditingController();
  late final TextEditingController dateOfBirthController =
      TextEditingController();
  late final TextEditingController addressController = TextEditingController();
  late final TextEditingController mobileNumberController =
      TextEditingController();
  late final TextEditingController mobileNumber2Controller =
      TextEditingController();
  late final TextEditingController feesAmountController =
      TextEditingController();
  late final TextEditingController startDateController =
      TextEditingController();
  late final TextEditingController classController = TextEditingController();
  late final TextEditingController schoolController = TextEditingController();
  late final TextEditingController field1Controller = TextEditingController();
  late final TextEditingController field2Controller = TextEditingController();
  late final TextEditingController field3Controller = TextEditingController();
  late final TextEditingController attachmentController =
      TextEditingController();

  String selectedBatch = 'Select Batch Name';
  String selectedFeeType = 'Monthly';
  String? selectedGender = "Male";
  int studentIdRange = 0;

  File? selectedProfileImage;
  List<AttachmentsModel> attachmentList = [];

  final List<String> batchOptions = ['Select Batch Name', 'Batch A', 'Batch B'];
  final List<String> feeTypes = ['Monthly', 'Quarterly', 'Annually'];

  @override
  void initState() {
    super.initState();
    _setNextStudentId();
  }

  Future<void> _setNextStudentId() async {
    final students = await StudentDb.dbInstance.getStudents();
    final nextId = students.length + 1;
    studentIdController.text = nextId.toString();
    studentIdRange = nextId;
  }

  @override
  void dispose() {
    studentIdController.dispose();
    rollNumberController.dispose();
    studentNameController.dispose();
    parentsNameController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    mobileNumberController.dispose();
    mobileNumber2Controller.dispose();
    feesAmountController.dispose();
    startDateController.dispose();
    classController.dispose();
    schoolController.dispose();
    field1Controller.dispose();
    field2Controller.dispose();
    field3Controller.dispose();
    attachmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("New Student")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileImagePicker(),
                CustomTextField(
                  title: 'Student ID',
                  controller: studentIdController,
                  isNumeric: true,
                ),
                CustomTextField(
                  title: 'Roll Number (Optional)',
                  controller: rollNumberController,
                  isNumeric: true,
                  isRequired: false,
                ),
                CustomTextField(
                  title: 'Student Name',
                  controller: studentNameController,
                ),
                CustomTextField(
                  title: 'Parents\'/ Guardian Name',
                  controller: parentsNameController,
                ),
                CustomTextField(
                  title: 'Date of Birth',
                  controller: dateOfBirthController,
                  isDisabled: true,
                  onFieldTapped: () => pickDate(context, dateOfBirthController),
                ),
                CustomTextField(
                  title: 'Mobile Number',
                  controller: mobileNumberController,
                  isMobile: true,
                ),
                CustomTextField(
                  title: 'Mobile Number (2)',
                  controller: mobileNumber2Controller,
                  isMobile: true,
                  isRequired: false,
                ),
                _buildGenderSelector(),
                CustomTextField(
                  title: 'Address',
                  controller: addressController,
                ),
                _buildDropdown('Batch Name', selectedBatch, batchOptions, (
                  value,
                ) {
                  setState(() => selectedBatch = value!);
                }),
                _buildDropdown('Fee Type', selectedFeeType, feeTypes, (value) {
                  setState(() => selectedFeeType = value!);
                }),
                CustomTextField(
                  title: 'Fees Amount',
                  controller: feesAmountController,
                  isNumeric: true,
                ),
                CustomTextField(
                  title: 'Start Date',
                  controller: startDateController,
                  isDisabled: true,
                  onFieldTapped: () => pickDate(context, startDateController),
                ),
                CustomTextField(
                  title: 'Class/Subject',
                  controller: classController,
                ),
                CustomTextField(
                  title: 'School/College',
                  controller: schoolController,
                ),
                CustomTextField(
                  title: 'Field 1 (Optional)',
                  controller: field1Controller,
                  isRequired: false,
                ),
                CustomTextField(
                  title: 'Field 2 (Optional)',
                  controller: field2Controller,
                  isRequired: false,
                ),
                CustomTextField(
                  title: 'Field 3 (Optional)',
                  controller: field3Controller,
                  isRequired: false,
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      dialogBuilder(context, _addAttachmentsDialog(context)),
                  child: const Text("Add Attachment"),
                ),
                const SizedBox(height: 10),
                _buildAttachmentList(),
                const SizedBox(height: 20),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: InkWell(
        onTap: () => _showImagePicker(context, isAttachment: false),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: selectedProfileImage != null
              ? CircleAvatar(
                  radius: 55,
                  backgroundImage: FileImage(selectedProfileImage!),
                )
              : const Icon(Icons.camera_alt, size: 110, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    const genders = ['Male', 'Female', 'Others'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: genders.map((gender) {
        return Row(
          children: [
            Radio<String>(
              value: gender,
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            Text(gender),
            const SizedBox(width: 10),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (value) => (value == null || value == options.first)
            ? 'Please select $label'
            : null,
      ),
    );
  }

  Widget _buildAttachmentList() {
    return ListView.builder(
      itemCount: attachmentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final attachment = attachmentList[index];
        return ListTile(
          leading: Image.memory(attachment.imageBytes, width: 30),
          title: Text(attachment.name),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => context.pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: _onSavePressed,
          child: const Text("Save"),
        ),
      ],
    );
  }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        studentId: studentIdController.text,
        profileImageBytes: selectedProfileImage != null
            ? await imageToBytes(selectedProfileImage!.path)
            : null,
        rollNumber: rollNumberController.text,
        studentName: studentNameController.text,
        guardianName: parentsNameController.text,
        dateOfBirth: dateOfBirthController.text,
        mobileNumber1: mobileNumberController.text,
        mobileNumber2: mobileNumber2Controller.text,
        gender: selectedGender ?? 'Male',
        address: addressController.text,
        batchName: selectedBatch,
        feeType: selectedFeeType,
        startDate: startDateController.text,
        classOrSubject: classController.text,
        schoolName: schoolController.text,
        optionalField1: field1Controller.text,
        optionalField2: field2Controller.text,
        optionalField3: field3Controller.text,
        acadmyId: '',
        uid: '',
        isActive: true,
      );

      await StudentDb.dbInstance.addStudent(student);
      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentIdController.text) // or auto ID: .doc()
            .set(student.toMap());

        // Optionally save attachments separately or with student doc
        // for (final attachment in attachmentList) {
        //   await FirebaseFirestore.instance
        //       .collection('students')
        //       .doc(studentIdController.text)
        //       .collection('attachments')
        //       .add({
        //         'name': attachment.name,
        //         'imageBytes': base64Encode(attachment.imageBytes),
        //       });
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student saved successfully!')),
        );

        context.pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save student: $e')));
      }
      context.pop();
    }
  }

  AlertDialog _addAttachmentsDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text("Enter Attachment Name"),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: attachmentController,
          validator: (value) => value!.isEmpty ? "Required" : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.pop();
              _showImagePicker(context, isAttachment: true);
            }
          },
          child: const Text("OK"),
        ),
      ],
    );
  }

  void _showImagePicker(BuildContext context, {bool isAttachment = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImagePickerDialog(
        onImagePicked: (source) => _pickImage(source, isAttachment),
      ),
    );
  }

  void _pickImage(ImageSource source, bool isAttachment) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final file = File(image.path);
      final bytes = await imageToBytes(file.path);

      setState(() {
        if (isAttachment) {
          attachmentList.add(
            AttachmentsModel(
              name: attachmentController.text,
              studentId: studentIdController.text,
              imageBytes: bytes,
            ),
          );
          attachmentController.clear();
        } else {
          selectedProfileImage = file;
        }
      });
    }
  }
}

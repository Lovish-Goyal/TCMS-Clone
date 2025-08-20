import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import '../../../shared/utils/converter_class.dart';
import '../../../shared/utils/custom_textfield.dart';
import '../../../shared/utils/date_picker.dart';
import '../../../shared/utils/image_picker.dart';
import '../../../shared/utils/show_dailog_box.dart';
import '../../../shared/utils/snacbar_helper.dart';
import '../db/student_db.dart';
import '../model/student_model.dart';
import 'attachment_model.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  late final TextEditingController studentIdController;
  late final TextEditingController rollNumberController;
  late final TextEditingController studentNameController;
  late final TextEditingController parentsNameController;
  late final TextEditingController dateOfBirthController;
  late final TextEditingController addressController;
  late final TextEditingController mobileNumberController;
  late final TextEditingController mobileNumber2Controller;
  late final TextEditingController feesAmountController;
  late final TextEditingController startDateController;
  late final TextEditingController classController;
  late final TextEditingController schoolController;
  late final TextEditingController field1Controller;
  late final TextEditingController field2Controller;
  late final TextEditingController field3Controller;
  late final TextEditingController attachmentController;

  String selectBatch = 'Select Batch Name';
  String feeType = '';
  String? _selectedGender = "Male";

  int studentIdRange = 0;
  File? selectedFile;
  File? attachmentFile;
  List<AttachmentsModel> attachmentList = [];

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  @override
  void initState() {
    super.initState();
    initializeControllers();
    _setNextStudentId();
  }

  void initializeControllers() {
    studentIdController = TextEditingController();
    rollNumberController = TextEditingController();
    studentNameController = TextEditingController();
    parentsNameController = TextEditingController();
    dateOfBirthController = TextEditingController();
    addressController = TextEditingController();
    mobileNumberController = TextEditingController();
    mobileNumber2Controller = TextEditingController();
    feesAmountController = TextEditingController();
    startDateController = TextEditingController();
    classController = TextEditingController();
    schoolController = TextEditingController();
    field1Controller = TextEditingController();
    field2Controller = TextEditingController();
    field3Controller = TextEditingController();
    attachmentController = TextEditingController();
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
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                    onFieldTapped: () =>
                        pickDate(context, dateOfBirthController),
                  ),
                  CustomTextField(
                    title: 'Mobile Number',
                    controller: mobileNumberController,
                    isMobile: true,
                    // onContactClicked: () =>
                    //     _fetchContact(mobileNumberController),
                  ),
                  CustomTextField(
                    title: 'Mobile Number (2)',
                    controller: mobileNumber2Controller,
                    isMobile: true,
                    // onContactClicked: () {}
                    //     _fetchContact(mobileNumber2Controller),
                    isRequired: false,
                  ),
                  _buildGenderSelector(),
                  CustomTextField(
                    title: 'Address',
                    controller: addressController,
                  ),
                  CustomTextField(
                    title: 'Batch Name',
                    controller: TextEditingController(text: selectBatch),
                  ),
                  CustomTextField(
                    title: 'Fee Type',
                    controller: TextEditingController(text: feeType),
                  ),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        dialogBuilder(context, _addAttachmentsDialog(context)),
                    child: const Text("Add Attachment"),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: attachmentList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.memory(
                          attachmentList[index].imageBytes,
                          width: 30,
                        ),
                        title: Text(attachmentList[index].name),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
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
          child: selectedFile != null
              ? CircleAvatar(
                  radius: 55,
                  backgroundImage: FileImage(selectedFile!),
                )
              : const Icon(Icons.camera_alt, size: 110, color: Colors.blue),
        ),
      ),
    );
  }

  Row _buildGenderSelector() {
    final genders = ['Male', 'Female', 'Others'];
    return Row(
      children: genders.map((gender) {
        return Row(
          children: [
            Radio<String>(
              value: gender,
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            Text(gender),
            const SizedBox(width: 10),
          ],
        );
      }).toList(),
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
      // if (selectBatch == 'Select Batch Name') {
      //   SnackbarHelper.showErrorSnackBar(context, "Please Select Batch Name");
      //   return;
      // }

      final student = Student(
        studentId: studentIdController.text,
        profileImageBytes: selectedFile != null
            ? await imageToBytes(selectedFile!.path)
            : null,
        rollNumber: rollNumberController.text,
        studentName: studentNameController.text,
        guardianName: parentsNameController.text,
        dateOfBirth: dateOfBirthController.text,
        mobileNumber1: mobileNumberController.text,
        mobileNumber2: mobileNumber2Controller.text,
        gender: _selectedGender ?? 'Male',
        address: addressController.text,
        batchName: selectBatch,
        feeType: feeType,
        // feeAmount: feesAmountController.text,
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
      final bytes = await imageToBytes(image.path);

      setState(() {
        if (isAttachment) {
          final attachment = AttachmentsModel(
            name: attachmentController.text,
            studentId: studentIdController.text,
            imageBytes: bytes,
          );
          attachmentList.add(attachment);
          attachmentController.clear();
        } else {
          selectedFile = file;
        }
      });
    }
  }

  void _fetchContact(TextEditingController controller) async {
    final contact = await _contactPicker.selectContact();
    if (contact != null) {
      controller.text =
          contact.phoneNumbers?.first.replaceAll(RegExp(r'[\s+]'), '') ?? '';
    }
  }
}

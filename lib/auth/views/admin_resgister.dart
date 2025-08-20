import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/router.dart';
import 'package:sems/shared/utils/snacbar_helper.dart';

import '../providers/auth_state.dart';
import '../providers/providers.dart';
import 'role_selection_signin.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String uid;
  final String email;
  final String name;

  const RegisterScreen({
    super.key,
    required this.uid,
    required this.email,
    required this.name,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _academyNameController = TextEditingController();
  final _academyIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _academyNameController.dispose();
    _academyIdController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (prev, state) {
      if (state is AuthAuthenticated) {
        _showSuccessDialog();
        SnackbarHelper.showSuccessSnackBar(context, 'Registration Successful');
        context.go(AppRoute.home.path);
      } else if (state is AuthError) {
        SnackbarHelper.showErrorSnackBar(context, 'Error: ${state.message}');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_emailController, 'Email', readOnly: true),
              _buildTextField(
                _academyNameController,
                'Academy Name',
                validator: (value) =>
                    value!.isEmpty ? 'Academy name cannot be empty' : null,
              ),
              _buildTextField(
                _phoneNumberController,
                'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  return !RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)
                      ? 'Please enter a valid phone number'
                      : null;
                },
              ),
              _buildTextField(_addressController, 'Address'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: context.pop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('EXIT'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('SIGN UP'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          fillColor: readOnly ? Colors.grey[200] : null,
          filled: readOnly,
        ),
        readOnly: readOnly,
        obscureText: isPassword,
        validator: validator,
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneNumberController.text.startsWith('+91')
          ? _phoneNumberController.text
          : '+91${_phoneNumberController.text}';
      String academyId = generateAcademyId(_academyNameController.text);

      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'academyName': _academyNameController.text,
        'academyId': academyId,
        'phoneNumber': phoneNumber,
        'address': _addressController.text,
        'role': UserRole.admin.name,
      };

      ref
          .read(authNotifierProvider.notifier)
          .completeRegistration(widget.uid, userData);
    }
  }

  String generateAcademyId(String academyName) {
    final year = DateTime.now().year;
    final academyPrefix = academyName.substring(0, 3).toUpperCase();
    return '$academyPrefix$year';
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successfully Registered'),
          content: const SizedBox(
            height: 100,
            child: Center(
              child: Icon(Icons.check_circle, size: 50, color: Colors.green),
            ),
          ),
          actions: [
            TextButton(child: const Text('OK'), onPressed: () => context.pop()),
          ],
        );
      },
    );
  }
}

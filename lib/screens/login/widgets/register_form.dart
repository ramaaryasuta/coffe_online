import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/loading.dart';
import '../../home/widgets/button_order.dart';
import '../provider/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool obsecurePass = true;
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukan Nama Lengkap Anda';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukan Email Anda';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: obsecurePass,
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                suffixIcon: obsecurePass
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePass = !obsecurePass;
                          });
                        },
                        icon: const Icon(Icons.visibility_off),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePass = !obsecurePass;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukan Kata Sandi Anda';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukan Nomor Telepon Anda';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _selectedItem,
                hint: const Text('Pilih Jenis akun'),
                isExpanded: true,
                items: <String>['user', 'merchant'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MyButton(
                onPressed: () {
                  register().then((_) {
                    LoadingDialog.hide(context);
                    if (context.read<AuthService>().successRegis == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Registrasi Berhasil'),
                        ),
                      );
                      Navigator.of(context).pushReplacementNamed('/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Registrasi Gagal'),
                        ),
                      );
                    }
                  });
                },
                child: Text(
                  'Daftar',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  side: WidgetStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.grey),
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: const Text('Sudah Punya Akun'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    final provider = context.read<AuthService>();
    if (formKey.currentState!.validate() && _selectedItem != null) {
      LoadingDialog.show(context, message: 'Membuat akun...');
      try {
        final fcmToken = await provider.createFCMToken();
        await provider.register(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          phoneNumber: phoneNumberController.text,
          type: _selectedItem!,
          fcmToken: fcmToken,
        );
      } catch (e) {
        printLog(e);
      }
    }
  }
}

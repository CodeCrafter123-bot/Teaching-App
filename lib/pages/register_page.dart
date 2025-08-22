import 'package:flutter/material.dart';
import 'package:teachingapp/services/auth_services.dart';
import '../core/routes.dart';
import '../widgets/edubot_logo.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("Registration attempt -> Name: $name, Email: $email, Password: $password"); // terminal logging

    try {
      await authService.register(name: name, email: email, password: password);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful!')));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EduBotLogo(),
                const SizedBox(height: 26),
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 26),
                CustomTextField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Please enter your name" : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter your email";
                    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!re.hasMatch(v.trim())) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _register(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter your password";
                    if (v.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: "Register", onPressed: _register, loading: isLoading),
                const SizedBox(height: 6),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Back to Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

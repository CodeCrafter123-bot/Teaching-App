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

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnimation =
        Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await authService.register(name: name, email: email, password: password);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89CFF0), Color(0xFF6D83F2)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const EduBotLogo(size: 16),
                        const SizedBox(height: 24),
                        Text("Create Account",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 26),
                        CustomTextField(
                          controller: nameController,
                          label: "Full Name",
                          icon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Please enter your name"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return "Please enter your email";
                            }
                            final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!re.hasMatch(v.trim())) {
                              return "Enter a valid email";
                            }
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
                            if (v == null || v.isEmpty) {
                              return "Please enter your password";
                            }
                            if (v.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                            label: "Register",
                            onPressed: _register,
                            loading: isLoading),
                        const SizedBox(height: 10),

                        // Toggle to Login
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login),
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

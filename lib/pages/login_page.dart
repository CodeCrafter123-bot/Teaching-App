import 'package:flutter/material.dart';
import 'package:teachingapp/services/auth_services.dart';
import '../core/routes.dart';
import '../widgets/edubot_logo.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final user = await authService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (user != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${user['name']}!')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        throw AuthException("Invalid email or password!");
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Something went wrong. Please try again.')),
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
            colors: [Color(0xFF6D83F2), Color(0xFF89CFF0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
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
                        Text("Welcome Back 👋",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 26),
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
                          onSubmitted: (_) => _login(),
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
                        const SizedBox(height: 22),
                        PrimaryButton(
                            label: "Login",
                            onPressed: _login,
                            loading: isLoading),
                        const SizedBox(height: 14),

                        // Toggle to Register
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.register),
                          child: const Text(
                            "Don't have an account? Register",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),

                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.discover),
                          child: const Text("Continue as Guest"),
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

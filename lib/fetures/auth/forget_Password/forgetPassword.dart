import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h20_application/core/routesmanger/routesManger.dart';
import 'package:h20_application/core/widget/Custom_Elvated button.dart';
import '../../../core/assetsmanger/assetsmanger.dart';
import '../../../core/resources/isvalidat.dart';
import '../../../core/widget/Custom_text_form.dart';
import '../../../l10n/app_localizations.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key});

  @override
  State<forgetpassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetpassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.reset_link_sent)),
      );
      Navigator.pushReplacementNamed(context, Routesmanger.Logins);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? l.failed_reset)),
      );
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.forget_password),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: AssetImage(Imagemanger.logoimage),
                  width: 136,
                  height: 150,
                ),
                const SizedBox(height: 32),
                Text(
                  l.enter_your_email,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.reset_password_subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextForm(
                  controller: _emailController,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return l.val_enter_email_short;
                    }
                    if (!Validator.isValidEmail(input.trim())) {
                      return l.val_invalid_email_short;
                    }
                    return null;
                  },
                  isObscure: false,
                  keyboardType: TextInputType.emailAddress,
                  labelText: l.email,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Coustom_Elvated_Button(
                        text: l.send_reset_link,
                        onPress: _sendPasswordResetEmail,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:ecommerce/provider/auth_provider.dart' as myauth;
import 'package:ecommerce/view/Mainscreen.dart';
import 'package:ecommerce/view/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool rememberMe = false;
  bool _isLoading = false;

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Provider.of<myauth.AuthProvider>(context, listen: false).login(
        emailController.text.trim(),
        passwordController.text,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Account sign-in successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Mainscreen()),
                );
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user =
          await Provider.of<myauth.AuthProvider>(context, listen: false)
              .signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Mainscreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _facebookSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user =
          await Provider.of<myauth.AuthProvider>(context, listen: false)
              .signInWithFacebook();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Mainscreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
   final auth=  Provider.of<myauth.AuthProvider>(context, listen: false);
              

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage:
                          const AssetImage('assets/images/istockphoto-1471521270-612x612.jpg'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlue),

                        borderRadius: BorderRadius.circular(12),

                      ),
                                                    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2), 
    ),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter email";
                      if (!value.contains('@')) return "Email must contain @";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlue),

                        borderRadius: BorderRadius.circular(12),
                      ),
                                                    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2), 
    ),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter password";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _signIn,
                            child: const Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Or sign in with',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _facebookSignIn,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue[800],
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: _googleSignIn,
                        child:  CircleAvatar(
  radius: 26,
  backgroundColor: Colors.white,
  child: Padding(
    padding:  EdgeInsets.all(10), 
    child: Image.asset(
      'assets/images/Google_G_logo.svg.png',
      fit: BoxFit.contain,
    ),
  ),
),

                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

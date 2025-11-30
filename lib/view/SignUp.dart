import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'package:ecommerce/main.dart';
import '../provider/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      fullNameController.text =
          fullNameController.text[0].toUpperCase() +
              fullNameController.text.substring(1);

await Provider.of<AuthProvider>(context, listen: false)
    .register(
      emailController.text.trim(),
      passwordController.text,
      fullName: fullNameController.text.trim(), 
    );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Account created successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>  MyHomePage(title: "Home")),
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
          await Provider.of<AuthProvider>(context, listen: false)
              .signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>  MyHomePage(title: "Home")),
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
          await Provider.of<AuthProvider>(context, listen: false)
              .signInWithFacebook();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>  MyHomePage(title: "Home")),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage:
                          const AssetImage('assets/images/istockphoto-1471521270-612x612.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover limitless choices',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                      
                        borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(12)),

                              focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2), 
    ),

                    ),
                    
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter full name";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.lightBlue),

                          borderRadius: BorderRadius.circular(12)),
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

                          borderRadius: BorderRadius.circular(12)),
                                                        focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2), 
    ),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter password";
                      if (value.length < 6)
                        return "Password must be at least 6 chars";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlue),

                          borderRadius: BorderRadius.circular(12)),
                                                        focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2), 
    ),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please confirm password";
                      if (value != passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: _signUp,
                            child: const Text(
                              'Sign Up',
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
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Sign In',
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AdviceApp());
}

class AdviceApp extends StatelessWidget {
  const AdviceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advice App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AdvicePage(),
    );
  }
}

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  String? _advice;
  bool _isLoading = false;
  String? _error;

  // fetch advice from API
  Future<void> _fetchAdvice() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse("https://api.adviceslip.com/advice"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _advice = data['slip']['advice'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Error: ${response.statusCode}, invalid link";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to fetch advice. Please check your connection.";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAdvice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text("Advice App"),
        backgroundColor: Colors.blue,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator() // loading state
              : _error != null
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchAdvice,
                child: const Text("Retry",
                style: TextStyle(
                  color: Colors.black
                )),
              )
            ],
          )
              : _advice != null
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "\"$_advice\"",
                    style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchAdvice,
                child: const Text("Get New Advice",
                    style: TextStyle(
                        color: Colors.black
                    )),
              )
            ],
          )
              : const Text("No advice available.",
              style: TextStyle(
                  color: Colors.black
              )),
        ),
      ),
    );
  }
}
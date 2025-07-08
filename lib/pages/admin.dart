import 'package:flutter/material.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';

class Admin extends StatefulWidget {
  const Admin();

  @override
  State<Admin> createState() => AdminState();
}

class AdminState extends State<Admin> {
  String message = '';
  bool isLoading = false;

  Future<void> syncAll(BuildContext context) async {
    final service = ResortService();
    setState(() {
      isLoading = true;
    });
    try {
      final syncCount = await service.syncAll();
      setState(() {
        message = '$syncCount件を同期しました';
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Home(),
        ),
      );
    } catch (e) {
      setState(() {
        message = '同期に失敗しました';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'データを同期',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsetsGeometry.only(top: 10)),
                  ElevatedButton(
                    onPressed: () => syncAll(context),
                    child: Icon(
                      Icons.sync,
                    ),
                  ),
                  const Padding(padding: EdgeInsetsGeometry.only(top: 30)),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

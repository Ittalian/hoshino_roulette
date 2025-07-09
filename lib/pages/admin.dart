import 'package:flutter/material.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';

class Admin extends StatefulWidget {
  const Admin();

  @override
  State<Admin> createState() => AdminState();
}

class AdminState extends State<Admin> {
  int syncCount = 0;
  bool isLoading = false;

  Future<void> syncAll(BuildContext context) async {
    final service = ResortService();
    setState(() {
      isLoading = true;
    });
    try {
      syncCount = await service.syncAll();
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$syncCount件のデータを同期しました',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Home(),
        ),
      );
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '同期に失敗しました',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
                ],
              ),
      ),
    );
  }
}

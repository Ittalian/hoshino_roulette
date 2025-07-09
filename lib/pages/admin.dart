import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void linkData() async {
    final url = Uri.parse(dotenv.get('sheet_url'));
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'URLが存在しません',
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
                  TextButton(
                    onPressed: () => linkData(),
                    child: Text(
                      'データを確認',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '同期',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      ElevatedButton(
                        onPressed: () => syncAll(context),
                        child: Icon(
                          Icons.sync,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => AdminState();
}

class AdminState extends State<Admin> {
  int syncCount = 0;
  bool isLoading = false;

  Future<void> syncAll(BuildContext context) async {
    final service = ResortService();
    setState(() => isLoading = true);
    try {
      syncCount = await service.syncAll();
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$syncCount 件のデータを同期しました',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      // Home 画面へ置換
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '同期に失敗しました',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> linkData() async {
    final url = Uri.parse(dotenv.get('sheet_url'));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'URLが存在しません',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor      = Color(0xFFFFF3F8);
    const appBarColor  = Color(0xFFCFFAEB);
    final shadowColor  = Colors.pinkAccent.withValues(alpha: 0.2);
    final linkBtnColor = Colors.cyan.shade100;
    final syncBtnColor = Colors.pinkAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'データ管理',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: syncBtnColor)
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: linkData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: linkBtnColor,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: const Text(
                          'データを確認',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '同期',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => syncAll(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: syncBtnColor,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Icon(Icons.sync, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

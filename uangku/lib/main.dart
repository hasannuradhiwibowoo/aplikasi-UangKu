import 'package:flutter/material.dart';

import 'fitur/onboarding/halaman/halaman_onboarding.dart';
import 'fitur/onboarding/halaman/halaman_splash.dart';
import 'fitur/transaksi/halaman/catat_pengeluaran.dart';

void main() {
  runApp(const UangKuApp());
}

class UangKuApp extends StatelessWidget {
  const UangKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UangKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF07966F),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAF8),
        useMaterial3: true,
      ),
      home: const HalamanSplash(
        halamanBerikutnya: HalamanOnboarding(
          halamanTujuan: HalamanBeranda(),
        ),
      ),
    );
  }
}

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  Future<void> _bukaFormPengeluaran(BuildContext context) async {
    final berhasil = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => const HalamanCatatPengeluaran(),
      ),
    );

    if (!context.mounted || berhasil != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengeluaran berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UangKu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_wallet_outlined, size: 56),
              const SizedBox(height: 16),
              const Text(
                'Catat pengeluaran pertamamu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Transaksi yang disimpan akan masuk ke penyimpanan lokal.'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _bukaFormPengeluaran(context),
                icon: const Icon(Icons.add),
                label: const Text('Catat Pengeluaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

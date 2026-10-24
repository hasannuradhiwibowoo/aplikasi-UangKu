import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../layanan/penyimpanan_transaksi.dart';
import '../model/transaksi.dart';

class HalamanCatatPengeluaran extends StatefulWidget {
  const HalamanCatatPengeluaran({super.key});

  @override
  State<HalamanCatatPengeluaran> createState() =>
      _HalamanCatatPengeluaranState();
}

class _HalamanCatatPengeluaranState
    extends State<HalamanCatatPengeluaran> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  final _catatanController = TextEditingController();

  final Map<String, String> _kategori = const {
    'makanan': 'Makanan',
    'transportasi': 'Transportasi',
    'hiburan': 'Hiburan',
    'sekolah': 'Sekolah',
    'belanja': 'Belanja',
    'lainnya': 'Lainnya',
  };

  String _kategoriTerpilih = 'makanan';
  DateTime _tanggal = DateTime.now();
  bool _sedangMenyimpan = false;

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final tanggalDipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (tanggalDipilih != null) {
      setState(() => _tanggal = tanggalDipilih);
    }
  }

  Future<void> _simpanTransaksi() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final sekarang = DateTime.now();
    final transaksi = Transaksi(
      id: sekarang.microsecondsSinceEpoch.toString(),
      jenis: JenisTransaksi.pengeluaran,
      judul: _judulController.text.trim(),
      nominal: int.parse(_nominalController.text),
      kategoriId: _kategoriTerpilih,
      waktuTransaksi: _tanggal,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
      dibuatPada: sekarang,
      diperbaruiPada: sekarang,
    );

    setState(() => _sedangMenyimpan = true);

    try {
      await PenyimpananTransaksi.instance.tambahTransaksi(transaksi);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi gagal disimpan: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _sedangMenyimpan = false);
      }
    }
  }

  String _teksTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catat Pengeluaran')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Nama pengeluaran',
                hintText: 'Contoh: Makan siang',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (nilai) {
                if (nilai == null || nilai.trim().isEmpty) {
                  return 'Nama pengeluaran wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nominalController,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rupiah)',
                hintText: 'Contoh: 15000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (nilai) {
                final nominal = int.tryParse(nilai ?? '');
                if (nominal == null || nominal <= 0) {
                  return 'Masukkan nominal lebih dari nol';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategoriTerpilih,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _kategori.entries.map((kategori) {
                return DropdownMenuItem<String>(
                  value: kategori.key,
                  child: Text(kategori.value),
                );
              }).toList(),
              onChanged: (nilai) {
                if (nilai != null) {
                  setState(() => _kategoriTerpilih = nilai);
                }
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tanggal transaksi'),
              subtitle: Text(_teksTanggal(_tanggal)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pilihTanggal,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _sedangMenyimpan ? null : _simpanTransaksi,
              child: Text(
                _sedangMenyimpan ? 'Menyimpan...' : 'Simpan Pengeluaran',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

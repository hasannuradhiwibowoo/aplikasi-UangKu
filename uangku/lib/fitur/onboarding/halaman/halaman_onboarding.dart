import 'package:flutter/material.dart';

class HalamanOnboarding extends StatefulWidget {
  const HalamanOnboarding({
    super.key,
    required this.halamanTujuan,
  });

  final Widget halamanTujuan;

  @override
  State<HalamanOnboarding> createState() => _HalamanOnboardingState();
}

class _HalamanOnboardingState extends State<HalamanOnboarding> {
  static const _hijau = Color(0xFF07966F);
  static const _hijauMuda = Color(0xFFD8F8E9);

  final _pengontrolHalaman = PageController();
  final _uangJajanController = TextEditingController();
  final _targetController = TextEditingController();
  final _hargaController = TextEditingController(text: '30000');
  final _saldoController = TextEditingController(text: '200000');
  int _halamanAktif = 0;
  String _frekuensi = 'Bulanan';
  bool _pengingatAktif = true;
  bool _evaluasiMingguan = true;
  TimeOfDay _waktuPengingat = const TimeOfDay(hour: 20, minute: 0);

  int get _nominalUangJajan => _angka(_uangJajanController.text);
  int get _saldo => _angka(_saldoController.text);
  int get _harga => _angka(_hargaController.text);

  int _angka(String nilai) => int.tryParse(nilai.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  String _rupiah(int nilai) {
    final digit = nilai.toString();
    final hasil = StringBuffer();
    for (var i = 0; i < digit.length; i++) {
      if (i > 0 && (digit.length - i) % 3 == 0) hasil.write('.');
      hasil.write(digit[i]);
    }
    return 'Rp${hasil.toString()}';
  }

  @override
  void dispose() {
    _pengontrolHalaman.dispose();
    _uangJajanController.dispose();
    _targetController.dispose();
    _hargaController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  void _bukaAplikasi() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => widget.halamanTujuan),
    );
  }

  void _lanjut() {
    if (_halamanAktif == 0 && _nominalUangJajan <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nominal uang jajanmu dulu ya.')),
      );
      return;
    }
    if (_halamanAktif == 2) {
      _bukaAplikasi();
      return;
    }
    _pengontrolHalaman.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _kembali() {
    if (_halamanAktif == 0) return;
    _pengontrolHalaman.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      locale: const Locale('id', 'ID'),
    );
    if (tanggal != null && mounted) {
      setState(() => _tanggalTerimaBerikutnya = tanggal);
    }
  }

  DateTime _tanggalTerimaBerikutnya = DateTime(2026, 11, 1);

  Future<void> _pilihWaktu() async {
    final waktu = await showTimePicker(
      context: context,
      initialTime: _waktuPengingat,
    );
    if (waktu != null && mounted) setState(() => _waktuPengingat = waktu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: _halamanAktif == 0
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: _kembali,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                            padding: EdgeInsets.zero,
                          ),
                  ),
                  Expanded(
                    child: Text(
                      _halamanAktif == 0 ? 'LANGKAH 1 DARI 3' : 'LANGKAH ${_halamanAktif + 1} DARI 3',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF718078),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: TextButton(
                      onPressed: _bukaAplikasi,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text('Lewati', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pengontrolHalaman,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (halaman) => setState(() => _halamanAktif = halaman),
                children: [
                  _halamanAnggaran(),
                  _halamanCekBelanja(),
                  _halamanPengingat(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _lanjut,
                  style: FilledButton.styleFrom(
                    backgroundColor: _hijau,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_halamanAktif == 2 ? 'Simpan Pengaturan' : 'Lanjutkan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _halamanAnggaran() {
    return _konten(
      judul: 'Mulai atur uang jajanmu',
      deskripsi: 'Biar uangmu lebih terarah sampai waktunya.',
      anak: [
        _kartuInfo(
          ikon: Icons.account_balance_wallet_rounded,
          judul: 'Rencana sederhana, lebih tenang.',
          warna: _hijauMuda,
        ),
        const SizedBox(height: 22),
        _label('Berapa uang jajanmu?'),
        _kolomAngka(controller: _uangJajanController, petunjuk: 'Contoh: 450.000'),
        const SizedBox(height: 18),
        _label('Seberapa sering kamu menerima uang?'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Harian', 'Mingguan', 'Bulanan'].map((opsi) {
            final terpilih = _frekuensi == opsi;
            return ChoiceChip(
              label: Text(opsi),
              selected: terpilih,
              onSelected: (_) => setState(() => _frekuensi = opsi),
              selectedColor: _hijauMuda,
              labelStyle: TextStyle(color: terpilih ? _hijau : const Color(0xFF52615A)),
              side: BorderSide(color: terpilih ? _hijau : const Color(0xFFE2EAE5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _label('Tanggal menerima uang berikutnya'),
        const SizedBox(height: 7),
        InkWell(
          onTap: _pilihTanggal,
          borderRadius: BorderRadius.circular(10),
          child: _kartuInput(
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF738078)),
                const SizedBox(width: 10),
                Text('${_tanggalTerimaBerikutnya.day} ${_namaBulan(_tanggalTerimaBerikutnya.month)} ${_tanggalTerimaBerikutnya.year}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _label('Target tabungan (opsional)'),
        _kolomAngka(controller: _targetController, petunjuk: 'Contoh: 45.000'),
      ],
    );
  }

  Widget _halamanCekBelanja() {
    final sisa = _saldo - _harga;
    return _konten(
      judul: 'Cek sebelum membeli',
      deskripsi: 'Lihat dampaknya ke anggaranmu.',
      anak: [
        _label('Harga barang'),
        _kolomAngka(controller: _hargaController, petunjuk: '30.000'),
        const SizedBox(height: 18),
        _label('Uang yang tersedia'),
        _kolomAngka(controller: _saldoController, petunjuk: '200.000'),
        const SizedBox(height: 18),
        _kartuSaldo('Saldo saat ini', _rupiah(_saldo), warna: Colors.white),
        const SizedBox(height: 14),
        Center(child: Icon(Icons.south_rounded, color: _hijau, size: 22)),
        const SizedBox(height: 14),
        _kartuSaldo('Sisa setelah pembelian', _rupiah(sisa < 0 ? 0 : sisa), warna: _hijauMuda, utama: true),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFFFF2C9), borderRadius: BorderRadius.circular(12)),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFE89B00), size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('Pertimbangkan anggaranmu sebelum membeli. Keputusan tetap di tanganmu.', style: TextStyle(fontSize: 12, height: 1.4))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _halamanPengingat() {
    final waktu = _waktuPengingat.format(context);
    return _konten(
      judul: 'Pengingat',
      deskripsi: 'Pilih pengingat yang cocok untukmu.',
      anak: [
        _kartuToggle(
          judul: 'Pengingat harian',
          deskripsi: 'Ingat untuk mencatat pengeluaran',
          aktif: _pengingatAktif,
          saatDiubah: (nilai) => setState(() => _pengingatAktif = nilai),
        ),
        const SizedBox(height: 20),
        _label('Waktu pengingat'),
        const SizedBox(height: 7),
        InkWell(
          onTap: _pilihWaktu,
          borderRadius: BorderRadius.circular(10),
          child: _kartuInput(
            child: Row(children: [Expanded(child: Text(waktu)), const Icon(Icons.chevron_right_rounded)]),
          ),
        ),
        const SizedBox(height: 22),
        _label('Pengingat anggaran'),
        const SizedBox(height: 8),
        _kartuInfo(
          ikon: Icons.savings_outlined,
          judul: 'Saat anggaran tercapai',
          warna: Colors.white,
          trailing: const Text('80%     100%', style: TextStyle(color: _hijau, fontWeight: FontWeight.w700, fontSize: 11)),
        ),
        const SizedBox(height: 10),
        _kartuToggle(
          judul: 'Evaluasi mingguan',
          deskripsi: 'Ringkasan setiap Minggu',
          aktif: _evaluasiMingguan,
          saatDiubah: (nilai) => setState(() => _evaluasiMingguan = nilai),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: _hijauMuda, borderRadius: BorderRadius.circular(12)),
          child: const Text('Pengingat bisa diubah atau dimatikan kapan saja. Hindari notifikasi yang terlalu sering.', style: TextStyle(color: Color(0xFF14744F), fontSize: 12, height: 1.4)),
        ),
      ],
    );
  }

  Widget _konten({required String judul, required String deskripsi, required List<Widget> anak}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF17251F))),
          const SizedBox(height: 5),
          Text(deskripsi, style: const TextStyle(color: Color(0xFF7A8981), fontSize: 13)),
          const SizedBox(height: 22),
          ...anak,
        ],
      ),
    );
  }

  Widget _label(String teks) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Text(teks, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF26362E))),
      );

  Widget _kolomAngka({required TextEditingController controller, required String petunjuk}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: petunjuk,
        prefixText: 'Rp ',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE4EBE6))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE4EBE6))),
      ),
    );
  }

  Widget _kartuInput({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE4EBE6)), borderRadius: BorderRadius.circular(10)),
        child: child,
      );

  Widget _kartuInfo({required IconData ikon, required String judul, required Color warna, Widget? trailing}) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: warna, borderRadius: BorderRadius.circular(13)),
        child: Row(
          children: [
            CircleAvatar(radius: 17, backgroundColor: warna == Colors.white ? _hijauMuda : Colors.white.withValues(alpha: 0.75), child: Icon(ikon, color: _hijau, size: 18)),
            const SizedBox(width: 11),
            Expanded(child: Text(judul, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF26362E)))),
            if (trailing != null) trailing,
          ],
        ),
      );

  Widget _kartuSaldo(String label, String nominal, {required Color warna, bool utama = false}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: warna, borderRadius: BorderRadius.circular(13), border: warna == Colors.white ? Border.all(color: const Color(0xFFE4EBE6)) : null),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF718078))),
          const SizedBox(height: 5),
          Text(nominal, style: TextStyle(fontSize: utama ? 23 : 21, fontWeight: FontWeight.w700, color: utama ? _hijau : const Color(0xFF17251F))),
        ]),
      );

  Widget _kartuToggle({required String judul, required String deskripsi, required bool aktif, required ValueChanged<bool> saatDiubah}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE4EBE6)), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(judul, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(deskripsi, style: const TextStyle(fontSize: 10, color: Color(0xFF7A8981))),
          ])),
          Switch(value: aktif, activeTrackColor: _hijau, onChanged: saatDiubah),
        ]),
      );

  String _namaBulan(int bulan) => const [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ][bulan - 1];
}

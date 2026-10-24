enum JenisTransaksi {
  pemasukan,
  pengeluaran,
}

class Transaksi {
  const Transaksi({
    required this.id,
    required this.jenis,
    required this.judul,
    required this.nominal,
    required this.kategoriId,
    required this.waktuTransaksi,
    this.catatan,
    required this.dibuatPada,
    required this.diperbaruiPada,
  }) : assert(nominal > 0, 'Nominal harus lebih besar dari nol');
  final String id;
  final JenisTransaksi jenis;
  final String judul;
  final int nominal;
  final String kategoriId;
  final DateTime waktuTransaksi;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
}
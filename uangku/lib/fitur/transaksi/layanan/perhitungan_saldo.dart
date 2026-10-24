import '../model/transaksi.dart';

int hitungSaldo({
  required int saldoAwal,
  required List<Transaksi> transaksi,
}) {
  var saldo = saldoAwal;
  for (final item in transaksi) {
    switch (item.jenis) {
      case JenisTransaksi.pemasukan:
      saldo += item.nominal;
      case JenisTransaksi.pengeluaran:
      saldo -= item.nominal;
    }
  }
  return saldo;
}
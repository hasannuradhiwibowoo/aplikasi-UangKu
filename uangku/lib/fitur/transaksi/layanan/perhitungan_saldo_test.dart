import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/fitur/transaksi/layanan/perhitungan_saldo.dart';
import 'package:uangku/fitur/transaksi/model/transaksi.dart';

void main() {
  test('saldo dihitung dari pemasukan dikurangi pengeluaran', () {
    final sekarang = DateTime.now();
    final transaksi = [
      Transaksi(
        id: '01',
        jenis: JenisTransaksi.pemasukan,
        judul: 'uang jajan',
        nominal: 20000,
        kategoriId: 'uang_jajan',
        waktuTransaksi: sekarang,
        dibuatPada: sekarang,
        diperbaruiPada: sekarang,
      ),
      Transaksi(
        id: '2',
        jenis: JenisTransaksi.pengeluaran,
        judul: 'Makan',
        nominal: 3000,
        kategoriId: 'makanan',
        waktuTransaksi: sekarang,
        dibuatPada: sekarang,
        diperbaruiPada: sekarang,
      ),
    ];
    final saldo = hitungSaldo(saldoAwal: 10000, transaksi: transaksi,);
    expect(saldo, 12000);
  });
}
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/transaksi.dart';

class PenyimpananTransaksi {
  PenyimpananTransaksi._();
  static final instance = PenyimpananTransaksi._();
  Future<Database>? _database;
  Future<Database> get _db {
    return _database ??= _bukaDatabase();
  }
  Future<Database> _bukaDatabase() async {
    final lokasiDatabase = join(
      await getDatabasesPath(),
        'uangku.db',
      );
      return openDatabase(lokasiDatabase, version: 1, onCreate: (database, version) async {
        await database.execute('''
CREATE TABLE transaksi (id TEXT PRIMARY KEY, jenis TEXT NOT NULL CHECK (jenis IN ('pemasukan', 'pengeluaran')),
judul TEXT NOT NULL CHECK (length(trim(judul)) > 0),
nominal INTEGER NOT NULL CHECK (nominal > 0),
kategori_id TEXT NOT NULL,
waktu_transaksi TEXT NOT NULL,
catatan TEXT,
dibuat_pada TEXT NOT NULL,
diperbarui_pada TEXT NOT NULL
)
''');
      },
    );
  }
  Future<void> tambahTransaksi(Transaksi transaksi) async {
    final database = await _db;
    await database.insert(
      'transaksi',
      _keMap(transaksi),
    );
  } 
  Future<List<Transaksi>> ambilSemuaTransaksi() async {
    final database = await _db;
    final baris = await database.query(
      'transaksi',
      orderBy: 'waktu_transaksi DESC',
    );
    return baris.map(_dariMap).toList();
  }
  Future<void> perbaruiTransaksi(Transaksi transaksi) async {
    final database = await _db;
    await database.update(
      'transaksi',
      _keMap(transaksi),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }
  Future<void> hapusTransaksi(String id) async {
    final database = await _db;
    await database.delete(
      'transaksi',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Map<String, Object?> _keMap(Transaksi transaksi) {
    return {
      'id': transaksi.id,
      'jenis': transaksi.jenis.name,
      'judul': transaksi.judul,
      'nominal': transaksi.nominal,
      'kategori_id': transaksi.kategoriId,
      'waktu_transaksi': transaksi.waktuTransaksi.toIso8601String(),
      'catatan': transaksi.catatan,
      'dibuat_pada': transaksi.dibuatPada.toIso8601String(),
      'diperbarui_pada': transaksi.diperbaruiPada.toIso8601String(),
    };
  }
  Transaksi _dariMap(Map<String, Object?> baris) {
    return Transaksi(
      id: baris['id'] as String,
      jenis: JenisTransaksi.values.byName(baris['jenis'] as String),
      judul: baris['judul'] as String,
      nominal: baris['nominal'] as int,
      kategoriId: baris['kategori_id'] as String,
      waktuTransaksi: DateTime.parse(baris['waktu_transaksi'] as String,),
      catatan: baris['catatan'] as String?,
      dibuatPada: DateTime.parse(baris['dibuat_pada'] as String,),
      diperbaruiPada: DateTime.parse(baris['diperbarui_pada'] as String,),
    );
  }
}

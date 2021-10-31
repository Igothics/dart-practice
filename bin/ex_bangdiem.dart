import 'dart:convert';
import 'dart:io';

void main(){
  final file = File(r'res/bang_diem_chi_tiet.json');
  final dataAsString = file.readAsStringSync();
  final dataAsMap = Map<String, dynamic>.from(jsonDecode(dataAsString));
  final bangDiem = BangDiem.from(dataAsMap);
  bangDiem.printTongKet();
}

class BangDiem {
  static const khoiA = ['mon toan', 'mon ly', 'mon hoa'];
  static const khoiA1 = ['mon toan', 'mon ly', 'mon anh'];
  static const khoiB = ['mon toan', 'mon hoa', 'mon sinh'];
  static const khoiC = ['mon van', 'mon su', 'mon dia'];
  static const khoiD = ['mon toan', 'mon van', 'mon anh'];
  final Map<String, DiemBoMon> _diemBoMon;
  BangDiem(this._diemBoMon);

  factory BangDiem.from(Map<String, dynamic> tatCaboMon){
    final result = <String, DiemBoMon>{};
    for (var boMon in tatCaboMon.entries){
      result[boMon.key] = DiemBoMon.from(boMon.value);
    }
    return BangDiem(result);
  }

  Map<String, double> get diemTBBoMon => _diemBoMon.map((tenBoMon, diemBoMon) => MapEntry(tenBoMon, diemBoMon.diemTB));
  double get tongDiemTB => diemTBBoMon.values.reduce((v, e) => v + e) / diemTBBoMon.length;
  List<double> get diem3MonChinh => [diemTBBoMon["mon toan"]!, diemTBBoMon["mon van"]!, diemTBBoMon["mon anh"]!];

  double get diemKhoiA => diemTBBoMon.entries.where((entry) => khoiA.contains(entry.key)).map((entry) => entry.value).reduce((v, e) => v + e) / 3;
  double get diemKhoiA1 => diemTBBoMon.entries.where((entry) => khoiA1.contains(entry.key)).map((entry) => entry.value).reduce((v, e) => v + e) / 3;
  double get diemKhoiB => diemTBBoMon.entries.where((entry) => khoiB.contains(entry.key)).map((entry) => entry.value).reduce((v, e) => v + e) / 3;
  double get diemKhoiC => diemTBBoMon.entries.where((entry) => khoiC.contains(entry.key)).map((entry) => entry.value).reduce((v, e) => v + e) / 3;
  double get diemKhoiD => diemTBBoMon.entries.where((entry) => khoiD.contains(entry.key)).map((entry) => entry.value).reduce((v, e) => v + e) / 3;

  String xepLoaiHocLuc() {
    if ((tongDiemTB >= 8.0) && diemTBBoMon.values.every((diem) => diem >= 6.5) && diem3MonChinh.any((diem) => diem >= 8.0)) {
      return 'Gioi';
    }
    if((tongDiemTB >= 6.5) && diemTBBoMon.values.every((diem) => diem >= 5.0)){
      return 'Kha';
    }
    if((tongDiemTB >= 6.5) && diemTBBoMon.values.every((diem) => diem >= 3.5)){
      return 'Trung Binh';
    }
    return 'Yeu';
  }

  String phanLoaiDiemThiDH(double diem){
    if(diem >= 8){
      return 'Gioi';
    }
    if(diem >= 6.5){
      return 'Kha';
    }
    if(diem >= 5.0){
      return 'Trung Binh';
    }
    return 'Thi Lai =))';
  }

  void printTongKet(){
    print('-' * 40);
    print("Diem tong ket trung binh tung mon:");
    diemTBBoMon.entries.map((entry) => '${entry.key} : ${entry.value.toStringAsFixed(2)}\n').forEach(print);
    print('-' * 40);
    print("Diem Trung BInh Tong: ${tongDiemTB.toStringAsFixed(2)}");
    print("Xep loai hoc luc: ${xepLoaiHocLuc()}");
    print('-' * 40);
    print("Danh gia so bo ket qua thi DH (du kien):");
    print("Diem thi khoi A: ${diemKhoiA.toStringAsFixed(2)} | loai: ${phanLoaiDiemThiDH(diemKhoiA)}");
    print("Diem thi khoi A1: ${diemKhoiA1.toStringAsFixed(2)} | loai: ${phanLoaiDiemThiDH(diemKhoiA1)}");
    print("Diem thi khoi B: ${diemKhoiB.toStringAsFixed(2)} | loai: ${phanLoaiDiemThiDH(diemKhoiB)}");
    print("Diem thi khoi C: ${diemKhoiC.toStringAsFixed(2)} | loai: ${phanLoaiDiemThiDH(diemKhoiC)}");
    print("Diem thi khoi B: ${diemKhoiD.toStringAsFixed(2)} | loai: ${phanLoaiDiemThiDH(diemKhoiD)}");
  }
}
class DiemBoMon {
  final Map<String, DiemKiemTra> _diemKT;
  DiemBoMon(this._diemKT);

  factory DiemBoMon.from(Map<String, dynamic> tatCaDiemKT){
    final result = <String, DiemKiemTra>{};
    for (var diemKT in tatCaDiemKT.entries){
      result[diemKT.key] = DiemKiemTra.from(diemKT.value);
    }
    return DiemBoMon(result);
  }

  double get _tongTuSo => _diemKT.values.map((diemKT) => diemKT.tuSo).reduce((v, e) => v + e);
  double get _tongMauSo => _diemKT.values.map((diemKT) => diemKT.mauso).reduce((v, e) => v + e);
  double get diemTB => _tongTuSo / _tongMauSo;
}
class DiemKiemTra {
  const DiemKiemTra(this._listDiem, this._heSo);
  final List<double> _listDiem;
  final int _heSo;

  factory DiemKiemTra.from(Map<String, dynamic> nhomDiemKT){
    final List<double> listDiem = (nhomDiemKT["list diem"] as List).map((e) => double.parse('$e')).toList();
    final heSo = nhomDiemKT["he so"];

    return DiemKiemTra(listDiem, heSo);
  }

  double get tuSo => _listDiem.reduce((value, element) => value + element) * _heSo;
  double get mauso => _listDiem.length.toDouble() * _heSo;
}
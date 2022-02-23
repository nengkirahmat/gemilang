import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String ganti(String angka) {
    var panjang = angka.length;
    var potong = panjang - 3;
    var newAngka = angka.substring(0, potong);
    newAngka = CurrencyFormat.convertToIdr(int.parse(newAngka), 2);
    return newAngka;
  }
}

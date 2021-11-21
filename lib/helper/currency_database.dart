class CurrencyDataBase {
  static Map<String, String> _currencySympols = {
    'USD': '\$',
    'SYP': '£S ',
    'EUR': '€',
  };

  static List<String> _shortCurrency = [
    'USD',
    'SYP',
    'EUR',
  ];

  static List<String> get worldCurrency {
    return [..._shortCurrency].toList();
  }

  static String worldSympols(String currencyName) {
    return _currencySympols[currencyName]!;
  }
}

// static List<String> _worldCurrency = [
//   'ARS',
//   'AMD',
//   'ANG',
//   'AUD',
//   'BMD',
//   'BRL',
//   'CAD',
//   'CNY',
//   'COP',
//   'DOP',
//   'CHF',
//   'DKK',
//   'EGP',
//   'EUR',
//   'FKP',
//   'GEL',
//   'GIP',
//   'HRK',
//   'ILS',
//   'IMP',
//   'IQD',
//   'IRR',
//   'JOD',
//   'JPY',
//   'KHR',
//   'HKD',
//   'HUF',
//   'KWD',
//   'KYD',
//   'LBP',
//   'LYD',
//   'MNT',
//   'MOP',
//   'MXN',
//   'NZD',
//   'OMR',
//   'PHP',
//   'QAR',
//   'RUB',
//   'RWF',
//   'SAR',
//   'SYP',
//   'USD',
//   'XAF',
//   'XCD',
//   'XPF',
//   'YER',
// ];

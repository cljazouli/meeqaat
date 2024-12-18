// lib/models/prayer_time_model.dart

class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimes.fromMap(Map<String, dynamic> map) {
    return PrayerTimes(
      fajr: map['Fajr'] ?? '',
      dhuhr: map['Dhuhr'] ?? '',
      asr: map['Asr'] ?? '',
      maghrib: map['Maghrib'] ?? '',
      isha: map['Isha'] ?? '',
    );
  }
}

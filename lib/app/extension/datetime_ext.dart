List<String> monthNames = [
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
];

extension DtimeExt on DateTime {
  String get stringify {
    // 16:00 2/16/23
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year.toString().padLeft(2, '0')}';
  }

  String get stringify2 {
    // 23 Oktober 2021
    return '${day.toString().padLeft(2, '0')} ${monthNames[month - 1]} ${year.toString().padLeft(2, '0')}';
  }
}

enum ServiceType {
  deepwash,
  repaint,
  unyellowing,
  sol,
}

String serviceTypeToString(ServiceType serviceType) {
  switch (serviceType) {
    case ServiceType.deepwash:
      return "Deepwash";
    case ServiceType.repaint:
      return "Repaint";
    case ServiceType.unyellowing:
      return "Unyellowing";
    case ServiceType.sol:
      return "Sol";
    default:
      return "";
  }
}

final serviceTypeStr =
    ServiceType.values.map((e) => serviceTypeToString(e)).toList();

ServiceType stringToServiceType(String serviceType) {
  switch (serviceType) {
    case "Deepwash":
      return ServiceType.deepwash;
    case "Repaint":
      return ServiceType.repaint;
    case "Unyellowing":
      return ServiceType.unyellowing;
    case "Sol":
      return ServiceType.sol;
    default:
      return ServiceType.deepwash;
  }
}

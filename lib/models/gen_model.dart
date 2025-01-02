class GenModel {
  String? name;
  String? email;
  String? cutoffTime;
  String? cutoffDate;
  String? turnOnTime;
  String? turnOnDate;
  String? addonid;
  int? fuelLevel;

  // Constructor
  GenModel({
    this.name,
    this.email,
    this.cutoffTime,
    this.cutoffDate,
    this.turnOnTime,
    this.turnOnDate,
    this.fuelLevel,
    this.addonid,
  });

  // Factory constructor to create an instance from JSON
  factory GenModel.fromJson(Map<String, dynamic> json) {
    return GenModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      cutoffTime: json['cutoffTime'] as String?,
      cutoffDate: json['cutoffDate'] as String?,
      turnOnTime: json['turnOnTime'] as String?,
      turnOnDate: json['turnOnDate'] as String?,
      fuelLevel: json['fuelLevel'] as int?,
      addonid: json['addonid'] as String?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cutoffTime': cutoffTime,
      'cutoffDate': cutoffDate,
      'turnOnTime': turnOnTime,
      'turnOnDate': turnOnDate,
      'fuelLevel': fuelLevel,
      'addonid': addonid,
    };
  }

  // Overriding toString for better debugging
  @override
  String toString() {
    return 'GenModel(name: $name, email: $email, cutoffTime: $cutoffTime, cutoffDate: $cutoffDate, turnOnTime: $turnOnTime, turnOnDate: $turnOnDate, fuelLevel: $fuelLevel, addonid: $addonid)';
  }

  // Overriding == and hashCode for better comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GenModel &&
        other.name == name &&
        other.email == email &&
        other.cutoffTime == cutoffTime &&
        other.cutoffDate == cutoffDate &&
        other.turnOnTime == turnOnTime &&
        other.turnOnDate == turnOnDate &&
        other.fuelLevel == fuelLevel &&
        other.addonid == addonid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        cutoffTime.hashCode ^
        cutoffDate.hashCode ^
        turnOnTime.hashCode ^
        turnOnDate.hashCode ^
        fuelLevel.hashCode ^
        addonid.hashCode;
  }
}

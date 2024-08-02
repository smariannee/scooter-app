class ScooterModel {
  final int id;
  final String brand;
  final String model;
  final double autonomy;
  final double weight;

  ScooterModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.autonomy,
    required this.weight,
  });

  factory ScooterModel.fromJson(Map<String, dynamic> json) {
    return ScooterModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      autonomy: json['autonomy'] is double
          ? json['autonomy']
          : double.tryParse(json['autonomy'].toString()) ?? 0.0,
      weight: json['weight'] is double
          ? json['weight']
          : double.tryParse(json['weight'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'autonomy': autonomy,
      'weight': weight,
    };
  }
}

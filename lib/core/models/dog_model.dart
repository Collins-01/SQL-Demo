class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.age,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
    };
  }

  factory Dog.fromJson(Map<String, dynamic> json) => Dog(
        age: json['age'],
        id: json['id'],
        name: json['name'],
      );
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

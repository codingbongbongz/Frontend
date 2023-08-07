class Categorie {
  final int? id;
  final String? name;

  Categorie({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return '''
      id : $id
      name : $name
    ''';
  }
}

/// Tipos de problema urbano que podem ser denunciados.
enum ReportType {
  buraco('Buraco', '🕳️'),
  posteApagado('Poste apagado', '💡'),
  lixo('Lixo acumulado', '🗑️'),
  calcada('Calçada danificada', '🚧'),
  outro('Outro', '📍');

  const ReportType(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// Entidade de domínio: uma denúncia (foto + coordenadas + tipo).
/// Classe pura — não sabe nada de banco de dados nem de Flutter.
class Report {
  const Report({
    this.id,
    required this.type,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.fromBump = false,
  });

  final int? id;
  final ReportType type;
  final String photoPath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  /// true quando a denúncia nasceu de um solavanco detectado pelo acelerômetro.
  final bool fromBump;
}

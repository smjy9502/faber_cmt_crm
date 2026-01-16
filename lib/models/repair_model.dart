class RepairModel {
  final String id; // 문서 ID
  final String userId; // 작성자 UID
  final String title;
  final String description;
  final String? imageUrl; // 사진 첨부 (선택)
  final String status; // '접수대기', '처리중', '완료'
  final DateTime createdAt;

  RepairModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory RepairModel.fromMap(Map<String, dynamic> data, String id) {
    return RepairModel(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      status: data['status'] ?? '접수대기',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
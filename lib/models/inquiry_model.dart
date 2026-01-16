class InquiryModel {
  final String id;
  final String userId;
  final String userEmail; // 목록에 작성자 표시용
  final String title;
  final String content;
  final String? adminReply; // 관리자 답변
  final bool isReplied; // 답변 완료 여부
  final DateTime createdAt;

  InquiryModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.title,
    required this.content,
    this.adminReply,
    this.isReplied = false,
    required this.createdAt,
  });

  factory InquiryModel.fromMap(Map<String, dynamic> data, String id) {
    return InquiryModel(
      id: id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '익명',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      adminReply: data['adminReply'],
      isReplied: data['isReplied'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'title': title,
      'content': content,
      'adminReply': adminReply,
      'isReplied': isReplied,
      'createdAt': createdAt,
    };
  }
}
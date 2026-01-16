import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inquiry_model.dart';
import '../models/news_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/repair_model.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. A/S 접수하기 (Create)
  Future<void> createRepair(RepairModel repair) async {
    // repairs 컬렉션에 문서 생성 (ID를 자동 생성된 걸로 덮어쓰기 위해 set 사용 안함)
    await _db.collection('repairs').doc(repair.id).set(repair.toMap());
  }

  // 2. 내 접수 내역만 가져오기 (Read - Stream)
  // Stream을 쓰면 관리자가 '완료'로 상태를 바꾸자마자 앱에서도 바로 바뀜!
  Stream<List<RepairModel>> getMyRepairs(String userId) {
    return _db
        .collection('repairs')
        .where('userId', isEqualTo: userId) // ★ 핵심: 내 ID랑 같은 것만!
        .orderBy('createdAt', descending: true) // 최신순 정렬
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RepairModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 3. 문의 등록하기
  Future<void> createInquiry(InquiryModel inquiry) async {
    await _db.collection('inquiries').doc(inquiry.id).set(inquiry.toMap());
  }

  // 4. 내 문의 내역 가져오기
  Stream<List<InquiryModel>> getMyInquiries(String userId) {
    return _db
        .collection('inquiries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return InquiryModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }


  // ----------------------------------------
  // 공지사항 관련 (News)
  // ----------------------------------------

  // 5. 공지사항 불러오기 (모든 유저 열람 가능)
  Stream<List<NewsModel>> getAllNews() {
    return _db
        .collection('news')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NewsModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 6. 공지사항 등록하기 (관리자 전용)
  // 추후 이 함수가 실행될 때 Cloud Functions가 트리거되어 푸시 알림을 보내게 됨
  Future<void> createNews(NewsModel news) async {
    await _db.collection('news').doc(news.id).set(news.toMap());
  }

  // ----------------------------------------
  // 쇼핑몰 관련 (Shop)
  // ----------------------------------------

  // 7. 상품 목록 가져오기
  Stream<List<ProductModel>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 8. 주문하기 (결제 내역 저장)
  Future<void> createOrder(OrderModel order) async {
    await _db.collection('orders').doc(order.id).set(order.toMap());
  }

  // (개발용) 더미 데이터 생성 함수 - 잠시 후 사용 예정
  Future<void> addDummyProducts() async {
    final batch = _db.batch();

    final products = [
      {'name': '고급 필터 A형', 'price': 15000, 'desc': '미세먼지 완벽 차단 필터'},
      {'name': '전용 윤활유', 'price': 8000, 'desc': '기계 수명을 늘려주는 오일'},
      {'name': '교체용 벨트', 'price': 22000, 'desc': '튼튼한 내구성의 고무 벨트'},
      {'name': '청소 키트', 'price': 12000, 'desc': '간편한 유지보수를 위한 도구 모음'},
    ];

    for (var p in products) {
      var doc = _db.collection('products').doc();
      batch.set(doc, {
        'name': p['name'],
        'price': p['price'],
        'description': p['desc'],
        'imageUrl': '', // 이미지는 일단 비워둠
      });
    }
    await batch.commit();
  }
}
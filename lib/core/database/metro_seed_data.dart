import '../../features/metro_lines/data/models/metro_line_entity.dart';
import '../../features/metro_lines/data/models/station_entity.dart';
import '../../features/route_planner/data/models/connection_entity.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Metro Lines seed data
///
/// Cairo metro colours match the official line branding:
///   Line 1 – Blue   (#1A5CA8)
///   Line 2 – Red    (#E2231A)
///   Line 3 – Green  (#009A44)
/// ─────────────────────────────────────────────────────────────────────────────
abstract class MetroSeedData {
  // ── Lines ──────────────────────────────────────────────────────────────────

  static const List<MetroLineEntity> lines = [
    MetroLineEntity(
      id: 1,
      nameAr: 'الخط الأول',
      nameEn: 'Line 1',
      color: '#1A5CA8',
    ),
    MetroLineEntity(
      id: 2,
      nameAr: 'الخط الثاني',
      nameEn: 'Line 2',
      color: '#E2231A',
    ),
    MetroLineEntity(
      id: 3,
      nameAr: 'الخط الثالث',
      nameEn: 'Line 3',
      color: '#009A44',
    ),
  ];

  // ── Stations ───────────────────────────────────────────────────────────────
  //
  // IDs are assigned per-line in sequential blocks for clarity:
  //   Line 1 → 101 – 135
  //   Line 2 → 201 – 220
  //   Line 3 → 301 – 334
  //
  // Interchange stations appear ONCE per line they belong to, allowing the
  // routing graph to model transfers correctly.

  static const List<StationEntity> stations = [
    // ── Line 1 (Helwan → New Marg) ───────────────────────────────────────
    StationEntity(id: 101, nameAr: 'حلوان', nameEn: 'Helwan', lat: 29.85055, lng: 31.33398, lineId: 1),
    StationEntity(id: 102, nameAr: 'عين حلوان', nameEn: 'Ain Helwan', lat: 29.86281, lng: 31.32489, lineId: 1),
    StationEntity(id: 103, nameAr: 'جامعة حلوان', nameEn: 'Helwan University', lat: 29.86960, lng: 31.32006, lineId: 1),
    StationEntity(id: 104, nameAr: 'وادي حوف', nameEn: 'Wadi Hof', lat: 29.87923, lng: 31.31354, lineId: 1),
    StationEntity(id: 105, nameAr: 'حدائق حلوان', nameEn: 'Hadayek Helwan', lat: 29.89743, lng: 31.30409, lineId: 1),
    StationEntity(id: 106, nameAr: 'المعصرة', nameEn: 'El-Maasara', lat: 29.90624, lng: 31.29952, lineId: 1),
    StationEntity(id: 107, nameAr: 'طرة الأسمنت', nameEn: 'Tora El-Asmant', lat: 29.92610, lng: 31.28753, lineId: 1),
    StationEntity(id: 108, nameAr: 'كوزيكا', nameEn: 'Kozzika', lat: 29.93644, lng: 31.28178, lineId: 1),
    StationEntity(id: 109, nameAr: 'طرة البلد', nameEn: 'Tora El-Balad', lat: 29.94693, lng: 31.27297, lineId: 1),
    StationEntity(id: 110, nameAr: 'ثكنات المعادي', nameEn: 'Sakanat El Maadi', lat: 29.95330, lng: 31.26297, lineId: 1),
    StationEntity(id: 111, nameAr: 'المعادي', nameEn: 'El Maadi', lat: 29.96042, lng: 31.25770, lineId: 1),
    StationEntity(id: 112, nameAr: 'حدائق المعادي', nameEn: 'Hadayek El Maadi', lat: 29.97040, lng: 31.25051, lineId: 1),
    StationEntity(id: 113, nameAr: 'دار السلام', nameEn: 'Dar El Salam', lat: 29.98224, lng: 31.24224, lineId: 1),
    StationEntity(id: 114, nameAr: 'الزهراء', nameEn: 'El Zahraa', lat: 29.99559, lng: 31.23114, lineId: 1),
    StationEntity(id: 115, nameAr: 'مار جرجس', nameEn: 'Mar Girgis', lat: 30.00716, lng: 31.22983, lineId: 1),
    StationEntity(id: 116, nameAr: 'الملك الصالح', nameEn: 'El Malek El Saleh', lat: 30.01785, lng: 31.23103, lineId: 1),
    StationEntity(id: 117, nameAr: 'السيدة زينب', nameEn: 'El Sayeda Zeinab', lat: 30.02943, lng: 31.23542, lineId: 1),
    StationEntity(id: 118, nameAr: 'سعد زغلول', nameEn: 'Saad Zaghloul', lat: 30.03716, lng: 31.23839, lineId: 1),
    StationEntity(id: 119, nameAr: 'السادات', nameEn: 'Sadat', lat: 30.04375, lng: 31.23585, lineId: 1, isInterchange: true),
    StationEntity(id: 120, nameAr: 'جمال عبد الناصر', nameEn: 'Nasser', lat: 30.05276, lng: 31.24082, lineId: 1, isInterchange: true),
    StationEntity(id: 121, nameAr: 'عرابي', nameEn: 'Orabi', lat: 30.05683, lng: 31.24208, lineId: 1),
    StationEntity(id: 122, nameAr: 'الشهداء', nameEn: 'El Shohadaa', lat: 30.06147, lng: 31.24617, lineId: 1, isInterchange: true),
    StationEntity(id: 123, nameAr: 'غمرة', nameEn: 'Ghamra', lat: 30.06918, lng: 31.26461, lineId: 1),
    StationEntity(id: 124, nameAr: 'الدمرداش', nameEn: 'El Demerdash', lat: 30.07735, lng: 31.27783, lineId: 1),
    StationEntity(id: 125, nameAr: 'منشية الصدر', nameEn: 'Manshiet El Sadr', lat: 30.08212, lng: 31.28751, lineId: 1),
    StationEntity(id: 126, nameAr: 'كوبري القبة', nameEn: 'Kobry El Qobba', lat: 30.08732, lng: 31.29409, lineId: 1),
    StationEntity(id: 127, nameAr: 'حمامات القبة', nameEn: 'Hamamat El Qobba', lat: 30.09133, lng: 31.29891, lineId: 1),
    StationEntity(id: 128, nameAr: 'سراي القبة', nameEn: 'Saray El Qobba', lat: 30.09779, lng: 31.30454, lineId: 1),
    StationEntity(id: 129, nameAr: 'حدائق الزيتون', nameEn: 'Hadayek El Zaitoun', lat: 30.10602, lng: 31.31047, lineId: 1),
    StationEntity(id: 130, nameAr: 'حلمية الزيتون', nameEn: 'Helmeyet El Zeitoun', lat: 30.11399, lng: 31.31413, lineId: 1),
    StationEntity(id: 131, nameAr: 'المطرية', nameEn: 'El Matariya', lat: 30.12148, lng: 31.31370, lineId: 1),
    StationEntity(id: 132, nameAr: 'عين شمس', nameEn: 'Ain Shams', lat: 30.13119, lng: 31.31907, lineId: 1),
    StationEntity(id: 133, nameAr: 'عزبة النخل', nameEn: 'Ezbet El-Nakhl', lat: 30.13948, lng: 31.32441, lineId: 1),
    StationEntity(id: 134, nameAr: 'المرج', nameEn: 'El Marg', lat: 30.16396, lng: 31.33832, lineId: 1),
    StationEntity(id: 135, nameAr: 'المرج الجديدة', nameEn: 'New Marg', lat: 30.16380, lng: 31.33834, lineId: 1),

    // ── Line 2 (Shubra El Kheima → El Mounib) ───────────────────────────────
    StationEntity(id: 201, nameAr: 'شبرا الخيمة', nameEn: 'Shubra El Kheima', lat: 30.12257, lng: 31.24453, lineId: 2),
    StationEntity(id: 202, nameAr: 'كلية الزراعة', nameEn: 'Koliet El Zeraa', lat: 30.11386, lng: 31.24865, lineId: 2),
    StationEntity(id: 203, nameAr: 'المظلات', nameEn: 'Mezallat', lat: 30.10428, lng: 31.24562, lineId: 2),
    StationEntity(id: 204, nameAr: 'الخلفاوي', nameEn: 'Khalafawy', lat: 30.09740, lng: 31.24547, lineId: 2),
    StationEntity(id: 205, nameAr: 'سانت تريزا', nameEn: 'St. Teresa', lat: 30.08812, lng: 31.24548, lineId: 2),
    StationEntity(id: 206, nameAr: 'روض الفرج', nameEn: 'Rod El Farag', lat: 30.08075, lng: 31.24540, lineId: 2),
    StationEntity(id: 207, nameAr: 'مسرة', nameEn: 'Masarra', lat: 30.07105, lng: 31.24508, lineId: 2),
    StationEntity(id: 208, nameAr: 'الشهداء', nameEn: 'El Shohadaa', lat: 30.06147, lng: 31.24617, lineId: 2, isInterchange: true),
    StationEntity(id: 209, nameAr: 'العتبة', nameEn: 'Attaba', lat: 30.05252, lng: 31.24680, lineId: 2, isInterchange: true),
    StationEntity(id: 210, nameAr: 'محمد نجيب', nameEn: 'Naguib', lat: 30.04549, lng: 31.24414, lineId: 2),
    StationEntity(id: 211, nameAr: 'السادات', nameEn: 'Sadat', lat: 30.04375, lng: 31.23585, lineId: 2, isInterchange: true),
    StationEntity(id: 212, nameAr: 'الأوبرا', nameEn: 'Opera', lat: 30.04211, lng: 31.22495, lineId: 2),
    StationEntity(id: 213, nameAr: 'الدقي', nameEn: 'Dokki', lat: 30.03860, lng: 31.21218, lineId: 2),
    StationEntity(id: 214, nameAr: 'البحوث', nameEn: 'El Bohoth', lat: 30.03596, lng: 31.20016, lineId: 2),
    StationEntity(id: 215, nameAr: 'جامعة القاهرة', nameEn: 'Cairo University', lat: 30.02616, lng: 31.20114, lineId: 2, isInterchange: true),
    StationEntity(id: 216, nameAr: 'فيصل', nameEn: 'Faisal', lat: 30.01723, lng: 31.20397, lineId: 2),
    StationEntity(id: 217, nameAr: 'الجيزة', nameEn: 'Giza', lat: 30.01073, lng: 31.20708, lineId: 2),
    StationEntity(id: 218, nameAr: 'أم المصريين', nameEn: 'Omm El-Masryeen', lat: 30.00577, lng: 31.20810, lineId: 2),
    StationEntity(id: 219, nameAr: 'ساقية مكي', nameEn: 'Sakiat Mekky', lat: 29.99561, lng: 31.20868, lineId: 2),
    StationEntity(id: 220, nameAr: 'المنيب', nameEn: 'El Mounib', lat: 29.98127, lng: 31.21232, lineId: 2),

    // ── Line 3 (Adly Mansour → Rod El Farag Corridor / Cairo University) ───
    StationEntity(id: 301, nameAr: 'عدلي منصور', nameEn: 'Adly Mansour', lat: 30.14717, lng: 31.42133, lineId: 3),
    StationEntity(id: 302, nameAr: 'الهايكستب', nameEn: 'El Haykestep', lat: 30.14398, lng: 31.40470, lineId: 3),
    StationEntity(id: 303, nameAr: 'عمر بن الخطاب', nameEn: 'Omar Ibn El Khattab', lat: 30.14020, lng: 31.39287, lineId: 3),
    StationEntity(id: 304, nameAr: 'قباء', nameEn: 'Qobaa', lat: 30.08865, lng: 31.29393, lineId: 3),
    StationEntity(id: 305, nameAr: 'هشام بركات', nameEn: 'Hesham Barakat', lat: 30.13103, lng: 31.37294, lineId: 3),
    StationEntity(id: 306, nameAr: 'النزهة', nameEn: 'El Nozha', lat: 30.12815, lng: 31.36016, lineId: 3),
    StationEntity(id: 307, nameAr: 'نادي الشمس', nameEn: 'Nadi El Shams', lat: 30.12598, lng: 31.34879, lineId: 3),
    StationEntity(id: 308, nameAr: 'ألف مسكن', nameEn: 'Alf Maskan', lat: 30.11918, lng: 31.34017, lineId: 3),
    StationEntity(id: 309, nameAr: 'هيليوبوليس', nameEn: 'Heliopolis', lat: 30.10855, lng: 31.33828, lineId: 3),
    StationEntity(id: 310, nameAr: 'هارون', nameEn: 'Haroun', lat: 30.10154, lng: 31.33293, lineId: 3),
    StationEntity(id: 311, nameAr: 'الأهرام', nameEn: 'Al Ahram', lat: 30.09185, lng: 31.32634, lineId: 3),
    StationEntity(id: 312, nameAr: 'كلية البنات', nameEn: 'Kolleyet El Banat', lat: 30.08358, lng: 31.32883, lineId: 3),
    StationEntity(id: 313, nameAr: 'الاستاد', nameEn: 'Stadium', lat: 30.07293, lng: 31.31706, lineId: 3),
    StationEntity(id: 314, nameAr: 'أرض المعارض', nameEn: 'Fair Zone', lat: 30.07392, lng: 31.30147, lineId: 3),
    StationEntity(id: 315, nameAr: 'العباسية', nameEn: 'Abbassiya', lat: 30.07213, lng: 31.28333, lineId: 3),
    StationEntity(id: 316, nameAr: 'عبده باشا', nameEn: 'Abdou Pasha', lat: 30.06500, lng: 31.27474, lineId: 3),
    StationEntity(id: 317, nameAr: 'الجيش', nameEn: 'El Geish', lat: 30.06192, lng: 31.26686, lineId: 3),
    StationEntity(id: 318, nameAr: 'باب الشعرية', nameEn: 'Bab El Shaaria', lat: 30.05423, lng: 31.25588, lineId: 3),
    StationEntity(id: 319, nameAr: 'العتبة', nameEn: 'Attaba', lat: 30.05252, lng: 31.24680, lineId: 3, isInterchange: true),
    StationEntity(id: 320, nameAr: 'جمال عبد الناصر', nameEn: 'Nasser', lat: 30.05276, lng: 31.24082, lineId: 3, isInterchange: true),
    StationEntity(id: 321, nameAr: 'ماسبيرو', nameEn: 'Maspero', lat: 30.05581, lng: 31.23207, lineId: 3),
    StationEntity(id: 322, nameAr: 'صفاء حجازي', nameEn: 'Safaa Hegazy', lat: 30.06261, lng: 31.22260, lineId: 3),
    StationEntity(id: 323, nameAr: 'الكيت كات', nameEn: 'Kit Kat', lat: 30.06672, lng: 31.21301, lineId: 3),

    // Branch 3A (to Rod El Farag Corridor)
    StationEntity(id: 324, nameAr: 'السودان', nameEn: 'Sudan', lat: 30.07013, lng: 31.20446, lineId: 3),
    StationEntity(id: 325, nameAr: 'إمبابة', nameEn: 'Imbaba', lat: 30.07602, lng: 31.20746, lineId: 3),
    StationEntity(id: 326, nameAr: 'البوهي', nameEn: 'El-Bohy', lat: 30.08451, lng: 31.21128, lineId: 3),
    StationEntity(id: 327, nameAr: 'القومية', nameEn: 'El Qawmia', lat: 30.09329, lng: 31.20914, lineId: 3),
    StationEntity(id: 328, nameAr: 'الطريق الدائري', nameEn: 'Ring Road', lat: 30.09656, lng: 31.19946, lineId: 3),
    StationEntity(id: 329, nameAr: 'محور روض الفرج', nameEn: 'Rod El Farag Corridor', lat: 30.10207, lng: 31.18439, lineId: 3),

    // Branch 3B (to Cairo University)
    StationEntity(id: 330, nameAr: 'التوفيقية', nameEn: 'Tawfikia', lat: 30.06508, lng: 31.20239, lineId: 3),
    StationEntity(id: 331, nameAr: 'وادي النيل', nameEn: 'Wadi El Nile', lat: 30.05851, lng: 31.20102, lineId: 3),
    StationEntity(id: 332, nameAr: 'جامعة الدول', nameEn: 'Gamat El Dowal', lat: 30.05029, lng: 31.19896, lineId: 3),
    StationEntity(id: 333, nameAr: 'بولاق الدكرور', nameEn: 'Boulak El Dakrour', lat: 30.03772, lng: 31.19556, lineId: 3),
    StationEntity(id: 334, nameAr: 'جامعة القاهرة', nameEn: 'Cairo University', lat: 30.02616, lng: 31.20114, lineId: 3, isInterchange: true),
  ];

  // ── Connections ────────────────────────────────────────────────────────────
  //
  // Each connection is BIDIRECTIONAL: we insert both directions so the graph
  // adjacency list works for both BFS and Dijkstra without extra logic.
  // Default travel_time is 2 minutes per stop (approximate).
  //
  // Interchange connections (cross-line transfers) are added separately with
  // a travel_time of 5 minutes to represent the walking penalty.

  static List<ConnectionEntity> get connections {
    const int travelTime = 2; // minutes per stop
    const int transferTime = 5; // minutes for line change

    final List<ConnectionEntity> edges = [];

    void addBidirectional({
      required int from,
      required int to,
      required int lineId,
      int time = travelTime,
    }) {
      edges.add(ConnectionEntity(
        fromStationId: from,
        toStationId: to,
        lineId: lineId,
        travelTime: time,
      ));
      edges.add(ConnectionEntity(
        fromStationId: to,
        toStationId: from,
        lineId: lineId,
        travelTime: time,
      ));
    }

    // Line 1 connections (sequential 101 to 135)
    final line1 = List.generate(35, (index) => 101 + index);
    for (int i = 0; i < line1.length - 1; i++) {
      addBidirectional(from: line1[i], to: line1[i + 1], lineId: 1);
    }

    // Line 2 connections (sequential 201 to 220)
    final line2 = List.generate(20, (index) => 201 + index);
    for (int i = 0; i < line2.length - 1; i++) {
      addBidirectional(from: line2[i], to: line2[i + 1], lineId: 2);
    }

    // Line 3 common segment (sequential 301 to 323)
    final line3Common = List.generate(23, (index) => 301 + index);
    for (int i = 0; i < line3Common.length - 1; i++) {
      addBidirectional(from: line3Common[i], to: line3Common[i + 1], lineId: 3);
    }

    // Line 3 Branch 3A (Kit Kat to Rod El Farag Corridor)
    final line3BranchA = [323, 324, 325, 326, 327, 328, 329];
    for (int i = 0; i < line3BranchA.length - 1; i++) {
      addBidirectional(from: line3BranchA[i], to: line3BranchA[i + 1], lineId: 3);
    }

    // Line 3 Branch 3B (Kit Kat to Cairo University)
    final line3BranchB = [323, 330, 331, 332, 333, 334];
    for (int i = 0; i < line3BranchB.length - 1; i++) {
      addBidirectional(from: line3BranchB[i], to: line3BranchB[i + 1], lineId: 3);
    }

    // ── Interchange / Transfer edges ─────────────────────────────────────────
    // Sadat: Line 1 (119) ↔ Line 2 (211)
    addBidirectional(from: 119, to: 211, lineId: 1, time: transferTime);

    // El Shohadaa: Line 1 (122) ↔ Line 2 (208)
    addBidirectional(from: 122, to: 208, lineId: 1, time: transferTime);

    // Attaba: Line 2 (209) ↔ Line 3 (319)
    addBidirectional(from: 209, to: 319, lineId: 2, time: transferTime);

    // Nasser: Line 1 (120) ↔ Line 3 (320)
    addBidirectional(from: 120, to: 320, lineId: 1, time: transferTime);

    // Cairo University: Line 2 (215) ↔ Line 3 (334)
    addBidirectional(from: 215, to: 334, lineId: 2, time: transferTime);

    return edges;
  }
}

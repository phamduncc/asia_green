import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../models/challenge.dart';
import '../models/progress.dart';
import '../models/game_score.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('asia_green.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Lessons table
    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        imagePath TEXT,
        audioPath TEXT,
        videoPath TEXT,
        orderIndex INTEGER NOT NULL
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lessonId INTEGER NOT NULL,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswer INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY (lessonId) REFERENCES lessons (id)
      )
    ''');

    // Challenges table
    await db.execute('''
      CREATE TABLE challenges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        points INTEGER NOT NULL,
        icon TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Progress table
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lessonId INTEGER NOT NULL,
        score INTEGER NOT NULL,
        completedAt TEXT NOT NULL,
        FOREIGN KEY (lessonId) REFERENCES lessons (id)
      )
    ''');

    // Game scores table
    await db.execute('''
      CREATE TABLE game_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameName TEXT NOT NULL,
        score INTEGER NOT NULL,
        playedAt TEXT NOT NULL
      )
    ''');

    // Insert seed data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Seed Lessons
    await db.insert('lessons', {
      'title': 'Ô nhiễm nước & Xử lý nước thải',
      'content': '''Nước là nguồn tài nguyên quý giá nhất của con người. Tuy nhiên, ô nhiễm nước đang trở thành vấn đề nghiêm trọng toàn cầu.

**Nguyên nhân chính:**
• Nước thải công nghiệp chưa qua xử lý
• Rác thải sinh hoạt đổ ra sông, hồ
• Sử dụng hóa chất trong nông nghiệp
• Rò rỉ dầu mỏ và hóa chất độc hại

**Hậu quả:**
• Nguồn nước uống bị ô nhiễm
• Hệ sinh thái dưới nước bị phá hủy
• Ảnh hưởng đến sức khỏe con người
• Thiệt hại kinh tế lớn

**Giải pháp:**
• Xây dựng hệ thống xử lý nước thải hiện đại
• Không xả rác xuống nguồn nước
• Sử dụng hóa chất thân thiện môi trường
• Tái chế và tái sử dụng nước''',
      'category': 'water',
      'imagePath': 'assets/images/water_pollution.png',
      'orderIndex': 1,
    });

    await db.insert('lessons', {
      'title': 'Tác hại của rác thải nhựa',
      'content': '''Rác thải nhựa là một trong những vấn đề môi trường lớn nhất hiện nay. Mỗi năm có hàng triệu tấn nhựa thải ra đại dương.

**Tác hại:**
• Phân hủy mất hàng trăm năm
• Gây hại cho sinh vật biển
• Phát sinh độc tố khi phân hủy
• Ô nhiễm đất và nước

**Vi nhựa - mối đe dọa vô hình:**
Vi nhựa là những mảnh nhựa nhỏ hơn 5mm, có thể xâm nhập vào cơ thể con người qua thức ăn và nước uống.

**Giải pháp:**
• Giảm sử dụng nhựa dùng một lần
• Tái chế nhựa đúng cách
• Sử dụng túi vải, chai lọ tái sử dụng
• Tham gia các chiến dịch dọn rác''',
      'category': 'waste',
      'imagePath': 'assets/images/plastic_waste.png',
      'orderIndex': 2,
    });

    await db.insert('lessons', {
      'title': 'Tiết kiệm năng lượng',
      'content': '''Tiết kiệm năng lượng không chỉ giúp giảm chi phí mà còn bảo vệ môi trường và chống biến đổi khí hậu.

**Tại sao cần tiết kiệm năng lượng?**
• Giảm phát thải khí nhà kính
• Bảo tồn tài nguyên thiên nhiên
• Tiết kiệm chi phí sinh hoạt
• Giảm ô nhiễm không khí

**Cách tiết kiệm năng lượng:**

Tại nhà:
• Tắt đèn khi không sử dụng
• Rút phích cắm thiết bị điện
• Sử dụng bóng đèn LED
• Điều hòa ở nhiệt độ hợp lý (25-26°C)

Tại công ty:
• Tối ưu hóa hệ thống chiếu sáng
• Bảo trì máy móc định kỳ
• Sử dụng năng lượng tái tạo
• Đào tạo nhân viên tiết kiệm điện''',
      'category': 'energy',
      'imagePath': 'assets/images/energy_save.png',
      'orderIndex': 3,
    });

    await db.insert('lessons', {
      'title': 'Biến đổi khí hậu',
      'content': '''Biến đổi khí hậu là thách thức lớn nhất mà nhân loại đang phải đối mặt.

**Nguyên nhân:**
• Đốt nhiên liệu hóa thạch (than, dầu, khí đốt)
• Phá rừng và mất rừng
• Hoạt động nông nghiệp thải khí nhà kính
• Sản xuất công nghiệp

**Hậu quả:**
• Nhiệt độ trái đất tăng
• Băng tan, mực nước biển dâng
• Thiên tai cực đoan tăng
• Hạn hán, lũ lụt nghiêm trọng

**Hành động cá nhân:**
• Giảm tiêu thụ năng lượng
• Đi xe đạp, giao thông công cộng
• Ăn nhiều thực phẩm thực vật
• Trồng cây và bảo vệ rừng
• Giảm thiểu rác thải''',
      'category': 'climate',
      'imagePath': 'assets/images/climate_change.png',
      'orderIndex': 4,
    });

    await db.insert('lessons', {
      'title': 'Cây xanh và Hệ sinh thái',
      'content': '''Cây xanh và rừng là "lá phổi" của Trái Đất, đóng vai trò quan trọng trong việc duy trì sự sống.

**Vai trò của cây xanh:**
• Sản xuất oxy, hấp thụ CO2
• Điều hòa nhiệt độ, độ ẩm
• Lọc không khí, giảm ô nhiễm
• Bảo vệ đất, chống xói mòn
• Cung cấp nơi sống cho động vật

**Hệ sinh thái:**
Hệ sinh thái là mạng lưới sự sống phức tạp, mỗi loài đều có vai trò riêng. Khi một loài biến mất, toàn bộ hệ thống bị ảnh hưởng.

**Bảo vệ đa dạng sinh học:**
• Không săn bắt, buôn bán động vật hoang dã
• Trồng cây bản địa
• Bảo vệ các khu bảo tồn
• Giảm sử dụng hóa chất độc hại
• Tham gia các chương trình bảo vệ môi trường''',
      'category': 'nature',
      'imagePath': 'assets/images/green_nature.png',
      'orderIndex': 5,
    });

    // Additional Water lessons
    await db.insert('lessons', {
      'title': 'Tiết kiệm nước hàng ngày',
      'content': '''Nước ngọt chỉ chiếm 2.5% tổng lượng nước trên Trái Đất. Tiết kiệm nước là trách nhiệm của mỗi người.

**Tại sao phải tiết kiệm nước?**
• Nguồn nước ngọt hạn chế
• Dân số tăng, nhu cầu nước tăng
• Biến đổi khí hậu làm khan hiếm nước
• Tiết kiệm chi phí sinh hoạt

**Cách tiết kiệm nước:**

Trong nhà tắm:
• Tắm vòi hoa sen thay vì bồn
• Giảm thời gian tắm (5-7 phút)
• Sửa vòi nước rò rỉ ngay
• Đóng vòi khi xà phòng

Trong bếp:
• Rửa rau củ trong chậu, không dưới vòi
• Sử dụng máy rửa bát đầy tải
• Tái sử dụng nước vo gạo
• Thu nước mưa để tưới cây''',
      'category': 'water',
      'imagePath': 'assets/images/save_water.png',
      'orderIndex': 6,
    });

    await db.insert('lessons', {
      'title': 'Ô nhiễm nguồn nước ngầm',
      'content': '''Nước ngầm là nguồn nước uống quan trọng cho hàng tỷ người, nhưng đang bị đe dọa nghiêm trọng.

**Nguyên nhân ô nhiễm:**
• Rò rỉ bể phốt, hầm cầu
• Hóa chất nông nghiệp thấm xuống
• Bãi rác không được xử lý đúng cách
• Chôn lấp chất thải công nghiệp
• Khai thác quá mức làm nhiễm mặn

**Hậu quả:**
• Nước uống không an toàn
• Gây bệnh cho con người (tiêu chảy, nhiễm độc)
• Chi phí xử lý nước tăng cao
• Khó khăn trong cung cấp nước sạch

**Bảo vệ nước ngầm:**
• Xây dựng bể phốt đúng quy cách
• Giảm sử dụng hóa chất
• Xử lý rác thải đúng cách
• Không chôn lấp chất thải nguy hại
• Trồng cây xanh để bảo vệ tầng nước''',
      'category': 'water',
      'imagePath': 'assets/images/groundwater.png',
      'orderIndex': 7,
    });

    // Additional Waste lessons
    await db.insert('lessons', {
      'title': 'Phân loại và tái chế rác thải',
      'content': '''Phân loại rác là bước đầu tiên để giảm thiểu ô nhiễm và tối ưu hóa tái chế.

**Các loại rác:**

♻️ Rác tái chế:
• Giấy, bìa carton
• Chai nhựa, lon kim loại
• Chai lọ thủy tinh
• Đồ điện tử cũ

🍃 Rác hữu cơ:
• Thức ăn thừa, vỏ trái cây
• Lá cây, cành cây
• Có thể làm phân compost

⚠️ Rác nguy hại:
• Pin, bóng đèn
• Thuốc trừ sâu, hóa chất
• Dầu nhớt, sơn
• Cần xử lý đặc biệt

🗑️ Rác thông thường:
• Giấy bẩn, khăn giấy đã dùng
• Bao bì không tái chế được
• Đưa ra bãi rác tập trung''',
      'category': 'waste',
      'imagePath': 'assets/images/recycle.png',
      'orderIndex': 8,
    });

    await db.insert('lessons', {
      'title': 'Sống xanh - Zero Waste',
      'content': '''Phong trào Zero Waste (không rác thải) là lối sống giảm thiểu tối đa rác thải ra môi trường.

**Nguyên tắc 5R:**

1. Refuse (Từ chối):
• Từ chối túi ni lông
• Không nhận quà tặng không cần thiết
• Từ chối ống hút, đồ dùng nhựa một lần

2. Reduce (Giảm thiểu):
• Mua chỉ những gì cần thiết
• Chọn sản phẩm ít bao bì
• Giảm tiêu dùng quá mức

3. Reuse (Tái sử dụng):
• Dùng túi vải, hộp cơm
• Sửa chữa thay vì vứt bỏ
• Cho tặng đồ cũ còn dùng được

4. Recycle (Tái chế):
• Phân loại rác đúng cách
• Tái chế giấy, nhựa, kim loại

5. Rot (Ủ phân):
• Ủ rác hữu cơ thành phân bón
• Tạo compost cho cây trồng''',
      'category': 'waste',
      'imagePath': 'assets/images/zero_waste.png',
      'orderIndex': 9,
    });

    // Additional Energy lessons
    await db.insert('lessons', {
      'title': 'Năng lượng tái tạo',
      'content': '''Năng lượng tái tạo là giải pháp bền vững thay thế nhiên liệu hóa thạch.

**Các loại năng lượng tái tạo:**

☀️ Năng lượng mặt trời:
• Tấm pin mặt trời
• Sạch, vô tận
• Chi phí ban đầu cao, tiết kiệm lâu dài

💨 Năng lượng gió:
• Tuabin gió
• Hiệu quả ở vùng gió mạnh
• Không gây ô nhiễm

💧 Năng lượng thủy điện:
• Từ dòng chảy sông, đập
• Ổn định, công suất lớn
• Cần đánh giá tác động môi trường

🌊 Năng lượng sóng biển:
• Công nghệ đang phát triển
• Tiềm năng lớn ở Việt Nam

**Lợi ích:**
• Giảm phát thải khí nhà kính
• Không cạn kiệt
• Tạo việc làm xanh
• Độc lập năng lượng''',
      'category': 'energy',
      'imagePath': 'assets/images/renewable.png',
      'orderIndex': 10,
    });

    await db.insert('lessons', {
      'title': 'Hiệu quả năng lượng tòa nhà',
      'content': '''Tòa nhà tiêu thụ 40% năng lượng toàn cầu. Thiết kế và vận hành hiệu quả có thể tiết kiệm đáng kể.

**Thiết kế tòa nhà xanh:**

Về kiến trúc:
• Định hướng tòa nhà hợp lý
• Cửa sổ lớn tận dụng ánh sáng tự nhiên
• Mái che, mái xanh chống nóng
• Cách nhiệt tường, mái tốt

Hệ thống điện:
• Đèn LED, cảm biến chuyển động
• Điều hòa inverter hiệu suất cao
• Thiết bị tiết kiệm năng lượng (Energy Star)
• Hệ thống quản lý tòa nhà thông minh (BMS)

Năng lượng tái tạo:
• Lắp đặt pin mặt trời
• Sử dụng máy nước nóng năng lượng mặt trời
• Thu năng lượng gió nếu có điều kiện

**Chứng nhận xanh:**
• LEED (Hệ thống đánh giá tòa nhà xanh)
• LOTUS (Tiêu chuẩn Việt Nam)
• Tiết kiệm 20-50% năng lượng''',
      'category': 'energy',
      'imagePath': 'assets/images/green_building.png',
      'orderIndex': 11,
    });

    // Additional Climate lessons
    await db.insert('lessons', {
      'title': 'Khí nhà kính và Hiệu ứng nhà kính',
      'content': '''Hiệu ứng nhà kính là hiện tượng tự nhiên, nhưng hoạt động con người đang làm nó quá mức.

**Khí nhà kính chính:**

CO2 (Carbon dioxide):
• Từ đốt nhiên liệu hóa thạch
• Phá rừng giảm hấp thụ CO2
• Chiếm 76% khí nhà kính

CH4 (Methane):
• Từ chăn nuôi (bò, trâu)
• Ruộng lúa nước
• Bãi rác
• Mạnh gấp 25 lần CO2

N2O (Nitrous oxide):
• Phân bón hóa học
• Công nghiệp
• Mạnh gấp 298 lần CO2

**Hiệu ứng nhà kính:**
Khí nhà kính giữ nhiệt như mái kính, làm Trái Đất ấm lên. Khi quá nhiều, nhiệt độ tăng nguy hiểm.

**Giảm phát thải:**
• Tiết kiệm năng lượng
• Sử dụng năng lượng tái tạo
• Ăn ít thịt, nhiều thực vật
• Trồng cây, bảo vệ rừng''',
      'category': 'climate',
      'imagePath': 'assets/images/greenhouse.png',
      'orderIndex': 12,
    });

    await db.insert('lessons', {
      'title': 'Thích ứng với biến đổi khí hậu',
      'content': '''Trong khi giảm phát thải, chúng ta cũng cần thích ứng với biến đổi khí hậu đã xảy ra.

**Tác động đang diễn ra:**

Về nước:
• Lũ lụt nghiêm trọng hơn
• Hạn hán kéo dài
• Mực nước biển dâng
• Xâm nhập mặn

Về nông nghiệp:
• Mùa màng thất thu
• Dịch bệnh cây trồng, vật nuôi
• Thay đổi lịch vụ mùa

Về sức khỏe:
• Nắng nóng gay gắt
• Dịch bệnh lây lan
• Thiếu nước sạch

**Giải pháp thích ứng:**

Cộng đồng:
• Xây dựng hệ thống tưới tiết kiệm nước
• Trồng cây chống hạn, chịu mặn
• Đê điều chống lũ, sóng biển
• Hệ thống cảnh báo sớm thiên tai

Cá nhân:
• Dự trữ nước, lương thực
• Bảo hiểm rủi ro thiên tai
• Nâng cao nhà ở vùng ngập lụt
• Học kỹ năng sơ cứu, ứng phó''',
      'category': 'climate',
      'imagePath': 'assets/images/adaptation.png',
      'orderIndex': 13,
    });

    // Additional Nature lessons
    await db.insert('lessons', {
      'title': 'Đa dạng sinh học',
      'content': '''Đa dạng sinh học là sự phong phú của các loài động thực vật trên Trái Đất.

**Tầm quan trọng:**
• Cung cấp thức ăn, thuốc men
• Duy trì hệ sinh thái ổn định
• Điều hòa khí hậu
• Giá trị văn hóa, tinh thần
• Du lịch sinh thái

**Nguy cơ tuyệt chủng:**

Nguyên nhân:
• Mất môi trường sống (phá rừng)
• Săn bắt, buôn bán bất hợp pháp
• Ô nhiễm môi trường
• Biến đổi khí hậu
• Loài ngoại lai xâm lấn

Con số đáng báo động:
• 1 triệu loài có nguy cơ tuyệt chủng
• 75% diện tích đất bị suy thoái
• 66% đại dương bị tác động nghiêm trọng

**Bảo vệ đa dạng sinh học:**
• Thành lập khu bảo tồn
• Chống săn bắt trái phép
• Phục hồi môi trường sống
• Nhân giống loài quý hiếm
• Giáo dục cộng đồng''',
      'category': 'nature',
      'imagePath': 'assets/images/biodiversity.png',
      'orderIndex': 14,
    });

    await db.insert('lessons', {
      'title': 'Bảo vệ rừng và trồng rừng',
      'content': '''Rừng là hệ sinh thái quan trọng nhất trên cạn, nhưng đang bị phá hủy với tốc độ báo động.

**Vai trò của rừng:**

Với khí hậu:
• Hấp thụ CO2, giảm biến đổi khí hậu
• Điều hòa nhiệt độ, độ ẩm
• Tạo mưa

Với môi trường:
• Chống xói mòn đất
• Bảo vệ nguồn nước
• Lọc không khí
• Giảm thiên tai

Với con người:
• Cung cấp gỗ, lâm sản
• Nguồn thuốc quý
• Du lịch sinh thái
• Là nhà của 80% loài trên cạn

**Thực trạng:**
• 10 triệu ha rừng mất mỗi năm (bằng diện tích Hàn Quốc)
• Amazon - "lá phổi xanh" đang bị phá hủy
• Việt Nam: độ che phủ 42%, cần tăng lên 45%

**Hành động:**
• Không sử dụng gỗ lậu
• Trồng cây gây rừng
• Tham gia các chương trình tình nguyện
• Giảm tiêu thụ giấy
• Ủng hộ các tổ chức bảo vệ rừng''',
      'category': 'nature',
      'imagePath': 'assets/images/forest.png',
      'orderIndex': 15,
    });

    // Seed Questions for Lesson 1
    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Nguyên nhân chính gây ô nhiễm nước là gì?',
      'options': 'Nước mưa|||Nước thải công nghiệp chưa qua xử lý|||Nước biển|||Nước ngầm',
      'correctAnswer': 1,
      'explanation': 'Nước thải công nghiệp chưa qua xử lý là một trong những nguyên nhân chính gây ô nhiễm nguồn nước.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Ô nhiễm nước ảnh hưởng đến điều gì?',
      'options': 'Chỉ con người|||Chỉ động vật|||Toàn bộ hệ sinh thái|||Không ảnh hưởng gì',
      'correctAnswer': 2,
      'explanation': 'Ô nhiễm nước ảnh hưởng đến toàn bộ hệ sinh thái, từ con người đến động thực vật.',
    });

    // Seed Questions for Lesson 2
    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Nhựa mất bao lâu để phân hủy hoàn toàn?',
      'options': '1-2 năm|||10-20 năm|||50-100 năm|||Hàng trăm năm',
      'correctAnswer': 3,
      'explanation': 'Nhựa có thể mất hàng trăm năm mới phân hủy hoàn toàn, gây ô nhiễm môi trường lâu dài.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Giải pháp nào giúp giảm rác thải nhựa?',
      'options': 'Vứt nhựa bừa bãi|||Sử dụng túi vải tái sử dụng|||Đốt nhựa|||Chôn nhựa',
      'correctAnswer': 1,
      'explanation': 'Sử dụng túi vải và các sản phẩm tái sử dụng là giải pháp hiệu quả để giảm rác thải nhựa.',
    });

    // Seed Questions for Lesson 3
    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Nhiệt độ điều hòa tiết kiệm điện nhất là?',
      'options': '18-20°C|||21-23°C|||25-26°C|||28-30°C',
      'correctAnswer': 2,
      'explanation': 'Nhiệt độ 25-26°C là mức tối ưu, vừa thoải mái vừa tiết kiệm điện.',
    });

    // Seed Questions for Lesson 4
    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Nguyên nhân chính của biến đổi khí hậu là?',
      'options': 'Mưa nhiều|||Khí nhà kính tăng|||Gió mạnh|||Sóng thần',
      'correctAnswer': 1,
      'explanation': 'Khí nhà kính từ hoạt động con người là nguyên nhân chính gây biến đổi khí hậu.',
    });

    // Seed Questions for Lesson 5
    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Vai trò quan trọng nhất của cây xanh là?',
      'options': 'Làm đẹp cảnh quan|||Sản xuất oxy, hấp thụ CO2|||Làm bóng mát|||Cho trái ngon',
      'correctAnswer': 1,
      'explanation': 'Cây xanh sản xuất oxy và hấp thụ CO2, vai trò quan trọng nhất cho sự sống trên Trái Đất.',
    });

    // Additional questions for Lesson 1 (Water pollution)
    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Giải pháp nào giúp giảm ô nhiễm nước?',
      'options': 'Đổ rác xuống sông|||Xây hệ thống xử lý nước thải|||Sử dụng nhiều hóa chất|||Chôn rác gần nguồn nước',
      'correctAnswer': 1,
      'explanation': 'Xây dựng hệ thống xử lý nước thải hiện đại là giải pháp quan trọng để giảm ô nhiễm nước.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Nguồn nào KHÔNG gây ô nhiễm nước?',
      'options': 'Nước mưa sạch|||Nước thải nhà máy|||Thuốc trừ sâu|||Rác thải sinh hoạt',
      'correctAnswer': 0,
      'explanation': 'Nước mưa tự nhiên là sạch, không gây ô nhiễm. Các nguồn khác đều có thể gây ô nhiễm nước.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Hóa chất nào từ nông nghiệp gây ô nhiễm nước?',
      'options': 'Nước tưới|||Phân bón và thuốc trừ sâu|||Đất trồng|||Rơm rạ',
      'correctAnswer': 1,
      'explanation': 'Phân bón hóa học và thuốc trừ sâu thấm xuống nguồn nước, gây ô nhiễm nghiêm trọng.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Dấu hiệu nào cho thấy nước bị ô nhiễm?',
      'options': 'Nước trong vắt|||Nước có mùi hôi, đục|||Nước mát lạnh|||Nước có vị ngọt',
      'correctAnswer': 1,
      'explanation': 'Nước ô nhiễm thường có mùi hôi, màu đục, có bọt hoặc cặn bẩn.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Ô nhiễm dầu mỏ ảnh hưởng đến sinh vật biển như thế nào?',
      'options': 'Giúp chúng lớn nhanh|||Làm chết cá, hải sản|||Không ảnh hưởng|||Tăng số lượng',
      'correctAnswer': 1,
      'explanation': 'Dầu mỏ tràn ra biển làm cá, hải sản chết hàng loạt, phá hủy hệ sinh thái biển.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Vi khuẩn trong nước ô nhiễm gây bệnh gì?',
      'options': 'Cảm cúm|||Tiêu chảy, nhiễm khuẩn|||Đau đầu|||Sốt xuất huyết',
      'correctAnswer': 1,
      'explanation': 'Vi khuẩn trong nước ô nhiễm gây tiêu chảy, kiết lỵ, tả và các bệnh nhiễm khuẩn đường ruột.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Cách nào bảo vệ nguồn nước tại cộng đồng?',
      'options': 'Vứt rác bừa bãi|||Giám sát, báo cáo ô nhiễm|||Không quan tâm|||Xả nước thải tự do',
      'correctAnswer': 1,
      'explanation': 'Giám sát và báo cáo kịp thời các hành vi gây ô nhiễm giúp bảo vệ nguồn nước cộng đồng.',
    });

    await db.insert('questions', {
      'lessonId': 1,
      'question': 'Xử lý nước thải sinh hoạt giúp được gì?',
      'options': 'Lãng phí tiền|||Giảm ô nhiễm, bảo vệ sức khỏe|||Không cần thiết|||Làm nước bẩn hơn',
      'correctAnswer': 1,
      'explanation': 'Xử lý nước thải loại bỏ chất bẩn, vi khuẩn, giảm ô nhiễm và bảo vệ sức khỏe cộng đồng.',
    });

    // Additional questions for Lesson 2 (Plastic waste)
    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Vi nhựa là gì?',
      'options': 'Nhựa mới sản xuất|||Nhựa tái chế|||Mảnh nhựa nhỏ hơn 5mm|||Nhựa sinh học',
      'correctAnswer': 2,
      'explanation': 'Vi nhựa là những mảnh nhựa nhỏ hơn 5mm, có thể xâm nhập vào cơ thể qua thức ăn và nước uống.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Loại nhựa nào khó tái chế nhất?',
      'options': 'Chai nước|||Túi nilon mỏng|||Thùng nhựa|||Ống nhựa',
      'correctAnswer': 1,
      'explanation': 'Túi nilon mỏng rất khó tái chế do mỏng, dễ rách và thường bị bẩn.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Rác thải nhựa trên biển ảnh hưởng gì đến động vật?',
      'options': 'Không ảnh hưởng|||Nuốt phải, mắc kẹt, chết|||Giúp chúng sống tốt|||Tăng số lượng',
      'correctAnswer': 1,
      'explanation': 'Động vật biển nuốt phải nhựa, bị mắc kẹt trong rác nhựa và chết hàng loạt.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Nhựa sinh học (bioplastic) có lợi gì?',
      'options': 'Không phân hủy|||Phân hủy nhanh hơn|||Rẻ hơn|||Bền hơn',
      'correctAnswer': 1,
      'explanation': 'Nhựa sinh học làm từ nguyên liệu tự nhiên, phân hủy nhanh hơn nhựa thông thường.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Mỗi năm có bao nhiêu tấn nhựa đổ ra đại dương?',
      'options': '1,000 tấn|||100,000 tấn|||Hàng triệu tấn|||Không có',
      'correctAnswer': 2,
      'explanation': 'Hàng triệu tấn nhựa đổ ra đại dương mỗi năm, gây ô nhiễm nghiêm trọng.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Ký hiệu tái chế trên nhựa có ý nghĩa gì?',
      'options': 'Trang trí|||Loại nhựa và khả năng tái chế|||Giá bán|||Thương hiệu',
      'correctAnswer': 1,
      'explanation': 'Ký hiệu (số 1-7) cho biết loại nhựa và cách tái chế phù hợp.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Cách nào giảm rác nhựa hiệu quả nhất?',
      'options': 'Mua nhiều đồ nhựa|||Dùng túi vải, hộp inox|||Đốt nhựa|||Chôn lấp',
      'correctAnswer': 1,
      'explanation': 'Thay thế bằng đồ dùng tái sử dụng như túi vải, hộp inox là cách hiệu quả nhất.',
    });

    await db.insert('questions', {
      'lessonId': 2,
      'question': 'Chai nhựa có thể tái chế thành gì?',
      'options': 'Không tái chế được|||Quần áo, thảm, đồ dùng mới|||Thức ăn|||Nước uống',
      'correctAnswer': 1,
      'explanation': 'Chai nhựa tái chế có thể làm sợi vải (quần áo), thảm, đồ dùng nhựa mới.',
    });

    // Additional questions for Lesson 3 (Energy saving)
    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Loại bóng đèn nào tiết kiệm điện nhất?',
      'options': 'Bóng sợi đốt|||Bóng huỳnh quang|||Bóng LED|||Bóng halogen',
      'correctAnswer': 2,
      'explanation': 'Bóng đèn LED tiết kiệm điện nhất, sử dụng ít năng lượng hơn 80% so với bóng sợi đốt.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Hành động nào KHÔNG tiết kiệm năng lượng?',
      'options': 'Tắt đèn khi ra khỏi phòng|||Rút phích cắm thiết bị|||Để điều hòa 18°C cả ngày|||Sử dụng đèn LED',
      'correctAnswer': 2,
      'explanation': 'Để điều hòa 18°C cả ngày sẽ tiêu tốn rất nhiều điện. Nhiệt độ 25-26°C là hợp lý.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Thiết bị nào tiêu tốn nhiều điện nhất trong nhà?',
      'options': 'Bàn ủi|||Điều hòa|||Bóng đèn|||Tivi',
      'correctAnswer': 1,
      'explanation': 'Điều hòa tiêu tốn nhiều điện nhất, chiếm 50-60% hóa đơn tiền điện.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Tại sao nên rút phích cắm thiết bị không dùng?',
      'options': 'Không cần thiết|||Thiết bị vẫn tiêu điện chế độ chờ|||Để tiết kiệm thời gian|||Không lý do',
      'correctAnswer': 1,
      'explanation': 'Thiết bị ở chế độ chờ vẫn tiêu điện (điện ma), rút phích giúp tiết kiệm 5-10% điện.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Nhãn Energy Star trên thiết bị có ý nghĩa gì?',
      'options': 'Giá cao|||Tiết kiệm năng lượng|||Màu đẹp|||Hàng mới',
      'correctAnswer': 1,
      'explanation': 'Energy Star là chứng nhận thiết bị tiết kiệm năng lượng, hiệu suất cao.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Sử dụng quạt thay điều hòa giúp tiết kiệm bao nhiêu?',
      'options': '10-20%|||30-40%|||Tới 90%|||Không tiết kiệm',
      'correctAnswer': 2,
      'explanation': 'Quạt tiêu tốn ít điện hơn điều hòa tới 90%, rất tiết kiệm khi thời tiết mát.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Bảo trì máy lạnh định kỳ giúp gì?',
      'options': 'Tốn tiền|||Tiết kiệm điện, máy bền lâu|||Không cần thiết|||Hỏng nhanh hơn',
      'correctAnswer': 1,
      'explanation': 'Vệ sinh lọc gió, bơm gas giúp máy lạnh hoạt động hiệu quả, tiết kiệm 10-30% điện.',
    });

    await db.insert('questions', {
      'lessonId': 3,
      'question': 'Cách nào tiết kiệm điện khi nấu ăn?',
      'options': 'Nấu từng lúc một ít|||Nấu nhiều món cùng lúc|||Để lửa to|||Mở nắp liên tục',
      'correctAnswer': 1,
      'explanation': 'Nấu nhiều món cùng lúc, đậy nắp kín giúp giữ nhiệt và tiết kiệm gas/điện.',
    });

    // Additional questions for Lesson 4 (Climate change)
    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Hậu quả nào KHÔNG phải do biến đổi khí hậu?',
      'options': 'Băng tan, mực nước biển dâng|||Thiên tai cực đoan|||Động đất|||Hạn hán nghiêm trọng',
      'correctAnswer': 2,
      'explanation': 'Động đất không liên quan đến biến đổi khí hậu. Các hiện tượng khác đều do nhiệt độ Trái Đất tăng gây ra.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Cách nào giúp giảm biến đổi khí hậu?',
      'options': 'Đốt nhiều than|||Phá rừng|||Trồng cây và bảo vệ rừng|||Tăng chăn nuôi bò',
      'correctAnswer': 2,
      'explanation': 'Trồng cây và bảo vệ rừng giúp hấp thụ CO2, giảm khí nhà kính, chống biến đổi khí hậu.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Băng tan ở Nam Cực và Bắc Cực gây ra vấn đề gì?',
      'options': 'Không có vấn đề|||Mực nước biển dâng|||Nhiều đất đai hơn|||Khí hậu mát hơn',
      'correctAnswer': 1,
      'explanation': 'Băng tan làm mực nước biển dâng, ngập các vùng ven biển, đảo nhỏ.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Nông nghiệp bị ảnh hưởng bởi BĐKH như thế nào?',
      'options': 'Mùa màng tốt hơn|||Mất mùa, dịch bệnh|||Không ảnh hưởng|||Tăng sản lượng',
      'correctAnswer': 1,
      'explanation': 'BĐKH gây hạn hán, lũ lụt, dịch bệnh làm mất mùa, giảm sản lượng nông nghiệp.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Nhiệt độ Trái Đất đã tăng bao nhiêu kể từ thời kỳ tiền công nghiệp?',
      'options': '0.1°C|||0.5°C|||Khoảng 1.1°C|||5°C',
      'correctAnswer': 2,
      'explanation': 'Nhiệt độ toàn cầu đã tăng khoảng 1.1°C, nguy cơ vượt 1.5°C trong vài thập kỷ tới.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Giao thông vận tải thải ra khí gì gây BĐKH?',
      'options': 'Oxy|||CO2|||Hydro|||Nitơ',
      'correctAnswer': 1,
      'explanation': 'Xe cộ thải CO2 từ đốt xăng dầu, chiếm 24% lượng khí nhà kính toàn cầu.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Cách nào giảm khí thải từ giao thông?',
      'options': 'Mua thêm ô tô|||Đi xe đạp, xe buýt|||Lái xe nhanh|||Không bảo dưỡng xe',
      'correctAnswer': 1,
      'explanation': 'Sử dụng phương tiện công cộng, xe đạp giúp giảm khí thải đáng kể.',
    });

    await db.insert('questions', {
      'lessonId': 4,
      'question': 'Tầng ozon bị thủng ảnh hưởng gì?',
      'options': 'Không ảnh hưởng|||Tia UV gây ung thư da|||Khí hậu mát|||Mưa nhiều',
      'correctAnswer': 1,
      'explanation': 'Tầng ozon bảo vệ khỏi tia UV, khi bị thủng gây ung thư da, bệnh mắt.',
    });

    // Additional questions for Lesson 5 (Nature & Ecosystem)
    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Khi một loài biến mất khỏi hệ sinh thái, điều gì xảy ra?',
      'options': 'Không ảnh hưởng gì|||Toàn bộ hệ thống bị ảnh hưởng|||Chỉ ảnh hưởng loài đó|||Hệ thống tốt hơn',
      'correctAnswer': 1,
      'explanation': 'Mỗi loài đều có vai trò riêng. Khi một loài biến mất, toàn bộ hệ sinh thái bị ảnh hưởng.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Hành động nào bảo vệ đa dạng sinh học?',
      'options': 'Săn bắt động vật|||Mua bán động vật hoang dã|||Trồng cây bản địa|||Sử dụng nhiều hóa chất',
      'correctAnswer': 2,
      'explanation': 'Trồng cây bản địa giúp tạo môi trường sống cho động vật và bảo vệ đa dạng sinh học.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Một cây trưởng thành có thể hấp thụ bao nhiêu kg CO2/năm?',
      'options': '1-2 kg|||5-10 kg|||20-30 kg|||100 kg',
      'correctAnswer': 2,
      'explanation': 'Một cây trưởng thành hấp thụ khoảng 20-30 kg CO2 mỗi năm, giúp giảm khí nhà kính.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Chuỗi thức ăn bị đứt khi nào?',
      'options': 'Có thêm loài mới|||Một loài bị tuyệt chủng|||Mùa màng tốt|||Nhiều thức ăn',
      'correctAnswer': 1,
      'explanation': 'Khi một loài trong chuỗi thức ăn tuyệt chủng, toàn bộ chuỗi bị ảnh hưởng.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Ong có vai trò gì trong hệ sinh thái?',
      'options': 'Không có|||Thụ phấn cho hoa|||Gây hại|||Chỉ làm mật ong',
      'correctAnswer': 1,
      'explanation': 'Ong thụ phấn cho 75% cây trồng, rất quan trọng cho nông nghiệp và hệ sinh thái.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Loài ngoại lai xâm lấn có hại như thế nào?',
      'options': 'Tốt cho môi trường|||Phá hủy loài bản địa|||Tăng đa dạng|||Không ảnh hưởng',
      'correctAnswer': 1,
      'explanation': 'Loài ngoại lai cạnh tranh, ăn mất loài bản địa, phá hủy cân bằng sinh thái.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Cây xanh giúp giảm nhiệt độ thành phố bao nhiêu?',
      'options': 'Không giảm|||1-2°C|||3-5°C|||10°C',
      'correctAnswer': 2,
      'explanation': 'Cây xanh giảm nhiệt độ thành phố 3-5°C nhờ bóng mát và bốc hơi nước.',
    });

    await db.insert('questions', {
      'lessonId': 5,
      'question': 'Rừng ngập mặn bảo vệ bờ biển khỏi?',
      'options': 'Mưa|||Sóng thần, bão|||Nắng|||Gió nhẹ',
      'correctAnswer': 1,
      'explanation': 'Rừng ngập mặn là hàng rào tự nhiên chống sóng thần, bão, bảo vệ cộng đồng ven biển.',
    });

    // Questions for Lesson 6 (Save water daily)
    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Nước ngọt chiếm bao nhiêu % tổng lượng nước trên Trái Đất?',
      'options': '2.5%|||10%|||25%|||50%',
      'correctAnswer': 0,
      'explanation': 'Nước ngọt chỉ chiếm 2.5% tổng lượng nước, rất khan hiếm và cần tiết kiệm.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Cách nào KHÔNG giúp tiết kiệm nước?',
      'options': 'Tắm vòi sen thay vì bồn|||Tắt vòi khi xà phòng|||Để vòi chảy khi đánh răng|||Sửa vòi rò rỉ',
      'correctAnswer': 2,
      'explanation': 'Để vòi chảy khi đánh răng lãng phí rất nhiều nước. Nên tắt vòi khi không dùng.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Nước vo gạo có thể tái sử dụng để làm gì?',
      'options': 'Uống|||Tưới cây|||Giặt quần áo|||Không dùng được',
      'correctAnswer': 1,
      'explanation': 'Nước vo gạo có chất dinh dưỡng, rất tốt để tưới cây, vừa tiết kiệm vừa bổ dưỡng cho cây.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Một vòi nước rò rỉ lãng phí bao nhiêu lít/ngày?',
      'options': '1-2 lít|||5-10 lít|||20-50 lít|||100 lít',
      'correctAnswer': 2,
      'explanation': 'Vòi rò rỉ có thể lãng phí 20-50 lít nước mỗi ngày, nên sửa ngay khi phát hiện.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Tắm bồn tiêu tốn nhiều nước hơn tắm vòi sen bao nhiêu?',
      'options': 'Bằng nhau|||Gấp 2 lần|||Gấp 3-4 lần|||Ít hơn',
      'correctAnswer': 2,
      'explanation': 'Tắm bồn dùng khoảng 150-200 lít, tắm vòi sen chỉ 40-60 lít, tiết kiệm gấp 3-4 lần.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Máy giặt nên sử dụng khi nào để tiết kiệm nước?',
      'options': 'Giặt ít quần áo mỗi lần|||Giặt đầy tải|||Giặt liên tục|||Giặt từng chiếc',
      'correctAnswer': 1,
      'explanation': 'Giặt đầy tải giúp tiết kiệm nước và điện, không lãng phí cho các mẻ giặt nhỏ.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Nước rửa rau có thể tái sử dụng để làm gì?',
      'options': 'Không dùng được|||Tưới cây, lau nhà|||Nấu ăn|||Uống',
      'correctAnswer': 1,
      'explanation': 'Nước rửa rau sạch có thể tưới cây hoặc lau nhà, tiết kiệm và bảo vệ môi trường.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Bồn cầu hai nút xả tiết kiệm nước như thế nào?',
      'options': 'Không tiết kiệm|||Dùng ít nước cho chất thải nhẹ|||Lãng phí hơn|||Chỉ trang trí',
      'correctAnswer': 1,
      'explanation': 'Bồn cầu hai nút cho phép chọn lượng nước phù hợp (3L hoặc 6L), tiết kiệm đáng kể.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Rửa xe bằng vòi phun tốn bao nhiêu nước?',
      'options': '10-20 lít|||50-100 lít|||150-300 lít|||500 lít',
      'correctAnswer': 2,
      'explanation': 'Rửa xe bằng vòi phun tốn 150-300 lít. Dùng xô và khăn chỉ tốn 20-30 lít.',
    });

    await db.insert('questions', {
      'lessonId': 6,
      'question': 'Thu nước mưa có lợi gì?',
      'options': 'Không có lợi|||Tưới cây, rửa xe miễn phí|||Gây bệnh|||Bẩn không dùng được',
      'correctAnswer': 1,
      'explanation': 'Nước mưa sạch, miễn phí, rất tốt để tưới cây, rửa xe, giặt sàn.',
    });

    // Questions for Lesson 7 (Groundwater pollution)
    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Nguyên nhân chính gây ô nhiễm nước ngầm là?',
      'options': 'Mưa nhiều|||Rò rỉ bể phốt và hóa chất|||Nắng nóng|||Gió mạnh',
      'correctAnswer': 1,
      'explanation': 'Rò rỉ bể phốt và hóa chất thấm xuống đất là nguyên nhân chính gây ô nhiễm nước ngầm.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Nước ngầm bị ô nhiễm gây ra hậu quả gì?',
      'options': 'Không có hậu quả|||Nước uống không an toàn|||Nước ngon hơn|||Giá nước rẻ hơn',
      'correctAnswer': 1,
      'explanation': 'Nước ngầm ô nhiễm làm nguồn nước uống không an toàn, gây bệnh cho con người.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Cách nào bảo vệ nước ngầm?',
      'options': 'Đổ hóa chất xuống đất|||Xây bể phốt đúng quy cách|||Chôn rác bừa bãi|||Khai thác quá mức',
      'correctAnswer': 1,
      'explanation': 'Xây dựng bể phốt đúng quy cách ngăn rò rỉ, bảo vệ nguồn nước ngầm không bị ô nhiễm.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Nước ngầm bị nhiễm mặn do đâu?',
      'options': 'Mưa nhiều|||Khai thác quá mức|||Cây cối|||Không khí',
      'correctAnswer': 1,
      'explanation': 'Khai thác nước ngầm quá mức làm nước biển thấm vào, gây nhiễm mặn.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Nitrat trong nước ngầm từ đâu?',
      'options': 'Đất|||Phân bón hóa học|||Cây cối|||Mưa',
      'correctAnswer': 1,
      'explanation': 'Phân bón hóa học thấm xuống nước ngầm tạo nitrat, độc hại cho trẻ em.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Bể phốt rò rỉ gây ô nhiễm gì?',
      'options': 'Không gây ô nhiễm|||Vi khuẩn, mầm bệnh|||Chỉ có mùi|||Tốt cho đất',
      'correctAnswer': 1,
      'explanation': 'Bể phốt rò rỉ làm vi khuẩn, mầm bệnh thấm xuống nước ngầm, nguy hiểm.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Khoảng cách an toàn giữa bể phốt và giếng nước?',
      'options': '1-2m|||5-10m|||Ít nhất 15-20m|||Không quan trọng',
      'correctAnswer': 2,
      'explanation': 'Bể phốt phải cách giếng nước ít nhất 15-20m để tránh ô nhiễm.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Dấu hiệu nào cho thấy nước ngầm bị ô nhiễm?',
      'options': 'Nước trong|||Mùi lạ, vị mặn, màu đục|||Ngon|||Mát lạnh',
      'correctAnswer': 1,
      'explanation': 'Nước ngầm ô nhiễm có mùi lạ, vị mặn hoặc kim loại, màu đục, cần kiểm tra.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Chất nào từ pin/bóng đèn gây ô nhiễm nước ngầm?',
      'options': 'Nước|||Kim loại nặng (chì, thủy ngân)|||Nhựa|||Giấy',
      'correctAnswer': 1,
      'explanation': 'Pin, bóng đèn chứa kim loại nặng độc hại, thấm xuống đất gây ô nhiễm nghiêm trọng.',
    });

    await db.insert('questions', {
      'lessonId': 7,
      'question': 'Xử lý nước ngầm ô nhiễm như thế nào?',
      'options': 'Không cần|||Lọc, khử trùng hoặc đào giếng mới|||Đun sôi là đủ|||Thêm đường',
      'correctAnswer': 1,
      'explanation': 'Nước ngầm ô nhiễm cần lọc đặc biệt, khử trùng hoặc đào giếng mới ở vị trí an toàn.',
    });

    // Questions for Lesson 8 (Waste sorting & recycling)
    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Loại rác nào có thể tái chế?',
      'options': 'Thức ăn thừa|||Chai nhựa|||Khăn giấy đã dùng|||Lá cây',
      'correctAnswer': 1,
      'explanation': 'Chai nhựa là rác tái chế, có thể chế biến thành sản phẩm mới.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Rác hữu cơ có thể làm gì?',
      'options': 'Đốt đi|||Vứt bừa bãi|||Làm phân compost|||Chôn xuống đất',
      'correctAnswer': 2,
      'explanation': 'Rác hữu cơ có thể ủ thành phân compost, tốt cho cây trồng và giảm rác thải.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Loại rác nào cần xử lý đặc biệt?',
      'options': 'Giấy|||Pin và bóng đèn|||Chai thủy tinh|||Lon kim loại',
      'correctAnswer': 1,
      'explanation': 'Pin và bóng đèn là rác nguy hại, chứa chất độc, cần xử lý đặc biệt.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Màu thùng rác nào dùng cho rác tái chế?',
      'options': 'Đen|||Xanh|||Đỏ|||Vàng',
      'correctAnswer': 1,
      'explanation': 'Thùng xanh (hoặc vàng) dùng cho rác tái chế như nhựa, giấy, kim loại.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Giấy dính băng keo có tái chế được không?',
      'options': 'Có|||Khó tái chế|||Rất tốt|||Không quan trọng',
      'correctAnswer': 1,
      'explanation': 'Giấy dính băng keo, ghim khó tái chế. Cần gỡ sạch trước khi bỏ vào thùng tái chế.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Lon kim loại nên xử lý thế nào trước khi tái chế?',
      'options': 'Để nguyên|||Rửa sạch, làm phẳng|||Đập vỡ|||Đốt',
      'correctAnswer': 1,
      'explanation': 'Lon nên rửa sạch, làm phẳng để tiết kiệm không gian và dễ tái chế.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Thời gian phân hủy của giấy bao lâu?',
      'options': '2-4 tuần|||2-6 tháng|||5-10 năm|||100 năm',
      'correctAnswer': 1,
      'explanation': 'Giấy phân hủy trong 2-6 tháng, nhanh hơn nhiều so với nhựa (hàng trăm năm).',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Hộp xốp (foam) có tái chế được không?',
      'options': 'Dễ tái chế|||Rất khó tái chế|||Không cần tái chế|||Tốt nhất',
      'correctAnswer': 1,
      'explanation': 'Hộp xốp rất khó tái chế, nên hạn chế sử dụng và thay bằng hộp giấy.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Tái chế 1 tấn giấy tiết kiệm được gì?',
      'options': 'Không tiết kiệm|||Cứu 17 cây, tiết kiệm nước/điện|||Chỉ tiết kiệm tiền|||Hại môi trường',
      'correctAnswer': 1,
      'explanation': 'Tái chế 1 tấn giấy cứu 17 cây, tiết kiệm 26,000 lít nước và 4,000 kWh điện.',
    });

    await db.insert('questions', {
      'lessonId': 8,
      'question': 'Chai thủy tinh có thể tái chế bao nhiêu lần?',
      'options': '1 lần|||5 lần|||Vô số lần|||Không tái chế được',
      'correctAnswer': 2,
      'explanation': 'Thủy tinh có thể tái chế vô số lần không mất chất lượng, rất bền vững.',
    });

    // Questions for Lesson 9 (Zero Waste lifestyle)
    await db.insert('questions', {
      'lessonId': 9,
      'question': 'R đầu tiên trong nguyên tắc 5R là gì?',
      'options': 'Recycle (Tái chế)|||Reuse (Tái sử dụng)|||Refuse (Từ chối)|||Reduce (Giảm thiểu)',
      'correctAnswer': 2,
      'explanation': 'Refuse (Từ chối) là bước đầu tiên - từ chối những thứ không cần thiết như túi ni lông, ống hút nhựa.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Hành động nào thể hiện "Reuse" (Tái sử dụng)?',
      'options': 'Mua đồ mới liên tục|||Vứt bỏ đồ cũ|||Sửa chữa và dùng lại|||Đốt rác',
      'correctAnswer': 2,
      'explanation': 'Sửa chữa và dùng lại đồ cũ là Reuse, giảm rác thải và tiết kiệm tài nguyên.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': '"Rot" trong 5R nghĩa là gì?',
      'options': 'Ủ phân hữu cơ|||Vứt bỏ|||Đốt rác|||Chôn lấp',
      'correctAnswer': 0,
      'explanation': 'Rot là ủ rác hữu cơ thành phân compost, tốt cho môi trường và cây trồng.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Cửa hàng Zero Waste bán gì?',
      'options': 'Đồ đóng gói sẵn|||Sản phẩm bán lẻ, không bao bì|||Chỉ nhựa|||Đồ dùng một lần',
      'correctAnswer': 1,
      'explanation': 'Cửa hàng Zero Waste bán sản phẩm rời, khách mang hộp/túi đựng, không bao bì.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Minimalism (tối giản) liên quan Zero Waste thế nào?',
      'options': 'Không liên quan|||Cùng giảm tiêu dùng, rác thải|||Trái ngược|||Chỉ về thiết kế',
      'correctAnswer': 1,
      'explanation': 'Minimalism khuyến khích sống tối giản, giảm tiêu dùng, ít rác thải, phù hợp Zero Waste.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Beeswax wrap là gì?',
      'options': 'Túi nhựa|||Màng bảo quản thực phẩm từ sáp ong|||Giấy gói|||Hộp nhựa',
      'correctAnswer': 1,
      'explanation': 'Beeswax wrap là vải tẩm sáp ong, dùng bọc thức ăn thay màng bọc nhựa, tái sử dụng được.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Bulk buying (mua số lượng lớn) giúp giảm rác thế nào?',
      'options': 'Tăng rác|||Giảm bao bì|||Không giúp|||Gây lãng phí',
      'correctAnswer': 1,
      'explanation': 'Mua số lượng lớn giảm bao bì đóng gói, tiết kiệm và giảm rác thải nhựa.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'Secondhand (đồ cũ) có lợi gì?',
      'options': 'Chất lượng kém|||Giảm sản xuất mới, ít rác thải|||Đắt hơn|||Không tốt',
      'correctAnswer': 1,
      'explanation': 'Mua đồ cũ giảm nhu cầu sản xuất mới, tiết kiệm tài nguyên và giảm rác thải.',
    });

    await db.insert('questions', {
      'lessonId': 9,
      'question': 'DIY (tự làm) sản phẩm Zero Waste giúp gì?',
      'options': 'Lãng phí thời gian|||Kiểm soát thành phần, không bao bì|||Tốn kém hơn|||Khó khăn',
      'correctAnswer': 1,
      'explanation': 'Tự làm sản phẩm (xà phòng, nước rửa) giúp kiểm soát thành phần, không bao bì nhựa.',
    });

    // Questions for Lesson 10 (Renewable energy)
    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Loại năng lượng nào là năng lượng tái tạo?',
      'options': 'Than đá|||Dầu mỏ|||Năng lượng mặt trời|||Khí đốt',
      'correctAnswer': 2,
      'explanation': 'Năng lượng mặt trời là năng lượng tái tạo, sạch và không bao giờ cạn kiệt.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Lợi ích của năng lượng tái tạo là gì?',
      'options': 'Gây ô nhiễm|||Cạn kiệt nhanh|||Giảm khí nhà kính|||Giá rẻ ngay lập tức',
      'correctAnswer': 2,
      'explanation': 'Năng lượng tái tạo giảm phát thải khí nhà kính, bảo vệ môi trường lâu dài.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Năng lượng gió hiệu quả nhất ở đâu?',
      'options': 'Vùng không gió|||Vùng gió yếu|||Vùng gió mạnh|||Dưới lòng đất',
      'correctAnswer': 2,
      'explanation': 'Tuabin gió hoạt động hiệu quả nhất ở vùng có gió mạnh và ổn định.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Năng lượng địa nhiệt lấy từ đâu?',
      'options': 'Mặt trời|||Nhiệt từ lòng đất|||Gió|||Nước',
      'correctAnswer': 1,
      'explanation': 'Năng lượng địa nhiệt khai thác nhiệt từ lòng đất, ổn định và sạch.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Pin mặt trời hoạt động khi nào?',
      'options': 'Chỉ ban ngày có nắng|||Cả ngày lẫn đêm|||Chỉ ban đêm|||Không hoạt động',
      'correctAnswer': 0,
      'explanation': 'Pin mặt trời chuyển ánh sáng thành điện, hoạt động khi có nắng. Ban đêm dùng điện từ pin lưu trữ.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Nhà máy thủy điện nhỏ có lợi gì?',
      'options': 'Gây hại|||Ít tác động môi trường, năng lượng sạch|||Đắt vô ích|||Gây lũ',
      'correctAnswer': 1,
      'explanation': 'Thủy điện nhỏ ít tác động môi trường, cung cấp điện sạch cho vùng sâu, vùng xa.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Biogas (khí sinh học) làm từ gì?',
      'options': 'Dầu mỏ|||Chất thải hữu cơ, phân gia súc|||Than đá|||Khí đốt',
      'correctAnswer': 1,
      'explanation': 'Biogas từ phân hủy chất thải hữu cơ, phân gia súc, cung cấp khí đun nấu và điện.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Năng lượng sóng biển có tiềm năng ở Việt Nam không?',
      'options': 'Không|||Rất lớn (3000km bờ biển)|||Không phù hợp|||Chỉ ở nước ngoài',
      'correctAnswer': 1,
      'explanation': 'Việt Nam có 3000km bờ biển, tiềm năng năng lượng sóng và gió biển rất lớn.',
    });

    await db.insert('questions', {
      'lessonId': 10,
      'question': 'Tại sao cần lưu trữ năng lượng tái tạo?',
      'options': 'Không cần|||Năng lượng không ổn định (nắng, gió)|||Lãng phí|||Không dùng được',
      'correctAnswer': 1,
      'explanation': 'Năng lượng tái tạo phụ thuộc thời tiết, cần lưu trữ (pin, bơm nước) để dùng khi không có nắng/gió.',
    });

    // Questions for Lesson 11 (Building energy efficiency)
    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Tòa nhà tiêu thụ bao nhiêu % năng lượng toàn cầu?',
      'options': '10%|||20%|||40%|||60%',
      'correctAnswer': 2,
      'explanation': 'Tòa nhà tiêu thụ khoảng 40% năng lượng toàn cầu, cần thiết kế hiệu quả để tiết kiệm.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Thiết kế nào giúp tòa nhà tiết kiệm năng lượng?',
      'options': 'Cửa sổ nhỏ|||Không có mái che|||Cửa sổ lớn tận dụng ánh sáng tự nhiên|||Không cách nhiệt',
      'correctAnswer': 2,
      'explanation': 'Cửa sổ lớn giúp tận dụng ánh sáng tự nhiên, giảm sử dụng đèn điện, tiết kiệm năng lượng.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Chứng nhận tòa nhà xanh ở Việt Nam là?',
      'options': 'LEED|||LOTUS|||Energy Star|||BREEAM',
      'correctAnswer': 1,
      'explanation': 'LOTUS là tiêu chuẩn đánh giá tòa nhà xanh của Việt Nam, giúp tiết kiệm năng lượng 20-50%.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Mái xanh (green roof) có lợi gì?',
      'options': 'Chỉ đẹp|||Cách nhiệt, hấp thụ mưa|||Tốn kém vô ích|||Gây rò rỉ',
      'correctAnswer': 1,
      'explanation': 'Mái xanh cách nhiệt, giảm 20-30% chi phí điều hòa, hấp thụ nước mưa, giảm lũ đô thị.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Kính Low-E giúp tiết kiệm năng lượng thế nào?',
      'options': 'Không giúp|||Phản xạ nhiệt, giữ mát/ấm|||Chỉ đẹp|||Đắt không hiệu quả',
      'correctAnswer': 1,
      'explanation': 'Kính Low-E phản xạ tia hồng ngoại, giữ mát mùa hè/ấm mùa đông, tiết kiệm điều hòa 30%.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Cảm biến chuyển động đèn có ích gì?',
      'options': 'Không cần thiết|||Tự động bật/tắt, tiết kiệm điện|||Gây phiền|||Đắt đỏ',
      'correctAnswer': 1,
      'explanation': 'Cảm biến tự động tắt đèn khi không có người, tiết kiệm 30-50% điện chiếu sáng.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Hướng tòa nhà nào tốt nhất ở Việt Nam?',
      'options': 'Hướng Tây|||Hướng Đông/Đông Nam|||Hướng Bắc|||Không quan trọng',
      'correctAnswer': 1,
      'explanation': 'Hướng Đông/Đông Nam đón gió mát, tránh nắng Tây nóng, giảm điều hòa.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Thang máy tiết kiệm năng lượng có gì đặc biệt?',
      'options': 'Không khác|||Hồi sinh năng lượng khi xuống|||Chậm hơn|||Không an toàn',
      'correctAnswer': 1,
      'explanation': 'Thang máy regenerative hồi sinh năng lượng khi xuống, tiết kiệm tới 40% điện.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'Vật liệu cách nhiệt tốt nhất là?',
      'options': 'Kim loại|||Bê tông|||Bông thủy tinh, xốp EPS|||Gỗ',
      'correctAnswer': 2,
      'explanation': 'Bông thủy tinh, xốp EPS cách nhiệt rất tốt, giảm nhiệt độ trong nhà 5-8°C.',
    });

    await db.insert('questions', {
      'lessonId': 11,
      'question': 'BMS (Building Management System) là gì?',
      'options': 'Hệ thống trang trí|||Hệ thống quản lý tòa nhà thông minh|||Hệ thống báo cháy|||Không quan trọng',
      'correctAnswer': 1,
      'explanation': 'BMS tự động điều khiển điện, nước, điều hòa tối ưu, tiết kiệm 20-40% năng lượng.',
    });

    // Questions for Lesson 12 (Greenhouse gases)
    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Khí nhà kính chiếm tỷ lệ lớn nhất là?',
      'options': 'CH4 (Methane)|||N2O (Nitrous oxide)|||CO2 (Carbon dioxide)|||O2 (Oxygen)',
      'correctAnswer': 2,
      'explanation': 'CO2 chiếm 76% tổng lượng khí nhà kính, chủ yếu từ đốt nhiên liệu hóa thạch.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Khí methane (CH4) chủ yếu từ đâu?',
      'options': 'Xe hơi|||Chăn nuôi và ruộng lúa|||Máy bay|||Máy tính',
      'correctAnswer': 1,
      'explanation': 'Methane chủ yếu từ chăn nuôi (bò, trâu) và ruộng lúa, mạnh gấp 25 lần CO2.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Cách nào giảm phát thải khí nhà kính?',
      'options': 'Đốt than|||Phá rừng|||Ăn ít thịt, nhiều thực vật|||Tăng chăn nuôi',
      'correctAnswer': 2,
      'explanation': 'Ăn ít thịt giảm nhu cầu chăn nuôi, từ đó giảm phát thải methane và CO2.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'SF6 là khí nhà kính gì?',
      'options': 'Yếu nhất|||Mạnh nhất (gấp 23,000 lần CO2)|||Trung bình|||Không phải khí nhà kính',
      'correctAnswer': 1,
      'explanation': 'SF6 (sulfur hexafluoride) là khí nhà kính mạnh nhất, mạnh gấp 23,000 lần CO2, dùng trong điện.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Carbon footprint là gì?',
      'options': 'Dấu chân|||Lượng CO2 một người/tổ chức thải ra|||Bàn chân to|||Không liên quan',
      'correctAnswer': 1,
      'explanation': 'Carbon footprint là tổng lượng khí nhà kính (tính bằng CO2) một người/tổ chức thải ra.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Ăn thịt bò thải bao nhiêu kg CO2/kg thịt?',
      'options': '1-2 kg|||5-10 kg|||27 kg|||100 kg',
      'correctAnswer': 2,
      'explanation': 'Sản xuất 1 kg thịt bò thải khoảng 27 kg CO2, cao gấp 10 lần rau củ.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Cách nào giảm carbon footprint khi đi lại?',
      'options': 'Lái xe một mình|||Xe buýt, xe đạp, đi chung|||Bay máy bay nhiều|||Mua xe to',
      'correctAnswer': 1,
      'explanation': 'Xe buýt, xe đạp, đi chung xe giảm 50-90% khí thải so với lái xe riêng.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Mua hàng local (địa phương) giảm khí thải thế nào?',
      'options': 'Không giảm|||Giảm vận chuyển, ít CO2|||Tăng khí thải|||Không liên quan',
      'correctAnswer': 1,
      'explanation': 'Hàng địa phương giảm vận chuyển xa, tiết kiệm nhiên liệu và giảm CO2.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'CFC (chlorofluorocarbons) gây hại gì?',
      'options': 'Tốt cho môi trường|||Phá hủy tầng ozon|||Không hại|||Tạo oxy',
      'correctAnswer': 1,
      'explanation': 'CFC phá hủy tầng ozon, đã bị cấm sử dụng trong điều hòa, tủ lạnh.',
    });

    await db.insert('questions', {
      'lessonId': 12,
      'question': 'Carbon offset là gì?',
      'options': 'Tăng phát thải|||Bù trừ carbon (trồng cây, đầu tư xanh)|||Đốt cháy|||Không làm gì',
      'correctAnswer': 1,
      'explanation': 'Carbon offset là bù trừ khí thải bằng cách trồng cây, đầu tư dự án xanh.',
    });

    // Questions for Lesson 13 (Climate adaptation)
    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Thích ứng với biến đổi khí hậu nghĩa là gì?',
      'options': 'Làm khí hậu thay đổi nhanh hơn|||Bỏ mặc không làm gì|||Điều chỉnh để sống với tác động|||Tăng phát thải',
      'correctAnswer': 2,
      'explanation': 'Thích ứng là điều chỉnh cách sống và sản xuất để đối phó với tác động của biến đổi khí hậu.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Giải pháp thích ứng với hạn hán là?',
      'options': 'Dùng nhiều nước hơn|||Trồng cây chống hạn, tưới tiết kiệm|||Phá rừng|||Không làm gì',
      'correctAnswer': 1,
      'explanation': 'Trồng giống cây chống hạn và hệ thống tưới tiết kiệm nước giúp thích ứng với hạn hán.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Cá nhân có thể thích ứng với biến đổi khí hậu bằng cách?',
      'options': 'Bỏ mặc|||Dự trữ nước, lương thực|||Lãng phí tài nguyên|||Không quan tâm',
      'correctAnswer': 1,
      'explanation': 'Dự trữ nước, lương thực giúp cá nhân sẵn sàng ứng phó với thiên tai và khí hậu cực đoan.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Kết cấu chống bão cho nhà ở vùng ven biển?',
      'options': 'Nhà thấp, yếu|||Móng sâu, mái chắc, cột thép|||Không cần|||Nhà gỗ nhẹ',
      'correctAnswer': 1,
      'explanation': 'Nhà móng sâu, mái chắc, cột thép chịu được gió bão mạnh, bảo vệ người dân.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Hệ thống tưới nhỏ giọt giúp gì trong hạn hán?',
      'options': 'Lãng phí nước|||Tiết kiệm 50-70% nước|||Không hiệu quả|||Đắt đỏ vô ích',
      'correctAnswer': 1,
      'explanation': 'Tưới nhỏ giọt đưa nước trực tiếp đến rễ, tiết kiệm 50-70% nước, hiệu quả cao.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Giống cây chống hạn là?',
      'options': 'Lúa nước|||Ngô, khoai, cây ăn quả chịu hạn|||Rau màu|||Chỉ có cỏ',
      'correctAnswer': 1,
      'explanation': 'Ngô, khoai, cây ăn quả chịu hạn giúp nông dân duy trì sản xuất khi thiếu nước.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Hệ thống cảnh báo sớm thiên tai giúp gì?',
      'options': 'Không giúp|||Sơ tán kịp thời, giảm thiệt hại|||Gây hoảng loạn|||Tốn kém',
      'correctAnswer': 1,
      'explanation': 'Cảnh báo sớm giúp người dân sơ tán, chuẩn bị, giảm thiệt hại về người và tài sản.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Đê biển, kè chống sóng có tác dụng gì?',
      'options': 'Chỉ trang trí|||Chống xói mòn, sóng biển dâng|||Gây ngập|||Không cần thiết',
      'correctAnswer': 1,
      'explanation': 'Đê biển, kè ngăn sóng, chống xói mòn bờ biển, bảo vệ vùng ven biển khỏi ngập.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Bảo hiểm thiên tai giúp gì?',
      'options': 'Không giúp|||Bồi thường thiệt hại, phục hồi nhanh|||Lãng phí tiền|||Không cần',
      'correctAnswer': 1,
      'explanation': 'Bảo hiểm thiên tai giúp bồi thường thiệt hại, người dân phục hồi nhanh sau thiên tai.',
    });

    await db.insert('questions', {
      'lessonId': 13,
      'question': 'Xây dựng hồ chứa nước giúp gì khi hạn hán?',
      'options': 'Không giúp|||Dự trữ nước mùa mưa, dùng mùa khô|||Gây lũ|||Lãng phí đất',
      'correctAnswer': 1,
      'explanation': 'Hồ chứa dự trữ nước mùa mưa, cung cấp cho nông nghiệp và sinh hoạt mùa khô.',
    });

    // Questions for Lesson 14 (Biodiversity)
    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Bao nhiêu loài đang có nguy cơ tuyệt chủng?',
      'options': '1,000 loài|||10,000 loài|||100,000 loài|||1 triệu loài',
      'correctAnswer': 3,
      'explanation': 'Khoảng 1 triệu loài đang có nguy cơ tuyệt chủng do hoạt động con người.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Nguyên nhân chính gây tuyệt chủng loài là?',
      'options': 'Loài già tự nhiên|||Mất môi trường sống|||Loài tự tuyệt chủng|||Quá nhiều loài',
      'correctAnswer': 1,
      'explanation': 'Mất môi trường sống do phá rừng, đô thị hóa là nguyên nhân chính gây tuyệt chủng.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Hành động nào bảo vệ đa dạng sinh học?',
      'options': 'Săn bắt động vật|||Phá rừng|||Thành lập khu bảo tồn|||Buôn bán động vật',
      'correctAnswer': 2,
      'explanation': 'Thành lập khu bảo tồn bảo vệ môi trường sống, giúp các loài sinh sống và phát triển.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'CITES là gì?',
      'options': 'Tổ chức du lịch|||Công ước buôn bán động vật hoang dã|||Hội bảo vệ rừng|||Không rõ',
      'correctAnswer': 1,
      'explanation': 'CITES là công ước quốc tế kiểm soát buôn bán động thực vật hoang dã nguy cấp.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Sách Đỏ Việt Nam ghi gì?',
      'options': 'Danh sách loài quý hiếm, nguy cấp|||Sách nông nghiệp|||Sách lịch sử|||Truyện cổ tích',
      'correctAnswer': 0,
      'explanation': 'Sách Đỏ Việt Nam liệt kê các loài động thực vật quý hiếm, nguy cấp cần bảo vệ.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Vườn quốc gia và khu bảo tồn khác gì?',
      'options': 'Giống nhau|||VQG lớn hơn, đa dạng hơn|||KBT tốt hơn|||Không khác',
      'correctAnswer': 1,
      'explanation': 'Vườn quốc gia thường lớn hơn, đa dạng sinh học cao, có du lịch sinh thái.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Hotspot đa dạng sinh học là gì?',
      'options': 'Điểm wifi|||Khu vực đa dạng cao, nguy cơ mất mát lớn|||Nơi nóng|||Không rõ',
      'correctAnswer': 1,
      'explanation': 'Hotspot là khu vực có đa dạng sinh học cao nhưng đang bị đe dọa nghiêm trọng.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Corridor sinh thái là gì?',
      'options': 'Hành lang kết nối các khu bảo tồn|||Đường đi|||Cửa hàng|||Không rõ',
      'correctAnswer': 0,
      'explanation': 'Corridor là hành lang sinh thái nối các khu bảo tồn, giúp động vật di chuyển an toàn.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'Ex-situ conservation là gì?',
      'options': 'Bảo tồn ngoài môi trường sống|||Bảo tồn trong tự nhiên|||Không bảo tồn|||Săn bắt',
      'correctAnswer': 0,
      'explanation': 'Ex-situ là bảo tồn ngoài tự nhiên (vườn thú, vườn thực vật) để cứu loài nguy cấp.',
    });

    await db.insert('questions', {
      'lessonId': 14,
      'question': 'DNA banking có tác dụng gì?',
      'options': 'Không có|||Lưu trữ gen loài quý hiếm|||Ngân hàng tiền|||Không liên quan',
      'correctAnswer': 1,
      'explanation': 'DNA banking lưu trữ vật liệu di truyền loài quý hiếm, phục vụ nghiên cứu và nhân giống.',
    });

    // Questions for Lesson 15 (Forest protection)
    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Mỗi năm có bao nhiêu ha rừng bị mất?',
      'options': '1 triệu ha|||5 triệu ha|||10 triệu ha|||20 triệu ha',
      'correctAnswer': 2,
      'explanation': 'Khoảng 10 triệu ha rừng bị mất mỗi năm, tương đương diện tích Hàn Quốc.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Rừng là nhà của bao nhiêu % loài trên cạn?',
      'options': '20%|||40%|||60%|||80%',
      'correctAnswer': 3,
      'explanation': 'Rừng là nhà của 80% các loài động thực vật trên cạn, cần bảo vệ khẩn cấp.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Cách nào giúp bảo vệ rừng?',
      'options': 'Sử dụng gỗ lậu|||Phá rừng làm đất|||Trồng cây gây rừng|||Đốt rừng',
      'correctAnswer': 2,
      'explanation': 'Trồng cây gây rừng và tham gia các chương trình bảo vệ rừng giúp phục hồi diện tích rừng.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'REDD+ là gì?',
      'options': 'Chương trình trồng rừng|||Giảm phát thải từ phá rừng|||Tổ chức du lịch|||Không rõ',
      'correctAnswer': 1,
      'explanation': 'REDD+ là cơ chế quốc tế trả tiền cho các nước giảm phá rừng, bảo vệ rừng.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Rừng nhiệt đới chiếm bao nhiêu % diện tích rừng thế giới?',
      'options': '10%|||30%|||50%|||70%',
      'correctAnswer': 2,
      'explanation': 'Rừng nhiệt đới chiếm 50% diện tích rừng nhưng chứa 70% đa dạng sinh học.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Chứng chỉ FSC trên gỗ có nghĩa gì?',
      'options': 'Gỗ rẻ|||Gỗ từ rừng bền vững|||Gỗ lậu|||Không quan trọng',
      'correctAnswer': 1,
      'explanation': 'FSC chứng nhận gỗ từ rừng quản lý bền vững, hợp pháp, bảo vệ môi trường.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Trồng rừng thay thế được rừng tự nhiên không?',
      'options': 'Hoàn toàn|||Không thay thế được đa dạng sinh học|||Tốt hơn|||Giống nhau',
      'correctAnswer': 1,
      'explanation': 'Rừng trồng không thay thế được đa dạng sinh học của rừng tự nhiên hàng trăm năm tuổi.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Fire break (đường băng cản lửa) trong rừng là gì?',
      'options': 'Đường đi|||Dải đất trống ngăn cháy lan|||Đường tuần tra|||Bãi đậu xe',
      'correctAnswer': 1,
      'explanation': 'Fire break là dải đất trống không cây, ngăn cháy rừng lan rộng.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Cộng đồng dân cư có vai trò gì trong bảo vệ rừng?',
      'options': 'Không có|||Tuần tra, báo cáo, hưởng lợi từ rừng|||Phá rừng|||Không quan tâm',
      'correctAnswer': 1,
      'explanation': 'Cộng đồng địa phương tuần tra, bảo vệ rừng, được hưởng lợi từ lâm sản bền vững.',
    });

    await db.insert('questions', {
      'lessonId': 15,
      'question': 'Tái sinh rừng tự nhiên có lợi gì?',
      'options': 'Không có|||Chi phí thấp, đa dạng cao|||Chậm hơn|||Không hiệu quả',
      'correctAnswer': 1,
      'explanation': 'Tái sinh tự nhiên chi phí thấp, rừng đa dạng và bền vững hơn so với trồng mới.',
    });

    // Seed Challenges
    final challenges = [
      {
        'title': 'Không dùng ống hút nhựa',
        'description': 'Từ chối ống hút nhựa khi mua đồ uống trong 1 ngày',
        'points': 10,
        'icon': '🥤',
        'isCompleted': 0,
      },
      {
        'title': 'Tắt điện khi ra khỏi phòng',
        'description': 'Luôn nhớ tắt đèn và thiết bị điện khi rời khỏi phòng',
        'points': 5,
        'icon': '💡',
        'isCompleted': 0,
      },
      {
        'title': 'Mang chai nước cá nhân',
        'description': 'Sử dụng chai nước cá nhân thay vì mua chai nhựa',
        'points': 10,
        'icon': '🍶',
        'isCompleted': 0,
      },
      {
        'title': 'Đi xe đạp hoặc đi bộ',
        'description': 'Đi xe đạp hoặc đi bộ thay vì xe máy cho quãng đường ngắn',
        'points': 15,
        'icon': '🚲',
        'isCompleted': 0,
      },
      {
        'title': 'Phân loại rác tại nhà',
        'description': 'Phân loại rác hữu cơ, tái chế và rác thải',
        'points': 20,
        'icon': '♻️',
        'isCompleted': 0,
      },
      {
        'title': 'Trồng một cây xanh',
        'description': 'Trồng và chăm sóc một cây xanh',
        'points': 25,
        'icon': '🌱',
        'isCompleted': 0,
      },
      {
        'title': 'Tắm nước nhanh (5 phút)',
        'description': 'Tiết kiệm nước bằng cách tắm nhanh dưới 5 phút',
        'points': 10,
        'icon': '🚿',
        'isCompleted': 0,
      },
      {
        'title': 'Mang túi vải đi chợ',
        'description': 'Sử dụng túi vải thay vì túi nilon khi đi mua sắm',
        'points': 10,
        'icon': '🛍️',
        'isCompleted': 0,
      },
      {
        'title': 'Tham gia dọn rác',
        'description': 'Tham gia chiến dịch dọn rác ở công viên hoặc bãi biển',
        'points': 30,
        'icon': '🧹',
        'isCompleted': 0,
      },
      {
        'title': 'Sử dụng giao thông công cộng',
        'description': 'Đi xe buýt hoặc tàu điện thay vì xe cá nhân',
        'points': 15,
        'icon': '🚌',
        'isCompleted': 0,
      },
    ];

    for (var challenge in challenges) {
      await db.insert('challenges', challenge);
    }
  }

  // CRUD Operations for Lessons
  Future<List<Lesson>> getLessons() async {
    final db = await database;
    final result = await db.query('lessons', orderBy: 'orderIndex ASC');
    return result.map((map) => Lesson.fromMap(map)).toList();
  }

  Future<List<Lesson>> getLessonsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'lessons',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'orderIndex ASC',
    );
    return result.map((map) => Lesson.fromMap(map)).toList();
  }

  Future<Lesson?> getLesson(int id) async {
    final db = await database;
    final maps = await db.query(
      'lessons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Lesson.fromMap(maps.first);
    }
    return null;
  }

  // CRUD Operations for Questions
  Future<List<Question>> getQuestionsByLesson(int lessonId) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return result.map((map) => Question.fromMap(map)).toList();
  }

  // Get random questions by category (for quiz)
  Future<List<Question>> getQuestionsByCategory(String category, {int limit = 10}) async {
    final db = await database;
    
    // Get all lessons of this category
    final lessons = await db.query(
      'lessons',
      where: 'category = ?',
      whereArgs: [category],
    );
    
    if (lessons.isEmpty) return [];
    
    // Get lesson IDs
    final lessonIds = lessons.map((l) => l['id'] as int).toList();
    
    // Get all questions from these lessons
    final placeholders = lessonIds.map((_) => '?').join(',');
    final result = await db.query(
      'questions',
      where: 'lessonId IN ($placeholders)',
      whereArgs: lessonIds,
      orderBy: 'RANDOM()',
      limit: limit,
    );
    
    return result.map((map) => Question.fromMap(map)).toList();
  }

  // Get all unique categories with count
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    
    final result = await db.rawQuery('''
      SELECT 
        l.category,
        COUNT(DISTINCT l.id) as lessonCount,
        COUNT(q.id) as questionCount
      FROM lessons l
      LEFT JOIN questions q ON l.id = q.lessonId
      GROUP BY l.category
      ORDER BY l.orderIndex
    ''');
    
    return result;
  }

  // CRUD Operations for Challenges
  Future<List<Challenge>> getChallenges() async {
    final db = await database;
    final result = await db.query('challenges');
    return result.map((map) => Challenge.fromMap(map)).toList();
  }

  Future<int> updateChallenge(Challenge challenge) async {
    final db = await database;
    return await db.update(
      'challenges',
      challenge.toMap(),
      where: 'id = ?',
      whereArgs: [challenge.id],
    );
  }

  // CRUD Operations for Progress
  Future<int> insertProgress(Progress progress) async {
    final db = await database;
    return await db.insert('progress', progress.toMap());
  }

  Future<List<Progress>> getProgress() async {
    final db = await database;
    final result = await db.query('progress', orderBy: 'completedAt DESC');
    return result.map((map) => Progress.fromMap(map)).toList();
  }

  Future<int> getTotalPoints() async {
    final db = await database;
    
    // Points from lessons
    final progressResult = await db.rawQuery('SELECT SUM(score) as total FROM progress');
    final progressPoints = progressResult.first['total'] as int? ?? 0;
    
    // Points from completed challenges
    final challengeResult = await db.rawQuery('SELECT SUM(points) as total FROM challenges WHERE isCompleted = 1');
    final challengePoints = challengeResult.first['total'] as int? ?? 0;
    
    // Points from games
    final gameResult = await db.rawQuery('SELECT SUM(score) as total FROM game_scores');
    final gamePoints = gameResult.first['total'] as int? ?? 0;
    
    return progressPoints + challengePoints + gamePoints;
  }

  Future<int> getCompletedLessonsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(DISTINCT lessonId) as count FROM progress');
    return result.first['count'] as int? ?? 0;
  }

  Future<int> getCompletedChallengesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM challenges WHERE isCompleted = 1');
    return result.first['count'] as int? ?? 0;
  }

  // CRUD Operations for Game Scores
  Future<int> insertGameScore(GameScore score) async {
    final db = await database;
    return await db.insert('game_scores', score.toMap());
  }

  Future<List<GameScore>> getGameScores(String gameName) async {
    final db = await database;
    final result = await db.query(
      'game_scores',
      where: 'gameName = ?',
      whereArgs: [gameName],
      orderBy: 'score DESC',
      limit: 10,
    );
    return result.map((map) => GameScore.fromMap(map)).toList();
  }

  Future<int?> getHighScore(String gameName) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MAX(score) as highScore FROM game_scores WHERE gameName = ?',
      [gameName],
    );
    return result.first['highScore'] as int?;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

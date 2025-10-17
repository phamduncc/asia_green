import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class EnergySaveGame extends StatefulWidget {
  const EnergySaveGame({super.key});

  @override
  State<EnergySaveGame> createState() => _EnergySaveGameState();
}

class _EnergySaveGameState extends State<EnergySaveGame> {
  int _score = 0;
  int _level = 1;
  int _timeLeft = 60;
  int _energySaved = 0;
  bool _isPlaying = false;
  Timer? _gameTimer;
  
  final List<ElectricalDevice> _devices = [];
  final Random _random = Random();

  // Danh sách thiết bị điện
  final List<Map<String, dynamic>> _deviceTypes = [
    {'name': 'Đèn', 'icon': '💡', 'energy': 10, 'color': Colors.yellow},
    {'name': 'Điều hòa', 'icon': '❄️', 'energy': 50, 'color': Colors.blue},
    {'name': 'Tivi', 'icon': '📺', 'energy': 30, 'color': Colors.purple},
    {'name': 'Quạt', 'icon': '🌀', 'energy': 15, 'color': Colors.cyan},
    {'name': 'Máy tính', 'icon': '💻', 'energy': 25, 'color': Colors.grey},
    {'name': 'Tủ lạnh', 'icon': '🧊', 'energy': 40, 'color': Colors.lightBlue},
    {'name': 'Bình nước nóng', 'icon': '🚿', 'energy': 35, 'color': Colors.orange},
    {'name': 'Máy giặt', 'icon': '👕', 'energy': 45, 'color': Colors.pink},
  ];

  @override
  void initState() {
    super.initState();
    _initDevices();
  }

  void _initDevices() {
    _devices.clear();
    // Tạo 6-8 thiết bị ngẫu nhiên
    int deviceCount = 6 + _random.nextInt(3);
    for (int i = 0; i < deviceCount; i++) {
      final deviceType = _deviceTypes[_random.nextInt(_deviceTypes.length)];
      _devices.add(ElectricalDevice(
        name: deviceType['name'],
        icon: deviceType['icon'],
        energy: deviceType['energy'],
        color: deviceType['color'],
        isOn: _random.nextBool(), // Một số đang bật, một số đang tắt
        shouldBeOff: _random.nextBool(), // Thiết bị nào cần tắt
      ));
    }
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _level = 1;
      _timeLeft = 60;
      _energySaved = 0;
      _isPlaying = true;
      _initDevices();
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎮 Trò chơi kết thúc!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Điểm số: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Năng lượng tiết kiệm: $_energySaved kWh',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              _getPerformanceMessage(),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('Chơi lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  String _getPerformanceMessage() {
    if (_score >= 500) {
      return '🌟 Xuất sắc! Bạn là chuyên gia tiết kiệm năng lượng!';
    } else if (_score >= 300) {
      return '👍 Tốt lắm! Tiếp tục phát huy nhé!';
    } else if (_score >= 150) {
      return '💪 Khá tốt! Còn nhiều điều để học hỏi!';
    } else {
      return '📚 Hãy đọc thêm về tiết kiệm năng lượng nhé!';
    }
  }

  void _toggleDevice(int index) {
    if (!_isPlaying) return;

    setState(() {
      final device = _devices[index];
      device.isOn = !device.isOn;

      // Tính điểm
      if (!device.isOn && device.shouldBeOff) {
        // Đúng: Tắt thiết bị cần tắt
        _score += 20 + device.energy;
        _energySaved += device.energy;
        _showFeedback('✅ Tốt lắm! +${20 + device.energy} điểm', Colors.green);
        device.shouldBeOff = false; // Đã hoàn thành
      } else if (device.isOn && !device.shouldBeOff) {
        // Đúng: Bật lại thiết bị cần dùng
        _score += 10;
        _showFeedback('✅ Đúng rồi! +10 điểm', Colors.blue);
      } else if (!device.isOn && !device.shouldBeOff) {
        // Sai: Tắt thiết bị đang cần dùng
        _score -= 15;
        _showFeedback('❌ Oops! Thiết bị này đang cần dùng!', Colors.red);
      } else if (device.isOn && device.shouldBeOff) {
        // Sai: Bật lại thiết bị cần tắt
        _score -= 10;
        _showFeedback('❌ Lãng phí điện! -10 điểm', Colors.orange);
      }

      // Kiểm tra xem đã hoàn thành level chưa
      if (_devices.where((d) => d.shouldBeOff).isEmpty && _isPlaying) {
        _levelComplete();
      }
    });
  }

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _levelComplete() {
    _gameTimer?.cancel();
    
    final bonus = (_timeLeft * 2) + (_level * 50);
    setState(() {
      _score += bonus;
      _level++;
      _timeLeft += 20; // Thêm thời gian cho level mới
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🎉 Hoàn thành Level $_level!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bonus: +$bonus điểm', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Tổng điểm: $_score', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initDevices();
              _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() {
                  _timeLeft--;
                  if (_timeLeft <= 0) {
                    _endGame();
                  }
                });
              });
            },
            child: const Text('Level tiếp theo'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Tiết kiệm Năng lượng'),
      ),
      body: _isPlaying ? _buildGameScreen() : _buildStartScreen(),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '⚡',
              style: TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tiết kiệm Năng lượng',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cách chơi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRule('💡', 'TẮT các thiết bị không cần dùng (viền đỏ)'),
                    _buildRule('✅', 'GIỮ NGUYÊN thiết bị đang cần dùng (viền xanh)'),
                    _buildRule('⚡', 'Tiết kiệm càng nhiều điện, điểm càng cao'),
                    _buildRule('⏱️', 'Hoàn thành nhanh để được bonus'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.play_arrow, size: 32),
                label: const Text(
                  'Bắt đầu',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRule(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Column(
      children: [
        _buildScoreBar(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              return _buildDeviceCard(_devices[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Điểm',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Level',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '$_level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Thời gian',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '${_timeLeft}s',
                      style: TextStyle(
                        color: _timeLeft <= 10 ? Colors.red : Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.yellow, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Đã tiết kiệm: $_energySaved kWh',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(ElectricalDevice device, int index) {
    final borderColor = device.shouldBeOff
        ? Colors.red
        : (device.isOn ? Colors.green : Colors.grey);

    return GestureDetector(
      onTap: () => _toggleDevice(index),
      child: Card(
        elevation: device.isOn ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: borderColor,
            width: device.shouldBeOff ? 3 : 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: device.isOn
                ? LinearGradient(
                    colors: [
                      device.color.withOpacity(0.2),
                      device.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: device.isOn ? null : Colors.grey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (device.isOn)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow.withOpacity(0.2),
                      ),
                    ),
                  Text(
                    device.icon,
                    style: TextStyle(
                      fontSize: 60,
                      color: device.isOn ? null : Colors.grey,
                    ),
                  ),
                  if (device.isOn)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                device.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: device.isOn ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${device.energy} kWh',
                style: TextStyle(
                  fontSize: 12,
                  color: device.isOn ? device.color : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: device.isOn ? Colors.green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  device.isOn ? 'ĐANG BẬT' : 'ĐÃ TẮT',
                  style: TextStyle(
                    fontSize: 10,
                    color: device.isOn ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ElectricalDevice {
  final String name;
  final String icon;
  final int energy;
  final Color color;
  bool isOn;
  bool shouldBeOff;

  ElectricalDevice({
    required this.name,
    required this.icon,
    required this.energy,
    required this.color,
    required this.isOn,
    required this.shouldBeOff,
  });
}

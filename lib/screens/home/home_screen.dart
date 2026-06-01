import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../customer/customer_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeTab(),
      _buildSearchTab(),
      const Center(child: Text("Tin tức")),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tra cứu"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Giao dịch"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Tin tức"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
        ],
      ),
    );
  }

  // --- TAB TRANG CHỦ (GIỐNG ẢNH BẠN GỬI) ---
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Header Blue với Thanh tìm kiếm (Giống ảnh trên cùng)
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            color: Colors.blue[500],
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.notifications_none, color: Colors.white, size: 28),
              ],
            ),
          ),

          // 2. Lưới các chức năng (6 nút - Giống ảnh)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildGridItem(Icons.calendar_today, "Lịch ghi thu", Colors.blue),
                _buildGridItem(Icons.description_outlined, "Hóa đơn", Colors.green),
                _buildGridItem(Icons.speed, "Chỉ số tiêu thụ", Colors.purple),
                _buildGridItem(Icons.trending_up, "Tiến độ dịch vụ", Colors.orange),
                _buildGridItem(Icons.history, "Lịch sử thanh toán", Colors.blueGrey),
                _buildGridItem(Icons.bar_chart, "Lượng nước dùng", Colors.cyan),
              ],
            ),
          ),

          // 3. Biểu đồ tiêu thụ (Giống ảnh)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Lượng nước dùng (m³)", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      maxY: 15,
                      barGroups: [
                        _makeGroupData(0, 6),
                        _makeGroupData(1, 12),
                        _makeGroupData(2, 13),
                        _makeGroupData(3, 11),
                        _makeGroupData(4, 8),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['08/06', '09/06', '10/06', '11/06', '12/06'];
                              return Text(days[value.toInt()], style: const TextStyle(fontSize: 9));
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ChartLegend(color: Colors.blue, text: "Thấp điểm"),
                    SizedBox(width: 10),
                    _ChartLegend(color: Colors.amber, text: "Bình thường"),
                  ],
                )
              ],
            ),
          ),

          // 4. Banner ƯỚC TÍNH (Giống ảnh cuối cùng)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Thông tin", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "ƯỚC TÍNH",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- TAB TÌM KIẾM KHÁCH HÀNG (DÙNG LẠI CODE CŨ) ---
  Widget _buildSearchTab() {
    return const CustomerListScreen();
  }

  Widget _buildGridItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.amber,
          width: 12,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String text;
  const _ChartLegend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

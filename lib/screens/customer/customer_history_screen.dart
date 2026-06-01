import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/billing_service.dart';
import '../../models/bill.dart';

/// Màn hình hiển thị lịch sử tiêu thụ và hóa đơn của một khách hàng cụ thể
class CustomerHistoryScreen extends StatelessWidget {
  final Customer customer;

  const CustomerHistoryScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách lịch sử hóa đơn từ service theo ID khách hàng
    final history = BillingService.getHistory(customer.id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử: ${customer.name}"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần thông tin tóm tắt khách hàng
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mã KH: ${customer.code}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Địa chỉ: ${customer.address}"),
                    ],
                  ),
                ],
              ),
            ),
            
            // Phần Biểu đồ
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Biểu đồ tiêu thụ (m³)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: LineChart(
                mainData(history), // Gọi hàm vẽ biểu đồ
              ),
            ),

            // Phần Danh sách hóa đơn chi tiết
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Lịch sử hóa đơn chi tiết",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                // Đảo ngược danh sách để hiển thị hóa đơn mới nhất lên đầu
                final bill = history[history.length - 1 - index]; 
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Icon(Icons.water_drop, color: Colors.blue),
                    ),
                    title: Text("Tháng ${bill.month.month}/${bill.month.year}"),
                    subtitle: Text("Chỉ số: ${bill.oldReading} -> ${bill.newReading} (${bill.consumption} m³)"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bill.isPaid ? "Đã thanh toán" : "Chưa thanh toán", 
                          style: TextStyle(
                            color: bill.isPaid ? Colors.green : Colors.red, 
                            fontSize: 12
                          )
                        ),
                        Text(
                          "${bill.totalAmount.toStringAsFixed(0)}đ", 
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm cấu hình dữ liệu cho biểu đồ LineChart
  LineChartData mainData(List<Bill> history) {
    // Chuyển đổi dữ liệu hóa đơn thành các điểm (spots) trên biểu đồ
    List<FlSpot> spots = [];
    for (int i = 0; i < history.length; i++) {
      spots.add(FlSpot(i.toDouble(), history[i].consumption.toDouble()));
    }

    // Tính toán giá trị Y lớn nhất để biểu đồ cân đối
    double maxY = 10;
    for (var bill in history) {
      if (bill.consumption > maxY) maxY = bill.consumption.toDouble() + 5;
    }

    return LineChartData(
      gridData: const FlGridData(show: true, drawVerticalLine: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              // Hiển thị tháng (Vd: T10, T11...) ở trục X
              if (value.toInt() >= 0 && value.toInt() < history.length) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    "T${history[value.toInt()].month.month}", 
                    style: const TextStyle(fontSize: 10)
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            getTitlesWidget: (value, meta) {
              // Hiển thị khối lượng nước ở trục Y
              return Text("${value.toInt()}m³", style: const TextStyle(fontSize: 10));
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true, 
        border: Border.all(color: const Color(0xff37434d), width: 1)
      ),
      minX: 0,
      maxX: (history.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true, // Làm mượt đường kẻ
          gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true), // Hiển thị các điểm dữ liệu
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3), 
                Colors.cyan.withOpacity(0.3)
              ]
            ),
          ),
        ),
      ],
    );
  }
}

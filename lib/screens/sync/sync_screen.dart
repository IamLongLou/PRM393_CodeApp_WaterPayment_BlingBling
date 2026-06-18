import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sync_provider.dart';

/// Màn hình đồng bộ dữ liệu hóa đơn lên Server
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});
  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  void initState() {
    super.initState();
    // Tải danh sách các hóa đơn chưa đồng bộ ngay khi vào màn hình
    Future.microtask(() => context.read<SyncProvider>().fetchUnsyncedBills());
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ SyncProvider
    final syncProvider = context.watch<SyncProvider>();
    final bills = syncProvider.unsyncedBills;

    return Scaffold(
      appBar: AppBar(title: const Text('Đồng bộ dữ liệu')),
      body: Column(
        children: [
          // Banner thông báo số lượng hóa đơn chờ gửi đi
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.blue.withOpacity(0.1),
            child: Text(
              'Có ${bills.length} hóa đơn chờ đồng bộ.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Danh sách các hóa đơn chờ đồng bộ
          Expanded(
            child: bills.isEmpty 
              ? const Center(child: Text('Không có hóa đơn nào chờ đồng bộ.'))
              : ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: const Icon(Icons.description_outlined, color: Colors.orange),
                    title: Text('Mã HĐ: ${bills[i].billCode}'),
                    subtitle: Text('Khách hàng: ${bills[i].customerName}'),
                    trailing: const Text('Chưa gửi', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
          ),
          // Nút bấm thực hiện đồng bộ
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: syncProvider.isSyncing || bills.isEmpty 
                  ? null 
                  : () => syncProvider.syncAll(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300]
                ),
                child: syncProvider.isSyncing 
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 15),
                        Text('Đang gửi dữ liệu...')
                      ],
                    )
                  : const Text('ĐỒNG BỘ NGAY'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

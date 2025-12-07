import 'package:crm/features/hr/models/employee_model.dart';
import 'package:crm/features/hr/models/leave_request_model.dart';
import 'package:crm/features/hr/screens/add_employee_screen.dart';
import 'package:crm/features/hr/screens/request_leave_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HrHomeScreen extends StatefulWidget {
  const HrHomeScreen({super.key});

  @override
  State<HrHomeScreen> createState() => _HrHomeScreenState();
}

class _HrHomeScreenState extends State<HrHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EmployeeModel? _currentEmployee;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCurrentEmployee();
  }

  Future<void> _fetchCurrentEmployee() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('employees')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            _currentEmployee = EmployeeModel.fromMap(
              snapshot.docs.first.data(),
              snapshot.docs.first.id,
            );
            _isLoading = false;
          });
        } else {
          // Eğer çalışan kaydı yoksa (Sadece Auth varsa), admin gibi davranmasın, yüklemeyi bitirsin
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınamadı: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Admin/Manager Action: Update Leave Status
  Future<void> _updateLeaveStatus(String docId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('leave_requests')
          .doc(docId)
          .update({'status': status});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Talep ${status == 'Approved' ? 'Onaylandı' : 'Reddedildi'}',
            ),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  // Akıllı Sorgu Oluşturucu
  Stream<QuerySnapshot> _getLeaveRequestsStream() {
    final collection = FirebaseFirestore.instance.collection('leave_requests');

    if (_currentEmployee == null) {
      // Çalışan kaydı yoksa boş liste dönsün (Güvenlik)
      // Ancak admin kullanıcısı manuel eklenmemiş olabilir, bu durumda tümünü görsün mü?
      // Senaryo: Eğer db'de employee kaydı yoksa muhtemelen yeni admindir.
      // Şimdilik sadece Admin ise tümünü görsün diyemiyoruz çünkü rolü db'den alıyoruz.
      // Bu yüzden varsayılan olarak boş döneceğiz.
      // HATA ALMAMAK İÇİN boş stream dönüyoruz:
      return collection
          .where(FieldPath.documentId, isEqualTo: 'null')
          .snapshots();
    }

    if (_currentEmployee!.role == 'Admin') {
      return collection.snapshots();
    } else if (_currentEmployee!.role == 'Manager') {
      // Yönetici sadece KENDİNE BAĞLI olanları görür
      // Ancak kendi izinlerini de görmek isteyebilir?
      // Tasarım: "Sadece managerId'si kendisi olan (kendisine bağlı) personellerin bekleyen taleplerini görsün."
      // Bu durumda kendi taleplerini göremeyecek mi?
      // "Sekme 2: İzin Yönetimi" dediğimiz için bu 'Yönetim' ekranı.
      // "İzin Taleplerim" diye ayrı bir sekme yok.
      // O zaman şöyle yapalım: Manager, kendisine bağlı olanları VEYA kendi taleplerini görsün.
      // Firestore'da OR sorgusu kısıtlıdır. Şimdilik sadece kendine bağlı olanları gösterelim.
      return collection
          .where('managerId', isEqualTo: _currentEmployee!.id)
          .snapshots();
    } else {
      // Staff sadece kendi taleplerini görür
      // Staff'ın id'sini "employeeId" alanında arıyoruz
      return collection
          .where('employeeId', isEqualTo: _currentEmployee!.id)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('İK & Personel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Personel Listesi'),
            Tab(
              icon: Icon(Icons.event_note),
              text: 'İzin Yönetimi',
            ), // Changed text
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Personel Listesi
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('employees')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return const Center(child: Text('Hata oluştu'));
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Kayıtlı personel yok'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final employee = EmployeeModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF000080,
                        ).withOpacity(0.1),
                        child: Text(
                          employee.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF000080),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        employee.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        // Changed to Column for manager name
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${employee.role} • ${employee.department}'),
                          if (employee.managerName != null &&
                              employee.managerName!.isNotEmpty)
                            Text(
                              'Yöneticisi: ${employee.managerName}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Detay sayfasına git (sonraki adım)
                      },
                    ),
                  );
                },
              );
            },
          ),

          // TAB 2: İzin Yönetimi (Akıllı Filtreli) // Changed comment
          StreamBuilder<QuerySnapshot>(
            stream: _getLeaveRequestsStream(), // Changed stream source
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // Added curly braces
                return Center(
                  child: Text('Hata oluştu: ${snapshot.error}'),
                ); // Added error message
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Görüntülenecek izin talebi yok'),
                ); // Changed text
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final leave = LeaveRequestModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );
                  final dateFormat = DateFormat('dd/MM/yyyy');

                  Color statusColor = Colors.orange;
                  if (leave.status == 'Approved') statusColor = Colors.green;
                  if (leave.status == 'Rejected') statusColor = Colors.red;

                  // Onay Butonlarını Gösterme Yetkisi
                  // Admin veya (Manager VE Talep ona ait değilse)
                  // Eğer Manager kendi iznini görüyorsa onaylayamamalı.
                  // Ama şu anki sorguda Manager sadece kendine bağlı olanları görüyor.
                  // Yani güvenle butonları gösterebiliriz.
                  bool canApprove =
                      (_currentEmployee?.role == 'Admin' ||
                      _currentEmployee?.role ==
                          'Manager'); // Added canApprove logic

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leave.employeeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  leave.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${dateFormat.format(leave.startDate)} - ${dateFormat.format(leave.endDate)}',
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${leave.durationInDays} Gün)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tür: ${leave.type}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          if (leave.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('Not: ${leave.description}'),
                          ],

                          // Onay/Red Butonları (Sadece Pending ve Yetkili ise) // Changed comment
                          if (leave.status == 'Pending' && canApprove) ...[
                            // Added canApprove condition
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () =>
                                      _updateLeaveStatus(doc.id, 'Rejected'),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Reddet',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _updateLeaveStatus(doc.id, 'Approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Onayla'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showActionSheet(context);
        },
        backgroundColor: const Color(0xFF000080),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Yeni Personel Ekle'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEmployeeScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text('İzin Talebi Oluştur'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestLeaveScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

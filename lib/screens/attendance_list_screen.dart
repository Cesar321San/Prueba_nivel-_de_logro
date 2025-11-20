import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  String _selectedDate = 'Hoy';

  // Sample data
  final List<AttendanceRecord> _allRecords = [
    AttendanceRecord(
      id: '123456',
      name: 'Olivia Martinez',
      status: AttendanceStatus.present,
      checkInTime: '08:02 AM',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCyJ7loaaSj_BhVxmb6DRL8zZwXduWexZbVBAEVxC_FL1sYGA4SHjVV7ETIox-ZwXRu1uL1lSjN-zIoXrox1IZGddGDFLA4gyM1pmKU8A40C2YYn4Q5Zg0PBnF7WCnXCJl4JH4gj5zUIX8zT-f0eiyn99rWARvEB8oaRnpTw-hC64CpN8EB5pkC_crQy82wnp_2NT-pk2N_u6S7uSxoZU1L1qXZj8MsTIyvl_1DG6_9Aw4vIgIgqpDaSAIjMLEBND7U_aE-PYfhnWLw',
    ),
    AttendanceRecord(
      id: '789012',
      name: 'Benjamin Carter',
      status: AttendanceStatus.absent,
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_d5V3ds3I8-Rf_4dFnZgLaohHGMIWhKBxjRoYyPR7fsEtCK4E7juywEW8HHcJJALVNuvt_FRCAoB4WyBx2rcj5uEhsjtQdpEp7vZeYY3fLhURdaQyPtdQAVmPndx5nQq1clVnFnVXZL2sKXG8MS0xCw0TR6ImWw_sTj-g0nLT6Vj9UCq2iuIsupqpWl299l3abvp4K3ijgm8AA_qWVJJcgMgo2mDPFff1c84twnhXQS3Bo7WfeSyw0TEt4Pmgm68frnVE8iy4uNsC',
    ),
    AttendanceRecord(
      id: '345678',
      name: 'Sophia Lee',
      status: AttendanceStatus.late,
      checkInTime: '08:17 AM',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWLk_pPknO0phdRYCm-8c2BYF-sZCw75HdO-4fr1dP_JVmMwJTTl2eO7dF9v2nWkzWPH5fj_sHRiyURFRy2LMUQacO1lRsxMO3e8GsQVpjgtjcYJ7c5mK5iaQ4CyVhS6smwkkrnX-UdZiitOmJgsh_tt2h5ipovCwSon8hiudFbEtHDWYppYdzzpB465PoPBOFvuTrHkE3EtDli5_Y4ZznxwI4nUpb8-cCywCPKZwnQJtHHgHkDPKcSVIDm4cGIHsoQeuuKW-l7llt',
    ),
    AttendanceRecord(
      id: '901234',
      name: 'Ethan Rodriguez',
      status: AttendanceStatus.present,
      checkInTime: '07:58 AM',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAbbnwD14JUwWXoysAaTKdPQAPQOlYyDEp1KwVd5F2nJ9wp2qEeh2J6mlzxNRBcCpb9mpH8N5uNh_zJms9r8EWI9C_n7xcBJo95VII0C_PZsEzUW5mVBiIMbGLWDTHU5jFZHBrkAwvsvRzdIl_m8GopR5iyQYlG4lOfbXtEMssWorgmi-2QtKTnchiNj-j_51FpWYCe6MlNjpHztPECGU2XsmnK_8FNt4qGmNtIVQ4jdcoV2zdAxHDGFUswGmtk0ySmgicK8tnKuG5J',
    ),
  ];

  List<AttendanceRecord> get _filteredRecords {
    var records = _allRecords;

    // Filter by status
    if (_selectedFilter != 'Todos') {
      records = records.where((record) {
        switch (_selectedFilter) {
          case 'Presente':
            return record.status == AttendanceStatus.present;
          case 'Ausente':
            return record.status == AttendanceStatus.absent;
          case 'Tarde':
            return record.status == AttendanceStatus.late;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      records = records.where((record) {
        return record.name.toLowerCase().contains(query) ||
            record.id.contains(query);
      }).toList();
    }

    return records;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Fecha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Hoy'),
                onTap: () {
                  setState(() {
                    _selectedDate = 'Hoy';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Ayer'),
                onTap: () {
                  setState(() {
                    _selectedDate = 'Ayer';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Seleccionar fecha personalizada'),
                onTap: () async {
                  Navigator.pop(context);
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = '${date.day}/${date.month}/${date.year}';
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredRecords = _filteredRecords;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    color: isDark ? Colors.grey[200] : Colors.grey[800],
                  ),
                  const Expanded(
                    child: Text(
                      'Lista de Asistencia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Filters Section
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? AppColors.backgroundDark : Colors.white,
              child: Column(
                children: [
                  // Date Picker and Search Bar
                  Row(
                    children: [
                      InkWell(
                        onTap: _showDatePicker,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: isDark ? Colors.grey[200] : Colors.grey[800],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey[200] : Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.search,
                                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) => setState(() {}),
                                  decoration: InputDecoration(
                                    hintText: 'Buscar por nombre o ID...',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[100] : Colors.grey[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Todos',
                          isSelected: _selectedFilter == 'Todos',
                          onTap: () => setState(() => _selectedFilter = 'Todos'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Presente',
                          isSelected: _selectedFilter == 'Presente',
                          onTap: () => setState(() => _selectedFilter = 'Presente'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Ausente',
                          isSelected: _selectedFilter == 'Ausente',
                          onTap: () => setState(() => _selectedFilter = 'Ausente'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Tarde',
                          isSelected: _selectedFilter == 'Tarde',
                          onTap: () => setState(() => _selectedFilter = 'Tarde'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Attendance List
            Expanded(
              child: filteredRecords.isEmpty
                  ? _EmptyState(isDark: isDark)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredRecords.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _AttendanceListItem(
                          record: filteredRecords[index],
                          isDark: isDark,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new attendance record
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agregar nuevo registro'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[200] : Colors.grey[800]),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceListItem extends StatelessWidget {
  final AttendanceRecord record;
  final bool isDark;

  const _AttendanceListItem({
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(record.avatarUrl),
          ),
          const SizedBox(width: 16),

          // Name and ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[100] : Colors.grey[900],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${record.id}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Status Badge and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: record.status.backgroundColor(isDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.status.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: record.status.textColor(isDark),
                  ),
                ),
              ),
              if (record.checkInTime != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Entrada: ${record.checkInTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 40,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No se encontraron registros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[200] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta ajustar tus filtros o seleccionar\nuna fecha diferente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class AttendanceRecord {
  final String id;
  final String name;
  final AttendanceStatus status;
  final String? checkInTime;
  final String avatarUrl;

  AttendanceRecord({
    required this.id,
    required this.name,
    required this.status,
    this.checkInTime,
    required this.avatarUrl,
  });
}

enum AttendanceStatus {
  present,
  absent,
  late;

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Presente';
      case AttendanceStatus.absent:
        return 'Ausente';
      case AttendanceStatus.late:
        return 'Tarde';
    }
  }

  Color backgroundColor(bool isDark) {
    switch (this) {
      case AttendanceStatus.present:
        return isDark ? Colors.green[900]!.withOpacity(0.5) : Colors.green[100]!;
      case AttendanceStatus.absent:
        return isDark ? Colors.red[900]!.withOpacity(0.5) : Colors.red[100]!;
      case AttendanceStatus.late:
        return isDark ? Colors.yellow[900]!.withOpacity(0.5) : Colors.yellow[100]!;
    }
  }

  Color textColor(bool isDark) {
    switch (this) {
      case AttendanceStatus.present:
        return isDark ? Colors.green[300]! : Colors.green[700]!;
      case AttendanceStatus.absent:
        return isDark ? Colors.red[300]! : Colors.red[700]!;
      case AttendanceStatus.late:
        return isDark ? Colors.yellow[300]! : Colors.yellow[800]!;
    }
  }
}

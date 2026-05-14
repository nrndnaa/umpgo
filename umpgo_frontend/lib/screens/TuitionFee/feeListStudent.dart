import 'package:flutter/material.dart';
import 'package:umpgo_frontend/widgets/app_header.dart';
import 'package:umpgo_frontend/screens/TuitionFee/student_fee_detail_screen.dart';

// ── Model ────────────────────────────────────────────────────────────────────

class StudentFeeRecord {
  final int no;
  final String matricId;
  final String name;
  final String status; // "PAID" | "NO"
  final double balance;

  const StudentFeeRecord({
    required this.no,
    required this.matricId,
    required this.name,
    required this.status,
    required this.balance,
  });

  bool get isPaid => status.toUpperCase() == 'PAID';
  bool get isBlocked => status.toUpperCase() == 'NO';
}

// ── Screen ───────────────────────────────────────────────────────────────────

class ListOfSubjectScreen extends StatefulWidget {
  const ListOfSubjectScreen({super.key});

  @override
  State<ListOfSubjectScreen> createState() => _ListOfSubjectScreenState();
}

class _ListOfSubjectScreenState extends State<ListOfSubjectScreen> {
  // ── Theme colours (matches TreasuryDashboard) ──────────────────────────────
  static const Color primaryPurple = Color(0xFFD161E9);
  static const Color lightPurple = Color(0xFFE9ADFF);
  static const Color bgGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFF8EEFF); // very light purple-white

  // ── State ──────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 10;

  // ── Mock data (replace with API call) ─────────────────────────────────────
  final List<StudentFeeRecord> _allRecords = const [
    StudentFeeRecord(no: 1,  matricId: 'CB24053', name: 'BALQES BINTI HANAN', status: 'PAID', balance: 0),
    StudentFeeRecord(no: 2,  matricId: 'CB23045', name: 'NISHA A/P SURESH',   status: 'PAID', balance: 0),
    StudentFeeRecord(no: 3,  matricId: 'CB24013', name: 'ADAM BIN ALI',        status: 'NO',   balance: 500),
    StudentFeeRecord(no: 4,  matricId: 'CB23073', name: 'ALI BIN AZIM',        status: 'NO',   balance: 500),
    StudentFeeRecord(no: 5,  matricId: 'CB24013', name: 'AZMAN BIN AZLI',      status: 'NO',   balance: 500),
    StudentFeeRecord(no: 6,  matricId: 'CB23073', name: 'ALI BIN AZIM',        status: 'NO',   balance: 500),
  ];

  // ── Derived helpers ────────────────────────────────────────────────────────
  List<StudentFeeRecord> get _filtered {
    if (_searchQuery.isEmpty) return _allRecords;
    final q = _searchQuery.toLowerCase();
    return _allRecords
        .where((r) =>
            r.matricId.toLowerCase().contains(q) ||
            r.name.toLowerCase().contains(q))
        .toList();
  }

  List<StudentFeeRecord> get _paidList =>
      _filtered.where((r) => r.isPaid).toList();

  List<StudentFeeRecord> get _blockedList =>
      _filtered.where((r) => r.isBlocked).toList();

  int get _totalPages => (_filtered.length / _pageSize).ceil().clamp(1, 999);

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: const AppHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 12),
          Expanded(child: _buildTableCard()),
        ],
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  // ── Breadcrumb ─────────────────────────────────────────────────────────────
  Widget _buildBreadcrumb() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: primaryPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Menu > View Lists',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() {
            _searchQuery = v;
            _currentPage = 1;
          }),
          decoration: const InputDecoration(
            hintText: 'Matric ID',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // ── Main card with table ───────────────────────────────────────────────────
  Widget _buildTableCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Text(
              'Student list',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTableSection(records: _paidList, showAction: true),
                    if (_blockedList.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildSectionLabel('Blocked'),
                      _buildTableSection(records: _blockedList, showAction: false),
                    ],
                    const SizedBox(height: 12),
                    _buildPagination(),
                    const SizedBox(height: 10),
                    _buildSummaryRow(),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Table section (header + rows) ─────────────────────────────────────────
  Widget _buildTableSection({
    required List<StudentFeeRecord> records,
    required bool showAction,
  }) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(28),  // No.
        1: FixedColumnWidth(72),  // Matric ID
        2: FlexColumnWidth(),      // Name
        3: FixedColumnWidth(52),  // Status
        4: FixedColumnWidth(58),  // Balance
        5: FixedColumnWidth(42),  // Action
      },
      children: [
        _buildTableHeader(showAction: showAction),
        ...records.map((r) => _buildTableRow(r, showAction: showAction)),
      ],
    );
  }

  TableRow _buildTableHeader({required bool showAction}) {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54);
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12),
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      children: [
        _headerCell('No.',     style),
        _headerCell('Matric ID', style),
        _headerCell('Name',    style),
        _headerCell('Status',  style),
        _headerCell('Balance', style),
        _headerCell(showAction ? 'Action' : '', style),
      ],
    );
  }

  TableRow _buildTableRow(StudentFeeRecord r, {required bool showAction}) {
    const base = TextStyle(fontSize: 11, color: Colors.black87);
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      children: [
        _cell(Text('${r.no}.', style: base)),
        _cell(Text(r.matricId, style: base)),
        _cell(Text(r.name,     style: base)),
        _cell(_statusBadge(r.status)),
        _cell(Text(
          'RM${r.balance.toStringAsFixed(2)}',
          style: base,
        )),
        _cell(
          showAction
              ? _viewButton(r)
              : const Text('-', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _headerCell(String text, TextStyle style) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(text, style: style),
      );

  Widget _cell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: child,
      );

  Widget _statusBadge(String status) {
    final isPaid = status.toUpperCase() == 'PAID';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _viewButton(StudentFeeRecord r) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentFeeDetailScreen(
              detail: StudentFeeDetail(
                matricId: r.matricId,
                name: r.name,
                totalFee: 860.00,        // Replace with real API data
                paidAmount: 1860.00,     // Replace with real API data
                outstandingBalance: 0.00, // Replace with real API data
                date: '30/6/2026',       // Replace with real API data
                semester: '2 (2025/2026)', // Replace with real API data
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: primaryPurple,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'View',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // ── Pagination ─────────────────────────────────────────────────────────────
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageArrow(Icons.chevron_left, _currentPage > 1,
            () => setState(() => _currentPage--)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$_currentPage',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        _pageArrow(Icons.chevron_right, _currentPage < _totalPages,
            () => setState(() => _currentPage++)),
      ],
    );
  }

  Widget _pageArrow(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(icon, size: 22, color: enabled ? Colors.black87 : Colors.black26),
    );
  }

  // ── Summary row ───────────────────────────────────────────────────────────
  Widget _buildSummaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _summaryChip('Total', '${_filtered.length}'),
        const SizedBox(width: 10),
        _summaryChip('Paid',  '${_paidList.length}'),
        const SizedBox(width: 10),
        _summaryChip('Block', '${_blockedList.length}'),
      ],
    );
  }

  Widget _summaryChip(String label, String value) {
    return Row(
      children: [
        Text('$label ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  Widget _buildNav() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 30, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesScreen extends StatefulWidget {
  final String selectedLanguage;
  final VoidCallback? onBrowseProducts;

  const CoursesScreen({
    super.key,
    this.selectedLanguage = 'English',
    this.onBrowseProducts,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selectedCategory = 'All Courses';
  String _selectedLevel = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All Courses',
    'Embroidery',
    'Jewelry',
    'Pottery',
    'Weaving',
    'Handicrafts',
  ];

  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Traditional Embroidery Workshop',
      'description':
          'Learn the art of traditional embroidery techniques passed down through generations. Perfect for beginners who want to create...',
      'category': 'Embroidery',
      'level': 'Beginner',
      'levelColor': Color(0xFFD4EDDA),
      'levelTextColor': Color(0xFF3D8B5E),
      'duration': '4 weeks',
      'students': '6/10 students',
      'location': 'Lahore, Pakistan',
      'fee': 'Rs. 5,000',
      'instructor': 'Fatima Ahmed',
      'phone': '+923001234567',
    },
    {
      'title': 'Silver Jewelry Making',
      'description':
          'Master the craft of creating handmade silver jewelry. Learn techniques for working with silver wire, beads, and stones...',
      'category': 'Jewelry',
      'level': 'Intermediate',
      'levelColor': Color(0xFFFFF3CD),
      'levelTextColor': Color(0xFF856404),
      'duration': '6 weeks',
      'students': '4/8 students',
      'location': 'Karachi, Pakistan',
      'fee': 'Rs. 8,000',
      'instructor': 'Zainab Hussain',
      'phone': '+923001234568',
    },
    {
      'title': 'Clay Pottery Basics',
      'description':
          'Discover the ancient art of pottery making. From shaping clay to glazing and firing, create beautiful functional pieces...',
      'category': 'Pottery',
      'level': 'Beginner',
      'levelColor': Color(0xFFD4EDDA),
      'levelTextColor': Color(0xFF3D8B5E),
      'duration': '3 weeks',
      'students': '8/12 students',
      'location': 'Multan, Pakistan',
      'fee': 'Rs. 3,500',
      'instructor': 'Nadia Malik',
      'phone': '+923001234569',
    },
    {
      'title': 'Advanced Loom Weaving',
      'description':
          'Take your weaving skills to the next level. Create intricate patterns and work with different materials on a traditional loom...',
      'category': 'Weaving',
      'level': 'Advanced',
      'levelColor': Color(0xFFF8D7DA),
      'levelTextColor': Color(0xFF842029),
      'duration': '8 weeks',
      'students': '3/6 students',
      'location': 'Peshawar, Pakistan',
      'fee': 'Rs. 12,000',
      'instructor': 'Rukhsana Khan',
      'phone': '+923001234570',
    },
    {
      'title': 'Handmade Basket Weaving',
      'description':
          'Learn to weave beautiful baskets using natural materials. A relaxing and rewarding craft with practical everyday applications...',
      'category': 'Handicrafts',
      'level': 'Beginner',
      'levelColor': Color(0xFFD4EDDA),
      'levelTextColor': Color(0xFF3D8B5E),
      'duration': '2 weeks',
      'students': '5/10 students',
      'location': 'Quetta, Pakistan',
      'fee': 'Rs. 2,500',
      'instructor': 'Amna Bibi',
      'phone': '+923001234571',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    return _courses.where((c) {
      final matchCat = _selectedCategory == 'All Courses' ||
          c['category'] == _selectedCategory;
      final matchLevel =
          _selectedLevel == 'All' || c['level'] == _selectedLevel;
      final matchSearch = _searchQuery.isEmpty ||
          c['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          c['instructor']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          c['category']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchCat && matchLevel && matchSearch;
    }).toList();
  }

  Future<void> _registerViaWhatsApp(Map<String, dynamic> course) async {
    final msg = Uri.encodeComponent(
        'Hello! I would like to register for "${course['title']}" by ${course['instructor']}.\nFee: ${course['fee']}\nDuration: ${course['duration']}');
    final uri =
        Uri.parse('https://wa.me/${course['phone']}?text=$msg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilters(),
                    const SizedBox(height: 8),
                    filtered.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 24),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) =>
                                _buildCourseCard(filtered[i]),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF7A9B76),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training Courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Learn from skilled artisans',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              // Browse Products button
              GestureDetector(
                onTap: () {
                  if (widget.onBrowseProducts != null) {
                    widget.onBrowseProducts!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: const Text(
                    'Browse Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search courses...',
              hintStyle:
                  const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search,
                  color: Colors.grey, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: Colors.grey, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  // ── Filters ────────────────────────────────────────────────
  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          const Text('Category',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final sel = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? const Color(0xFF7A9B76)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? const Color(0xFF7A9B76)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        color: sel ? Colors.white : Colors.black54,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Skill Level label
          const Text('Skill Level',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _levels.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final lvl = _levels[i];
                final sel = lvl == _selectedLevel;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedLevel = lvl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? const Color(0xFF7A9B76)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? const Color(0xFF7A9B76)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      lvl,
                      style: TextStyle(
                        fontSize: 12,
                        color: sel ? Colors.white : Colors.black54,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Course Card ────────────────────────────────────────────
  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level badge + Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: course['levelColor'] as Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course['level'],
                  style: TextStyle(
                    fontSize: 11,
                    color: course['levelTextColor'] as Color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                course['category'],
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            course['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          // Description
          Text(
            course['description'],
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Info rows
          _infoRow(Icons.access_time_outlined, course['duration']),
          const SizedBox(height: 6),
          _infoRow(Icons.people_outline, course['students']),
          const SizedBox(height: 6),
          _infoRow(Icons.location_on_outlined, course['location']),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          // Fee + Register
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Fee',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course['fee'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A9B76),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'By ${course['instructor']}',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _registerViaWhatsApp(course),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A9B76),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  // ── Empty State ────────────────────────────────────────────
  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.school_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No courses found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
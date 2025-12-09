import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const StudyApp());
}

/// Global key untuk Scaffold di MainShell (supaya tombol ☰ bisa buka drawer)
final GlobalKey<ScaffoldState> mainShellScaffoldKey =
    GlobalKey<ScaffoldState>();

/// ROOT APP – Stateful supaya bisa ganti tema (light/dark)
class StudyApp extends StatefulWidget {
  const StudyApp({super.key});

  @override
  State<StudyApp> createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _handleThemeChanged(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseLight = ThemeData.light();
    final baseDark = ThemeData.dark();

    // THEME TERANG
    final lightTheme = baseLight.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      primaryColor: AppColors.primary,
      colorScheme: baseLight.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: const Color(0xFFF5F7FB),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(baseLight.textTheme),
      appBarTheme: baseLight.appBarTheme.copyWith(
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );

    // THEME GELAP
    final darkTheme = baseDark.copyWith(
      scaffoldBackgroundColor: const Color(0xFF10121A),
      primaryColor: AppColors.primary,
      cardColor: const Color(0xFF181A22),
      colorScheme: baseDark.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: const Color(0xFF10121A),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(baseDark.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: baseDark.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF10121A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: MainShell(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _handleThemeChanged,
      ),
    );
  }
}

// ---------------------------------------------------------
// COLORS & COMMONS
// ---------------------------------------------------------

class AppColors {
  static const primary = Color(0xFF3B8BFF);
  static const primaryLight = Color(0xFF63B0FF);
  static const accent = Color(0xFF4CD2FF);
  static const background = Color(0xFFF5F7FB);
  static const card = Colors.white;

  static const gradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const subtleShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const SectionHeader({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 2.5,
            height: 22,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onTap != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: const Icon(Icons.chevron_right),
            ),
        ],
      ),
    );
  }
}

class SubjectChipCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const SubjectChipCard({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? AppColors.primary : Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// MAIN SHELL WITH BOTTOM NAV + DRAWER
// ---------------------------------------------------------

class MainShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    PlannerScreen(),
    VideosScreen(),
    ProfileScreen(),
  ];

  final _pageTitles = const ['Home', 'Planner', 'Videos', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainShellScaffoldKey,
      drawer: CustomDrawer(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 18,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  label: 'Planner',
                  icon: Icons.calendar_month_outlined,
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
              ),
              const SizedBox(width: 64),
              Expanded(
                child: _BottomNavItem(
                  label: 'Videos',
                  icon: Icons.ondemand_video_outlined,
                  selected: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  label: 'Profile',
                  icon: Icons.person_outline,
                  selected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.gradient,
          boxShadow: AppColors.subtleShadow,
        ),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TestScreen()),
            );
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.fact_check_rounded, size: 30),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// HOME SCREEN
// ---------------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HomeHeader(),
            const SizedBox(height: 16),
            _buildSubjectsRow(),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Recommended Lectures'),
            _buildRecommendedList(),
            const SizedBox(height: 4),
            const SectionHeader(title: 'Revision Lectures'),
            _buildRevisionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsRow() {
    return SizedBox(
      height: 110,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: const [
          SubjectChipCard(label: 'Maths', icon: Icons.calculate_rounded),
          SubjectChipCard(label: 'Chemistry', icon: Icons.science_rounded),
          SubjectChipCard(label: 'Physics', icon: Icons.bolt_rounded),
          SubjectChipCard(label: 'Biology', icon: Icons.biotech_rounded),
        ],
      ),
    );
  }

  Widget _buildRecommendedList() {
    return SizedBox(
      height: 285,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: const [
          LectureCard(
            imageUrl: 'assets/stars.jpg',
            title: 'Stars – What are they made up of?',
            level: 'Beginner',
            minutes: 12,
          ),
          SizedBox(width: 16),
          LectureCard(
            imageUrl: 'assets/banana.jpg',
            title: 'Banana – Amino Acids and Proteins',
            level: 'Intermediate',
            minutes: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: const [
          SmallRevisionCard(
            title: 'Experiments with\nSodium Acetate',
            imageUrl: 'assets/sains.jpg',
          ),
          SizedBox(width: 16),
          SmallRevisionCard(
            title: 'Kinematics in a\nNutshell',
            imageUrl: 'assets/mobil.png',
          ),
          SizedBox(width: 16),
          SmallRevisionCard(
            title: 'Light & Optics\nRevision',
            imageUrl: 'assets/stars.jpg',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// HOME HEADER (dengan ikon ☰)
// ---------------------------------------------------------

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  mainShellScaffoldKey.currentState?.openDrawer();
                },
              ),
              const SizedBox(width: 4),
              Text(
                'Hi, Syahnabila.',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.subtleShadow,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// BIG LECTURE CARD
// ---------------------------------------------------------

class LectureCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String level;
  final int minutes;

  const LectureCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.level,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: imageUrl == null
                  ? Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.gradient,
                      ),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.nights_stay_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : (imageUrl!.startsWith('http')
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      level,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 2,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$minutes mins',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: AppColors.gradient,
                    ),
                    child: Center(
                      child: Text(
                        'Watch Lecture',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// SMALL REVISION CARD
// ---------------------------------------------------------

class SmallRevisionCard extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const SmallRevisionCard({
    super.key,
    required this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: imageUrl == null
                  ? Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.gradient,
                      ),
                    )
                  : (imageUrl!.startsWith('http')
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Beginner',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '10 mins',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// PLANNER SCREEN
// ---------------------------------------------------------

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HomeHeader(),
            const SizedBox(height: 18),
            const SectionHeader(title: 'Today\'s Work'),
            _todayWorkCard(context),
            const SectionHeader(title: 'Calendar'),
            _calendarCard(context),
          ],
        ),
      ),
    );
  }

  Widget _todayWorkCard(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    return Container(
      width: width,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: Image.asset(
                'assets/skateboard2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revision - Kinematics',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Includes two sub-topics\nAn MCQ test of 25 mins',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12 mins',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Beginner',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: AppColors.gradient,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          child: Center(
                            child: Text(
                              'Watch Lecture',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFEFF4FF),
                        ),
                        child: Center(
                          child: Text(
                            'Attempt Test',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarCard(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _calendarHeaderRow(),
                  const SizedBox(height: 6),
                  _weekDayRow(),
                  const SizedBox(height: 8),
                  Expanded(child: _calendarGrid()),
                  const SizedBox(height: 4),
                  _legendRow(),
                ],
              ),
            ),
          ),
          Container(
            width: 70,
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(22),
              ),
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'JULY',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.chevron_left_rounded, size: 22),
        Text(
          '2020',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Icon(Icons.chevron_right_rounded, size: 22),
      ],
    );
  }

  Widget _weekDayRow() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => Text(
              d,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _calendarGrid() {
    final numbers = [
      '',
      '',
      '',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
      '',
    ];

    const selectedDay = 22;

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: numbers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (_, i) {
        final n = numbers[i];
        if (n.isEmpty) return const SizedBox();
        final v = int.parse(n);
        final selected = v == selectedDay;
        return Container(
          decoration: selected
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradient,
                  boxShadow: AppColors.subtleShadow,
                )
              : const BoxDecoration(),
          child: Center(
            child: Text(
              n,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _legendRow() {
    Widget bullet(Color c) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c,
          ),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            bullet(AppColors.primary),
            const SizedBox(width: 4),
            _legendText('Physics'),
          ],
        ),
        Row(
          children: [
            bullet(Colors.pinkAccent),
            const SizedBox(width: 4),
            _legendText('Maths'),
          ],
        ),
        Row(
          children: [
            bullet(Colors.orangeAccent),
            const SizedBox(width: 4),
            _legendText('Chemistry'),
          ],
        ),
      ],
    );
  }

  Text _legendText(String label) => Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: Colors.grey.shade600,
        ),
      );
}

// ---------------------------------------------------------
// VIDEOS SCREEN
// ---------------------------------------------------------

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HomeHeader(),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Best of Physics'),
            _horizontalLectures(),
            const SectionHeader(title: 'Best of Chemistry'),
            _horizontalLectures(isChemistry: true),
          ],
        ),
      ),
    );
  }

  Widget _horizontalLectures({bool isChemistry = false}) {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          LectureCard(
            imageUrl: isChemistry ? 'assets/sains.jpg' : 'assets/stars.jpg',
            title: isChemistry
                ? 'Experiments with Sodium Acetate'
                : 'Stars – What are they made up of?',
            level: 'Beginner',
            minutes: 12,
          ),
          const SizedBox(width: 16),
          LectureCard(
            imageUrl: isChemistry ? 'assets/banana.jpg' : 'assets/mobil.png',
            title: isChemistry
                ? 'Banana – Amino Acids and Proteins'
                : 'Kinematics in a Nutshell',
            level: 'Intermediate',
            minutes: 14,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// DRAWER
// ---------------------------------------------------------

class CustomDrawer extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const CustomDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                title: Text(
                  'Syahnabila',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Student',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),
              _drawerItem(
                context,
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _drawerItem(
                context,
                icon: Icons.check_box_outlined,
                label: 'Todo',
              ),
              _drawerItem(
                context,
                icon: Icons.menu_book_rounded,
                label: 'Subjects',
              ),
              _drawerItem(
                context,
                icon: Icons.calendar_today_rounded,
                label: 'Schedule',
              ),
              _drawerItem(
                context,
                icon: Icons.forum_rounded,
                label: 'Forum',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForumScreen(),
                    ),
                  );
                },
              ),
              const Divider(
                indent: 24,
                endIndent: 80,
                color: Colors.white24,
              ),
              _drawerItem(
                context,
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.help_outline_rounded,
                label: 'Help',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpScreen(),
                    ),
                  );
                },
              ),
              const Spacer(),

              // TOGGLE DARK MODE
              ListTile(
                leading:
                    const Icon(Icons.dark_mode_rounded, color: Colors.white),
                title: Text(
                  'Dark mode',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  activeColor: Colors.white,
                  onChanged: onThemeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------
// HELP & SETTINGS (FAQ STYLE)
// ---------------------------------------------------------

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: const [
                FaqItem(title: 'How do you earn coins?'),
                FaqItem(title: 'How do you earn coins?'),
                FaqItem(title: 'How do you earn coins?'),
                FaqItem(title: 'How do you earn coins?'),
                FaqItem(title: 'How do you earn coins?'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Success leaves clues.\n'
                  'Study people you admire or want to be like.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: const [
          FaqItem(title: 'Log out'),
          FaqItem(title: 'Clear data'),
          FaqItem(title: 'Ad'),
          FaqItem(title: 'How do you earn coins?'),
          FaqItem(title: 'How do you earn coins?'),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String title;
  const FaqItem({super.key, required this.title});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.subtleShadow,
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFFF0F3FA),
          child: Icon(
            Icons.help_outline_rounded,
            size: 18,
            color: Colors.grey,
          ),
        ),
        trailing: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey.shade700,
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// FORUM SCREEN
// ---------------------------------------------------------

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = [
      {
        'title': 'Gimana cara gampang hafal rumus kinematika?',
        'subtitle': 'Physics · 23 replies · 10 mins ago',
        'tag': 'Kinematics'
      },
      {
        'title': 'Bedanya asam kuat sama asam lemah apa aja?',
        'subtitle': 'Chemistry · 12 replies · 1 hr ago',
        'tag': 'Acids & Bases'
      },
      {
        'title': 'Tips biar fokus belajar pas malam hari?',
        'subtitle': 'General · 40 replies · 3 hrs ago',
        'tag': 'Study tips'
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.gradient,
          boxShadow: AppColors.subtleShadow,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            // nanti bisa diarahkan ke halaman "New question"
          },
          child: const Icon(Icons.edit_rounded, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: threads.length,
        itemBuilder: (context, index) {
          final t = threads[index];
          return ForumThreadCard(
            title: t['title'] as String,
            subtitle: t['subtitle'] as String,
            tag: t['tag'] as String,
          );
        },
      ),
    );
  }
}

class ForumThreadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;

  const ForumThreadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tag_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.favorite_border_rounded,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// PROFILE SCREEN
// ---------------------------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek apakah bisa pop untuk ganti ikon saja
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            canPop ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
          ),
          onPressed: () async {
            // Coba pop dulu, kalau tidak bisa baru buka drawer
            final popped = await Navigator.of(context).maybePop();
            if (!popped) {
              mainShellScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _buildHeaderCard(context),
          const SizedBox(height: 20),
          _buildTagRow(context),
          const SizedBox(height: 24),
          _profileMenuTile(
            context,
            icon: Icons.help_outline_rounded,
            title: 'My questions',
          ),
          _profileMenuTile(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            title: 'My answers',
          ),
          _profileMenuTile(
            context,
            icon: Icons.event_available_rounded,
            title: 'My calendar',
          ),
          _profileMenuTile(
            context,
            icon: Icons.logout_rounded,
            title: 'Log out',
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // ---------- HEADER / KARTU PROFIL ATAS ----------

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        children: [
          // Avatar dengan ring gradient
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradient,
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Syahnabila',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Student · Science',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 14),

          // Stats: questions / answers / rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _profileStat('23', 'questions'),
              _verticalDivider(),
              _profileStat('89', 'answers'),
              _verticalDivider(),
              _profileStat('4.8', 'rating'),
            ],
          ),
          const SizedBox(height: 16),

          // Badge / info kecil di bawah stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Streak 5 days · Top learner',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 26,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.grey.shade300,
    );
  }

  Widget _profileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ---------- TAG / CHIP MINAT BELAJAR ----------

  Widget _buildTagRow(BuildContext context) {
    Widget chip(String label, IconData icon) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.subtleShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('Physics lover', Icons.bolt_rounded),
          chip('Chemistry', Icons.science_rounded),
          chip('Goal: top rank', Icons.flag_rounded),
        ],
      ),
    );
  }

  // ---------- MENU BAWAH (LIST TILE) ----------

  Widget _profileMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive ? Colors.redAccent : Colors.grey.shade900;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.subtleShadow,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFF0F3FA),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: Colors.grey.shade400,
        ),
        onTap: () {
          // nanti diisi kalau mau diarahkan ke halaman lain
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// TEST SCREEN (QUIZ)
// ---------------------------------------------------------

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = ['Kilolitre', 'Gram', 'Kilogram', 'Joule'];
    const selectedIndex = 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Test'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TestHeader(),
            const SizedBox(height: 24),
            Column(
              children: List.generate(options.length, (index) {
                final selected = index == selectedIndex;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == options.length - 1 ? 0 : 12,
                  ),
                  child: _OptionTile(
                    label: options[index],
                    selected: selected,
                  ),
                );
              }),
            ),
            const Spacer(),
            const Row(
              children: [
                Expanded(
                  child: _PrimaryButton(
                    label: 'Next',
                    icon: Icons.check_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SecondaryButton(
                    label: 'Skip question',
                    icon: Icons.pause_circle_outline_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TestHeader extends StatelessWidget {
  const _TestHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(26),
                boxShadow: AppColors.subtleShadow,
              ),
              padding: const EdgeInsets.only(
                top: 56,
                left: 24,
                right: 24,
                bottom: 18,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'What is the SI Unit of mass?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'from Mass, Force and Work',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: AppColors.subtleShadow,
              border: Border.all(
                color: AppColors.primary,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1:59',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'mins left',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;

  const _OptionTile({
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.subtleShadow,
        border: Border.all(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Checkbox(
            value: selected,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (_) {},
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PrimaryButton({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.subtleShadow,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SecondaryButton({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.subtleShadow,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

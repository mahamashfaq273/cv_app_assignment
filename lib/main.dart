import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maham Ashfaq CV',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6F91), // Vibrant Pink
          brightness: Brightness.dark,
          primary: const Color(0xFFFF6F91),
          secondary: const Color(0xFFD4A5FF),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        toolbarHeight: 90,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF6F91), width: 2),
              ),
              child: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/maham.png'),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Maham Ashfaq',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'Curriculum Vitae',
                  style: TextStyle(fontSize: 13, color: Color(0xFFFF6F91), fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 260,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFFF6F91),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: const [
                  Tab(text: 'Professional'),
                  Tab(text: 'Hobbies'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xFFFF6F91)),
            onPressed: () => _generatePDF(context),
            tooltip: 'Download CV',
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Stack(
        children: [
          const Background3DEffect(),
          TabBarView(
            controller: _tabController,
            children: [
              const ProfessionalTab(),
              const HobbiesTab(),
            ],
          ),
        ],
      ),
      floatingActionButton: const FloatingContactCard(),
    );
  }

  Future<void> _generatePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final pink = PdfColor.fromInt(0xFFFF6F91);
      
      // Load image from assets
      final ByteData bytes = await rootBundle.load('assets/images/maham.png');
      final Uint8List byteList = bytes.buffer.asUint8List();
      final pw.MemoryImage profileImage = pw.MemoryImage(byteList);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Maham Ashfaq', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: pink)),
                    pw.Text('Flutter Developer | Computer Science Student'),
                    pw.Text('Curriculum Vitae'),
                  ],
                ),
                pw.ClipOval(
                  child: pw.Image(profileImage, width: 70, height: 70, fit: pw.BoxFit.cover),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Professional Overview', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Divider(color: pink),
            pw.SizedBox(height: 5),
            pw.Text(
              'Creative and motivated Computer Science student skilled in Flutter, UI/UX design, and mobile app development. Passionate about building modern, interactive applications and exploring new technologies to bring ideas to life.',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Education', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Bullet(text: 'BS Computer Science - Comsats University Vehari (2024–2028)'),
            pw.SizedBox(height: 15),
            pw.Text('Technical Skills', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Bullet(text: 'Flutter, Dart, Firebase, Android Studio, Kotlin, UI/UX Design'),
            pw.SizedBox(height: 15),
            pw.Text('Work Experience', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Bullet(text: '2024: Student Developer (Built CGPA Calculator & Quiz apps)'),
            pw.Bullet(text: '2025: Freelance Developer (Created Flutter applications)'),
            pw.SizedBox(height: 15),
            pw.Text('Projects', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Bullet(text: 'CGPA Calculator App'),
            pw.Bullet(text: 'Lie Detector App'),
            pw.Bullet(text: 'Quiz Application'),
            pw.Bullet(text: 'Portfolio App'),
            pw.SizedBox(height: 25),
            pw.Divider(color: pink, thickness: 2),
            pw.Text('Contact Information', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: pink)),
            pw.Text('Phone: 03270022284'),
            pw.Text('Email: mahamashfaq273@gmail.com'),
            pw.Text('Instagram: imahumirza'),
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      debugPrint('Error generating PDF: $e');
    }
  }
}

class ProfessionalTab extends StatelessWidget {
  const ProfessionalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 140, left: 20, right: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GlassCard(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Professional Overview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF6F91)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Creative and motivated Computer Science student skilled in Flutter, UI/UX design, and mobile app development. Passionate about building modern, interactive applications and exploring new technologies to bring ideas to life.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedSkillCircle(label: 'Flutter', progress: 0.9, color: Color(0xFFFF6F91)),
                      AnimatedSkillCircle(label: 'Dart', progress: 0.85, color: Color(0xFFD4A5FF)),
                      AnimatedSkillCircle(label: 'UI/UX', progress: 0.8, color: Colors.pinkAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Education'),
          const GlassCard(
            child: ListTile(
              leading: Icon(Icons.school, color: Color(0xFFFF6F91), size: 30),
              title: Text('BS Computer Science', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Comsats University Vehari (2024–2028)'),
            ),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Technical Skills'),
          const GlassCard(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SkillChip(label: 'Flutter'),
                  SkillChip(label: 'Dart'),
                  SkillChip(label: 'Firebase'),
                  SkillChip(label: 'Android Studio'),
                  SkillChip(label: 'Kotlin'),
                  SkillChip(label: 'UI/UX Design'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Work Experience'),
          const TimelineItem(
            year: '2024',
            title: 'Student Developer',
            description: 'Built CGPA Calculator and Quiz apps',
            isLast: false,
          ),
          const TimelineItem(
            year: '2025',
            title: 'Freelance Developer',
            description: 'Created Flutter applications and portfolio projects',
            isLast: true,
          ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Featured Projects'),
          const Column(
            children: [
              ProjectCard(title: 'CGPA Calculator', icon: Icons.calculate),
              ProjectCard(title: 'Lie Detector', icon: Icons.fingerprint),
              ProjectCard(title: 'Quiz App', icon: Icons.quiz),
              ProjectCard(title: 'Portfolio App', icon: Icons.person_pin_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class HobbiesTab extends StatelessWidget {
  const HobbiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hobbies = [
      {
        'title': 'Photography',
        'icon': Icons.camera_alt_outlined,
        'color': const Color(0xFFFF6F91),
        'desc': 'Capturing life\'s precious moments through a creative lens. Specialized in portrait and street photography.',
        'skills': {'Creativity': 0.9, 'Technical': 0.8},
        'action': 'View Gallery',
      },
      {
        'title': 'Music',
        'icon': Icons.music_note_outlined,
        'color': const Color(0xFFD4A5FF),
        'desc': 'Music is my escape. I enjoy composing lo-fi beats and exploring diverse musical genres from around the world.',
        'skills': {'Ear Training': 0.85, 'Composition': 0.75},
        'action': 'Play Spotify',
      },
      {
        'title': 'Gaming',
        'icon': Icons.sports_esports_outlined,
        'color': Colors.pinkAccent,
        'desc': 'Competitive gamer at heart. I love strategic RPGs and FPS games that challenge my reflexes and teamwork.',
        'skills': {'Strategy': 0.92, 'Reflexes': 0.88},
        'action': 'Join Twitch',
      },
      {
        'title': 'Technology',
        'icon': Icons.biotech_outlined,
        'color': const Color(0xFFFF6F91),
        'desc': 'Constantly exploring the latest in AI, IoT, and mobile tech. Building side projects is my favorite weekend activity.',
        'skills': {'Curiosity': 0.98, 'Innovation': 0.9},
        'action': 'GitHub Pro',
      },
      {
        'title': 'Travel',
        'icon': Icons.map_outlined,
        'color': const Color(0xFFD4A5FF),
        'desc': 'Exploring new cultures and landscapes. Travel fuels my creativity and gives me a fresh perspective on design.',
        'skills': {'Adaptability': 0.95, 'Planning': 0.8},
        'action': 'Travel Blog',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 140, left: 20, right: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Hobbies & Interests'),
          const Text(
            'Beyond coding, I explore various creative outlets that fuel my innovation and provide a fresh perspective on problem-solving.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          ...hobbies.asMap().entries.map((entry) => HobbyInteractiveCard(hobby: entry.value, index: entry.key)).toList(),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Hobby Achievements / Certificates'),
          const GlassCard(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SkillChip(label: 'Best Portrait 2024'),
                  SkillChip(label: 'Spotify Playlist Curator'),
                  SkillChip(label: 'Global Tech Explorer'),
                  SkillChip(label: 'Gaming Tournament Finalist'),
                  SkillChip(label: 'UI Design Merit'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HobbyInteractiveCard extends StatefulWidget {
  final Map<String, dynamic> hobby;
  final int index;
  const HobbyInteractiveCard({super.key, required this.hobby, required this.index});

  @override
  State<HobbyInteractiveCard> createState() => _HobbyInteractiveCardState();
}

class _HobbyInteractiveCardState extends State<HobbyInteractiveCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + (widget.index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: GlassCard(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: widget.hobby['color'].withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: widget.hobby['color'].withOpacity(0.3)),
                              ),
                              child: Icon(widget.hobby['icon'], color: widget.hobby['color'], size: 28),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.hobby['title'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = LinearGradient(
                                          colors: [widget.hobby['color'], Colors.white],
                                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                    ),
                                  ),
                                  if (!_isExpanded)
                                    Text(
                                      widget.hobby['desc'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.white30,
                            ),
                          ],
                        ),
                        if (_isExpanded) ...[
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 15),
                          Text(
                            widget.hobby['desc'],
                            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: (widget.hobby['skills'] as Map<String, double>).entries.map((entry) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 11, color: Colors.white54),
                                      ),
                                      const SizedBox(height: 5),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: entry.value,
                                          backgroundColor: Colors.white12,
                                          valueColor: AlwaysStoppedAnimation<Color>(widget.hobby['color']),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [widget.hobby['color'], widget.hobby['color'].withOpacity(0.5)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.hobby['color'].withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.hobby['action'],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedSkillCircle extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  const AnimatedSkillCircle({super.key, required this.label, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 2),
                  tween: Tween<double>(begin: 0, end: progress),
                  builder: (context, double value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 5,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    );
                  },
                ),
              ),
              Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6F91).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFF6F91).withOpacity(0.3)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.white)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 5),
      child: Row(
        children: [
          Container(height: 18, width: 4, color: const Color(0xFFFF6F91)),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF6F91), letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final bool isLast;

  const TimelineItem({super.key, required this.year, required this.title, required this.description, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6F91),
                shape: BoxShape.circle,
              ),
              child: Text(year, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            if (!isLast) Container(width: 2, height: 65, color: const Color(0xFFFF6F91).withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 5),
              Text(description, style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.4)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const ProjectCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Icon(icon, size: 30, color: const Color(0xFFFF6F91)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
        ),
      ),
    );
  }
}

class Background3DEffect extends StatelessWidget {
  const Background3DEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF0F172A)),
        const MovingBlob(left: -50, top: 100, color: Color(0xFFFF6F91)),
        const MovingBlob(right: -80, bottom: 150, color: Color(0xFFD4A5FF)),
        const MovingBlob(left: 120, bottom: -50, color: Colors.pinkAccent),
      ],
    );
  }
}

class MovingBlob extends StatefulWidget {
  final double? left, top, right, bottom;
  final Color color;
  const MovingBlob({super.key, this.left, this.top, this.right, this.bottom, required this.color});

  @override
  State<MovingBlob> createState() => _MovingBlobState();
}

class _MovingBlobState extends State<MovingBlob> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 15), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.left != null ? widget.left! + (math.sin(_controller.value * math.pi) * 60) : null,
          top: widget.top != null ? widget.top! + (math.cos(_controller.value * math.pi) * 60) : null,
          right: widget.right != null ? widget.right! + (math.sin(_controller.value * math.pi) * 60) : null,
          bottom: widget.bottom != null ? widget.bottom! + (math.cos(_controller.value * math.pi) * 60) : null,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: widget.color.withOpacity(0.15), blurRadius: 100, spreadRadius: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FloatingContactCard extends StatefulWidget {
  const FloatingContactCard({super.key});

  @override
  State<FloatingContactCard> createState() => _FloatingContactCardState();
}

class _FloatingContactCardState extends State<FloatingContactCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isExpanded)
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: value,
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GlassCard(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: 260,
                        child: const Column(
                          children: [
                            ContactRow(icon: Icons.phone, text: '03270022284'),
                            Divider(color: Colors.white10),
                            ContactRow(icon: Icons.email, text: 'mahamashfaq273@gmail.com'),
                            Divider(color: Colors.white10),
                            ContactRow(icon: FontAwesomeIcons.instagram, text: 'imahumirza'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        FloatingActionButton.extended(
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          backgroundColor: const Color(0xFFFF6F91),
          label: Text(_isExpanded ? 'Close' : 'Contact Me', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: Icon(_isExpanded ? Icons.close : Icons.contact_page, color: Colors.white),
        ),
      ],
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const ContactRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFF6F91)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white))),
        ],
      ),
    );
  }
}

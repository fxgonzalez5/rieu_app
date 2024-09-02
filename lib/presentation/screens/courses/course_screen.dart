import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/views/views.dart';

class CourseScreen extends StatefulWidget {
  static const String name = 'course_screen';
  final String courseId;

  const CourseScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    final courseProvider = context.read<CourseProvider>();
    
    courseProvider.loadCourse(widget.courseId).whenComplete(
      () => courseProvider.fetchCourseStatus(
        user: context.read<UserProvider>().user,
        courseId: widget.courseId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) { 
    final responsive = Responsive(context);
    final courseProvider = context.watch<CourseProvider>();
    final course = courseProvider.coursesMap[widget.courseId];

    if (courseProvider.errorMessage.isNotEmpty) {
      return PopScope(
        onPopInvoked: (_) => courseProvider.errorMessage = '',
        child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(courseProvider.errorMessage),
          ),
        ),
      );
    }

    if (course == null) {
      return Scaffold(
        body: Center(
          child: Image(
            image: const AssetImage('assets/loaders/spin_loading.gif'),
            width: responsive.wp(15),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: _CourseBody(course: course),
    );
  }
}

class _CourseBody extends StatelessWidget {
  final Course course;
  
  const _CourseBody({required this.course});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final user = context.watch<UserProvider>().user;
    final status = context.watch<CourseProvider>().coursesStatusMap[course.id]!;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
          child: Column(
            children: [
              _BannerImage(image: course.posterPath),
              Padding(
                padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(1)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(course.name, style: texts.headlineSmall, textAlign: TextAlign.justify)
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: responsive.wp(12),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: course.instructors.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: responsive.wp(10)),
                    child: _InstructorPanel(
                      image: course.instructors[index].photoPath,
                      name: course.instructors[index].name,
                    ),
                  ),
                ),
              ),
              _OverviewSection(course),
              Expanded(
                child: _ContentTabs(
                  user: user,
                  course: course,
                  status: status,
                ),
              ),
            ],
          )
        ),

        if (status != CourseStatus.accepted && !user.isAdmin)
          _FloatingBox(status: status),
      ],
    );
  }
}

class _FloatingBox extends StatelessWidget {
  final CourseStatus status;
  
  const _FloatingBox({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final courseStatusData = context.read<CourseProvider>().getCourseStatusData(status);

    Color? colorButton() {
      switch (status) {
        case CourseStatus.available:
          return Theme.of(context).colorScheme.primary;
        case CourseStatus.pending:
          return Theme.of(context).colorScheme.secondary;
        case CourseStatus.canceled:
          return Theme.of(context).colorScheme.error;
        default:
          return null;
      }
    }

    return Container(
      height: responsive.hp(10),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ]
      ),
      child: Row(
        children: [
          Text(courseStatusData.text, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          if (status != CourseStatus.unavailable)
            FilledButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: responsive.wp(7.5), vertical: responsive.hp(1.5))),
                backgroundColor: WidgetStatePropertyAll(colorButton()),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: status != CourseStatus.available ? null : () {},
              child: Text(courseStatusData.textButton),
            ),
        ],
      ),
    );
  }
}

class _ContentTabs extends StatefulWidget {
  final UserEntity user;
  final Course course;
  final CourseStatus status;
  
  const _ContentTabs({
    required this.user,
    required this.course,
    required this.status,
  });

  @override
  State<_ContentTabs> createState() => _ContentTabsState();
}

class _ContentTabsState extends State<_ContentTabs> with TickerProviderStateMixin {
  late TabController tabController;
  late List<Widget> viewTabs = [];

  @override
  void initState() {
    super.initState();
    viewTabs = buildViewTabs();
    tabController = TabController(length: viewTabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<Widget> buildViewTabs() {
    return [
      DescriptionView(
        course: widget.course,
        isActive: widget.status != CourseStatus.accepted && !widget.user.isAdmin
      ),
      SectionView(
        course: widget.course,
        isActive: widget.status != CourseStatus.accepted && !widget.user.isAdmin
      ),
      const RegisterView(),
      HistoryView(courseId: widget.course.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = Theme.of(context).iconTheme;

    return Column(
      children: [
        TabBar(
          controller: tabController,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: (index) {
            if (index > viewTabs.length - 3 && widget.status != CourseStatus.accepted && !widget.user.isAdmin) {
              tabController.animateTo(tabController.previousIndex);
            }
          },
          tabs: [
            Tab(icon: Icon(Icons.article_outlined, size: iconTheme.size)),
            Tab(icon: Icon(Icons.list, size: iconTheme.size)),
            Tab(
              icon: Icon(Icons.app_registration_rounded, size: iconTheme.size,
                color: widget.status != CourseStatus.accepted && !widget.user.isAdmin
                  ? Colors.grey 
                  : null,
              ),
            ),
            Tab(
              icon: Icon(Icons.history, size: iconTheme.size,
                color: widget.status != CourseStatus.accepted && !widget.user.isAdmin
                  ? Colors.grey 
                  : null,
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: viewTabs,
          ),
        ),
      ],
    );
  }
}

class _OverviewSection extends StatelessWidget {
  final Course course;

  const _OverviewSection(this.course);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SizedBox(
      height: responsive.hp(12.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildRow(context, icon: Icons.apartment, leftText: course.location, rightText: course.modality),
          buildRow(context, icon: Icons.schedule, leftText: '${course.duration} horas', rightText: course.schedule),
          buildRow(context, icon: Icons.calendar_today_outlined, leftText: TextFormats.date(course.startDate), rightText: TextFormats.date(course.endDate)),
        ],
      ),
    );
  }

  Row buildRow(BuildContext context, {required IconData icon, required String leftText, required String rightText}) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: responsive.wp(2)),
        Text('$leftText  |  $rightText', style: texts.bodyLarge),
      ],
    );
  }
}

class _InstructorPanel extends StatelessWidget {
  final String image, name;

  const _InstructorPanel({
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: responsive.wp(5),
          backgroundColor: Colors.grey.shade100,
          child: Image.network(
            image,
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Image.asset('assets/loaders/ripple_loading.gif');
            },
          ),
        ),
        SizedBox(width: responsive.wp(2)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: texts.bodyLarge),
            Text('Instructor(a)', style: texts.bodyLarge!.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  final String image;

  const _BannerImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(responsive.ip(2)),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: FadeInImage.assetNetwork(
          width: double.infinity,
          height: responsive.hp(25),
          placeholderScale: 1.75,
          placeholderFit: BoxFit.none,
          fit: BoxFit.cover,
          placeholder: 'assets/loaders/light_bulb_loading.gif', 
          image: image,
        ),
      ),
    );
  }
}
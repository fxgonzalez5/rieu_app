import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/views/views.dart';

class CourseScreen extends StatelessWidget {
  static const String name = 'course_screen';
  final String courseId;

  const CourseScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: const _CourseBody(),
    );
  }
}

class _CourseBody extends StatelessWidget {
  final CourseStatus status = CourseStatus.accepted;
  
  const _CourseBody();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final user = context.read<AuthProvider>().state.user!;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
          child: Column(
            children: [
              const _BannerImage(image: 'https://via.placeholder.com/500/FF5500?text=Placeholder'),
              Padding(
                padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(1)),
                child: Text('Protección jurídica de activos intelectuales', style: texts.headlineSmall),
              ),
              const _InstructorPanel(
                image: 'https://via.placeholder.com/50',
                name: 'Diana Días Vega',
              ),
              SizedBox(height: responsive.hp(1)),
              const _OverviewSection(),
              Expanded(
                child: _ContentTabs(
                  user: user,
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
  final CourseStatus status;
  
  const _ContentTabs({
    required this.user,
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
      DescriptionView(isActive: widget.status != CourseStatus.accepted && !widget.user.isAdmin),
      SectionView(isActive: widget.status != CourseStatus.accepted && !widget.user.isAdmin),
      RegisterView(isAdmin: widget.user.isAdmin),
      HistoryView(isAdmin: widget.user.isAdmin),
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
  const _OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return SizedBox(
      height: responsive.hp(12.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Icon(Icons.apartment),
              Text('  Salas de formación  |  Presencial', style: texts.bodyLarge),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.schedule),
              Text('  40 horas  |  11h00 a 13h00', style: texts.bodyLarge),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined),
              Text('  16/07/2024  |  19/07/2024', style: texts.bodyLarge),
            ],
          ),
        ],
      ),
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
          radius: responsive.wp(6.5),
          backgroundColor: Colors.grey.shade100,
          foregroundImage: NetworkImage(image),
          child: Image.asset('assets/loaders/ripple_loading.gif'),
        ),
        SizedBox(width: responsive.wp(2)),
        Column(
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
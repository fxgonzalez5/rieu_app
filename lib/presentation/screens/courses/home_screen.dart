import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/views/views.dart';
import 'package:rieu/presentation/widgets/widgets.dart';


class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late PageController pageController;
  final viewRoutes = const [
    HomeView(),
    CoursesView()
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if ( pageController.hasClients ) {
      pageController.animateToPage(
        widget.pageIndex, 
        curve: Curves.easeInOut, 
        duration: const Duration(milliseconds: 350),
      );
    }

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewRoutes.length,
        itemBuilder: (context, index) {
          return index < 2
          ? Stack(
              children: [
                const BackgroundImages(),
                SafeArea(
                  child: Column(
                    children: [
                      const _Head(),
                      Expanded(
                        child: viewRoutes[index]
                      )
                    ],
                  )
                ),
              ]
            )
          : viewRoutes[index];
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: widget.pageIndex),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Head extends StatelessWidget {
  const _Head();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final coursesProvider = context.watch<CoursesProvider>();

    return Stack(
      children: [
        CustomFigure(
          color: colors.primary,
          scale: 2,
          expand: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: responsive.wp(5), left: responsive.wp(5), right: responsive.wp(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserInformation(),
                    SizedBox(height: responsive.ip(2)),
                    const CustomSearchBar(),
                  ],
                ),
              ),
              SizedBox(
                height: responsive.hp(3.5),
              ),
              CategoryFilter(
                categories: coursesProvider.categories,
                currentCategory: coursesProvider.categories.indexOf(coursesProvider.currentCategory),
                onTap: (value) => coursesProvider.currentCategory = value,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
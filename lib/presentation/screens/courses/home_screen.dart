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

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;
  final viewRoutes = const [
    HomeView(),
    CoursesView(),
    ProfileView(),
    InformationView()
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      initialPage: widget.pageIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if ( pageController.hasClients ) {
      if ((pageController.page! + 3 == widget.pageIndex) || (pageController.page! - 3 == widget.pageIndex)) {
        pageController.animateToPage(
          widget.pageIndex, 
          curve: Curves.easeInOut, 
          duration: const Duration(milliseconds: 500),
        );
      } else {
        pageController.animateToPage(
          widget.pageIndex, 
          curve: Curves.easeInOut, 
          duration: const Duration(milliseconds: 350),
        );
      }
    }

    return Scaffold(
      extendBody: true,
      body: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewRoutes.length,
        itemBuilder: (context, index) {
          if (index < 2) {
            return Stack(
              children: [
                const BackgroundImages(),
                SafeArea(
                  child: Column(
                    children: [
                      _Head(pageIndex: index),
                      SizedBox(height: responsive.hp(1.5)),
                      Expanded(
                        child: viewRoutes[index]
                      )
                    ],
                  )
                ),
              ]
            );
          } else {
            return viewRoutes[index];
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: widget.pageIndex),
    );
  }
}

class _Head extends StatelessWidget {
  final int pageIndex;

  const _Head({required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final coursesProvider = context.watch<CoursesProvider>();

    return CustomFigure(
      scale: 1,
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
                CustomSearchBar(searchCallback: () => coursesProvider.toggleCourseSearch(pageIndex)),
              ],
            ),
          ),
          SizedBox(height: responsive.hp(3.5)),
          CategoryFilter(
            categories: coursesProvider.categories,
            currentCategory: coursesProvider.categories.indexOf(coursesProvider.currentCategory),
            onTap: (value) => coursesProvider.fetchCoursesByCategory(value, pageIndex),
          ),
        ],
      ),
    );
  }
}
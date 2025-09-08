import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poster/db_poster/db_poster.dart';
import 'package:poster/pages/poster_first/free_puzzle/free_puzzle_binding.dart';
import 'package:poster/pages/poster_first/free_puzzle/free_puzzle_view.dart';
import 'package:poster/pages/poster_first/long_image_splicing_details/long_image_splicing_details_binding.dart';
import 'package:poster/pages/poster_first/long_image_splicing_details/long_image_splicing_details_view.dart';
import 'package:poster/pages/poster_first/poster_first_binding.dart';
import 'package:poster/pages/poster_first/poster_first_view.dart';
import 'package:poster/pages/poster_first/template_puzzle/template_puzzle_binding.dart';
import 'package:poster/pages/poster_first/template_puzzle/template_puzzle_view.dart';
import 'package:poster/pages/poster_second/poster_second_binding.dart';
import 'package:poster/pages/poster_second/poster_second_details/poster_second_details_binding.dart';
import 'package:poster/pages/poster_second/poster_second_details/poster_second_details_view.dart';
import 'package:poster/pages/poster_second/poster_second_view.dart';
import 'package:poster/pages/poster_tab/poster_tab_binding.dart';
import 'package:poster/pages/poster_tab/poster_tab_view.dart';
import 'package:poster/pages/poster_third/poster_third_binding.dart';
import 'package:poster/pages/poster_third/poster_third_view.dart';

Color primaryColor = const Color(0xffff55a3);
Color bgColor = const Color(0xfff7f7f7);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() => DBPoster().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Flash,
      initialRoute: '/poster_tab',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primaryColor,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
            backgroundColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
List<GetPage<dynamic>> Flash = [
  GetPage(
      name: '/poster_tab',
      page: () => PosterTabPage(),
      binding: PosterTabBinding()),
  GetPage(
      name: '/poster_first',
      page: () => PosterFirstPage(),
      binding: PosterFirstBinding()),
  GetPage(
      name: '/poster_second',
      page: () => PosterSecondPage(),
      binding: PosterSecondBinding()),
  GetPage(
      name: '/poster_third',
      page: () => PosterThirdPage(),
      binding: PosterThirdBinding()),
  GetPage(
      name: '/poster_second_details',
      page: () => PosterSecondDetailsPage(),
      binding: PosterSecondDetailsBinding()),
  GetPage(
      name: '/long_image_splicing_details',
      page: () => LongImageSplicingDetailsPage(),
      binding: LongImageSplicingDetailsBinding()),
  GetPage(
      name: '/free_puzzle',
      page: () => FreePuzzleWidget(),
      binding: FreePuzzleBinding()),
  GetPage(
      name: '/template_puzzle',
      page: () => TemplatePuzzleWidget(),
      binding: TemplatePuzzleBinding()),
];
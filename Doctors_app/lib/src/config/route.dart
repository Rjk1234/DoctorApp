import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/pages/detail_page.dart';
import 'package:flutter_healthcare_app/src/pages/home_page.dart';
import 'package:flutter_healthcare_app/src/pages/splash_page.dart';
import 'package:flutter_healthcare_app/src/widgets/coustom_route.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => SplashPage(),
      '/HomePage': (_) => HomePage(),
    };
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String>? pathElements = settings.name?.split('/');
    if (pathElements == null) {
       return null;
    }
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "DetailPage":
        return  CustomRoute(builder: (BuildContext context) => DetailPage(model: settings.arguments as DoctorModel,), settings: settings);
        // CustomRoute<bool>(
        //     builder: (BuildContext context) => DetailPage(model: settings.arguments,));
    }
  }
}

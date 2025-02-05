import 'package:flutter/material.dart';
import 'package:pokedex_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
 
class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GlobalAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(themeProvider.themeData.brightness == Brightness.dark
              ? Icons.wb_sunny
              : Icons.nights_stay),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

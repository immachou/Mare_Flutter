import 'package:flutter/material.dart';

import '../../utils/color.dart';
import '../../utils/text_style.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final bool showDrawer;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = true,
    this.actions,
    this.showDrawer = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: Border(bottom: BorderSide(color: AppColors.borderLight)),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        children: [
          if (showLogo) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                // appliquer la bordure en bas
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mare™',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      actions: actions ??
          [
            if (showDrawer)
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: AppColors.textPrimary,
              ),
          ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransparentDetailsPage extends StatelessWidget {
  static String routeName = '/transparent-page';

  final String? title, details;
  TransparentDetailsPage([this.title, this.details]);

  @override
  Widget build(BuildContext context) {
    if (title == null)
      return Scaffold(
        body: Center(
          child: Text('something wnet wrong'),
        ),
      );

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.85,
      ), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.translucent,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _buildDetailsWidget(context)),
      ),
    );
  }

  Widget _buildDetailsWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            title!,
            style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
        ),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              details!.isEmpty || details == null
                  ? AppLocalizations.of(context)!.noDetails
                  : details!,
              style: TextStyle(color: Colors.yellow),
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: 10,
            ),
          ),
        )
      ],
    );
  }
}

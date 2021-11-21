import 'package:flutter/Material.dart';

class DetailsDialog {
  static Future<dynamic> test(
      BuildContext context, String title, String desciption) async {
    return showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: desciption.length < 100 ? 100 : 250,
          height: desciption.length < 100 ? 100 : 200,
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.yellow,
                    height: 1.5,
                    decoration: TextDecoration.underline,
                    shadows: [
                      Shadow(
                        color: Colors.grey.shade50,
                        offset: Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (desciption.length < 1)
                  TextSpan(
                    text: '\n no details provided ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                if (desciption.length >= 1)
                  TextSpan(
                    text: '\n$desciption',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<dynamic> descriptionDialog(
      BuildContext context, String title, String desciption) async {
    return showGeneralDialog(
      useRootNavigator: true,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      context: context,
      pageBuilder: (ctx, _, p) => Dialog(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        child: GestureDetector(
          key: UniqueKey(),
          //on tap didn't work without this line
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.of(ctx).pop(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
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
                      desciption,
                      style: TextStyle(color: Colors.yellow),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      maxLines: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

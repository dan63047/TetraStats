import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/text_shadow.dart';

const int length = 25;
final TextEditingController controller = TextEditingController();

class SearchBox extends StatefulWidget {
  final Function onSubmit;
  final bool bigScreen;
  const SearchBox({required this.onSubmit, required this.bigScreen, super.key});

  @override
  State<StatefulWidget> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox>{
  late FocusNode textbotFocus;

  @override
  void initState() {
    textbotFocus = FocusNode();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose(){
    controller.clear(); 
    textbotFocus.dispose();
    super.dispose();
  }

  Color getColorOfCounter(){
    // if limit was hit
    if ((length - controller.text.length) <= 0) return Colors.redAccent;
    // if input more than 16 symbols (username length limit)
    if ((length - controller.text.length) < 9) return Colors.yellowAccent;
    // if we good (we not)
    return Colors.grey;
  }

  double getFontSizeOfCounter(){
    return (length - controller.text.length) <= 0 ? 24 : 16;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      //alignment: Alignment.centerRight,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLength: length,
            focusNode: textbotFocus,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              counter: const Offstage(),
              hintText: widget.bigScreen ? t.searchHint : null,
            ),
            style: const TextStyle(shadows: textShadow, fontSize: 18),
            onSubmitted: (String value) {
              widget.onSubmit(value);
              textbotFocus.unfocus();
            },
          ),
        ),
        AnimatedDefaultTextStyle(
          style: TextStyle(
            fontFamily: "Eurostile Round",
            fontSize: getFontSizeOfCounter(),
            color: getColorOfCounter(),
            shadows: textShadow
          ),
          duration: Durations.short4,
          curve: Curves.easeOutCirc,
          child: Text("${length - controller.text.length}")
        )
      ]
    );
  } 
}
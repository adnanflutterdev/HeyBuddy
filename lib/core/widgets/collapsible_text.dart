import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';

class CollapsibleText extends StatefulWidget {
  const CollapsibleText({
    super.key,
    required this.text,
    this.style,
    this.maxLength = 100,
  });

  final String text;
  final TextStyle? style;
  final int maxLength;

  @override
  State<CollapsibleText> createState() => _CollapsibleTextState();
}

class _CollapsibleTextState extends State<CollapsibleText> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final isLongText = widget.text.length > widget.maxLength;

    final displayText = (!_isCollapsed || !isLongText)
        ? widget.text
        : widget.text.substring(0, widget.maxLength);

    return AnimatedSize(
      alignment: .topCenter,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: RichText(
        text: TextSpan(
          style: widget.style ?? context.style.b3,
          children: [
            TextSpan(text: displayText),
            if (isLongText)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  child: Text(
                    _isCollapsed ? " ...more" : " less",
                    style: context.style.b3.copyWith(
                      color: Colors.blue,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

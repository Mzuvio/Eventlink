import 'package:flutter/material.dart';
import 'package:transitease_app/utils/colors.dart';

class Toggletextfield extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController textController;
  final int maxLines;
  final double height;
  final bool? isDate;
  final bool? isTime;

  const Toggletextfield({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.textController,
    this.maxLines = 1,
    this.height = 50,
    this.isDate,
    this.isTime,
  });

  @override
  State<Toggletextfield> createState() => _ToggletextfieldState();
}

class _ToggletextfieldState extends State<Toggletextfield> {
  bool _isEditing = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.textController.text = picked.toIso8601String();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
       builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.textController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? Container(
            height: widget.height,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, -1),
                blurRadius: 20,
              ),
            ]),
            child: TextField(
              controller: widget.textController,
              maxLines: widget.maxLines,
              onSubmitted: (value) {
                setState(() {
                  _isEditing = false;
                });
              },
              cursorColor: mediumGrey,
              decoration: InputDecoration(
                prefixIcon: widget.isDate == true
                    ? IconButton(
                        icon: const Icon(Icons.date_range_outlined),
                        onPressed: () => _selectDate(context),
                      )
                    : (widget.isTime == true
                        ? IconButton(
                            icon: const Icon(Icons.access_time_outlined),
                            onPressed: () => _selectTime(context),
                          )
                        : null),
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xff28bca1).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: jetBlack,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.textController.text.isEmpty
                        ? widget.label
                        : widget.textController.text,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          );
  }
}

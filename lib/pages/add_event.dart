import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/my_dropdown_menu.dart';
import 'package:transitease_app/components/small_button.dart';
import 'package:transitease_app/components/toggle_dropdown.dart';
import 'package:transitease_app/components/toggletextfield.dart';
import 'package:transitease_app/models/category.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/providers/category_provider.dart';

class AddEvent extends StatefulWidget {
  final Event? event;
  const AddEvent({super.key, this.event});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Category? _selectedCategory;

  String? _titleError;
  String? _descriptionError;
  String? _dateError;
  String? _timeError;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.initializeUser();

      if (widget.event != null) {
        _titleController.text = widget.event!.title;
        _descriptionController.text = widget.event!.description;
        _dateController.text =
            widget.event!.date.toIso8601String().split('T').first;
        _timeController.text =
            "${widget.event!.time.hour}:${widget.event!.time.minute.toString().padLeft(2, '0')}";
        _locationController.text = widget.event!.location;
        _selectedCategory = widget.event!.category;
      }
    });
  }

  bool _validateTitle(String title) {
    const titlePattern = r"^[a-zA-Z0-9\s.,!?\'()-]*$";
    return RegExp(titlePattern).hasMatch(title);
  }

  bool _validateDescription(String description) {
    const descriptionPattern = r"^[a-zA-Z0-9\s.,!?\'()-]*$";
    return RegExp(descriptionPattern).hasMatch(description);
  }

  bool _validateDate(String date) {
    return true;
  }

  bool _validateTime(String time) {
    return true;
  }

  void _createEvent() async {
    setState(() {
      _titleError = _titleController.text.isEmpty ||
              !_validateTitle(_titleController.text)
          ? 'Invalid title'
          : null;
      _descriptionError = _descriptionController.text.isEmpty ||
              !_validateDescription(_descriptionController.text)
          ? 'Invalid description'
          : null;
      _dateError =
          _dateController.text.isEmpty || !_validateDate(_dateController.text)
              ? 'Invalid date'
              : null;
      _timeError =
          _timeController.text.isEmpty || !_validateTime(_timeController.text)
              ? 'Invalid time'
              : null;
      _locationError =
          _locationController.text.isEmpty ? 'Invalid location' : null;
    });

    if (_titleError == null &&
        _descriptionError == null &&
        _dateError == null &&
        _timeError == null &&
        _locationError == null) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final currentUser = userProvider.currentUser;

        if (currentUser != null) {
          DateTime eventDate = DateTime.parse(_dateController.text);
          final timeParts = _timeController.text.split(':');
          final eventTime = DateTime(
            eventDate.year,
            eventDate.month,
            eventDate.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          final eventProvider =
              Provider.of<EventProvider>(context, listen: false);

          if (widget.event != null) {
            widget.event!.title = _titleController.text;
            widget.event!.description = _descriptionController.text;
            widget.event!.date = eventDate;
            widget.event!.time = eventTime;
            widget.event!.location = _locationController.text;
            widget.event!.category = _selectedCategory!;

            await eventProvider.updateEvent(widget.event!);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Event updated successfully!'),
                  duration: Duration(seconds: 2)),
            );
          } else {
            Event newEvent = Event(
              id: '',
              title: _titleController.text,
              description: _descriptionController.text,
              date: eventDate,
              time: eventTime,
              location: _locationController.text,
              userName: currentUser.fullName,
              userId: currentUser.userId,
              category: _selectedCategory!,
            );

            await eventProvider.addEvent(newEvent, userProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Event created successfully!'),
                  duration: Duration(seconds: 2)),
            );
          }

          // Clear the form
          _titleController.clear();
          _descriptionController.clear();
          _dateController.clear();
          _timeController.clear();
          _locationController.clear();
          setState(() {
            _selectedCategory = null;
          });
        } else {
          print("No current user found.");
        }
      } catch (e) {
        print("Error creating or updating event: $e");
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
    );

    List<Category> cateList = Provider.of<CategoryProvider>(context).categories;
    List<Category> categories = cateList.skip(1).toList();

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xff28bca1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      MyDropdownMenu(),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Create Your Event',
                          style: GoogleFonts.lato(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Image.asset(
                        'lib/assets/images/typing.png',
                        fit: BoxFit.cover,
                        height: 160,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: backgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Toggletextfield(
                          label: 'Add Title',
                          hint: 'Enter event title',
                          icon: Icons.title_outlined,
                          textController: _titleController,
                        ),
                        if (_titleError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _titleError!,
                              style: const TextStyle(
                                  color: errorColor, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Toggletextfield(
                          label: 'Add Description',
                          hint: 'Enter event description',
                          icon: Icons.description_outlined,
                          textController: _descriptionController,
                          maxLines: 5,
                          height: 100,
                        ),
                        if (_descriptionError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _descriptionError!,
                              style: const TextStyle(
                                  color: errorColor, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Toggletextfield(
                                label: 'Select Date',
                                hint: 'YYYY-MM-DD',
                                icon: Icons.date_range_outlined,
                                textController: _dateController,
                                height: 50,
                                isDate: true,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Toggletextfield(
                                label: 'Select Time',
                                hint: 'HH:MM AM/PM',
                                icon: Icons.access_time_outlined,
                                textController: _timeController,
                                height: 50,
                                isTime: true,
                              ),
                            ),
                          ],
                        ),
                        if (_dateError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _dateError!,
                              style: const TextStyle(
                                  color: errorColor, fontSize: 12),
                            ),
                          ),
                        if (_timeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _timeError!,
                              style: const TextStyle(
                                  color: errorColor, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ToggleDropdown(
                          label: 'Select category',
                          items: categories,
                          selectedItem: _selectedCategory,
                          onChanged: (category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Toggletextfield(
                          label: 'Add Location',
                          hint: 'Enter Location',
                          icon: Icons.location_on_outlined,
                          textController: _locationController,
                        ),
                        if (_locationError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _locationError!,
                              style: const TextStyle(
                                  color: errorColor, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 50),
                        SmallButton(
                          onTap: _createEvent,
                          label: widget.event == null
                              ? 'Create Event'
                              : 'Update Event',
                          color: primaryColor,
                          textColor: white,
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
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

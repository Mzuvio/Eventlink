import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/event_card.dart';
import 'package:transitease_app/components/my_dropdown_menu.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/models/event.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isExpanded = false;

  void _visitPostDetails(event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetails(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
    );

    final eventProvider = Provider.of<EventProvider>(context);

    final filteredEvents =
        eventProvider.filterEventsByCategory(widget.event.category.categoryId);

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
                      const MyDropdownMenu()
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Event \nDetails',
                          style: GoogleFonts.lato(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Image.asset(
                        'lib/assets/images/details.png',
                        fit: BoxFit.cover,
                        height: 160,
                      )
                    ],
                  )
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          )
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.title,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'by ${widget.event.userName}',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                          )
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.event.location,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    Text(
                                      '${DateFormat('EEE, MMM d').format(widget.event.date)} - ',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('h:mm a')
                                          .format(widget.event.time),
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Icon(
                                    Icons.subdirectory_arrow_right,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'days from now',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFced4da),
                            ),
                            const SizedBox(height: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Event Description',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  widget.event.description,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: isExpanded ? null : 3,
                                  overflow: isExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Text(
                                    isExpanded ? 'Read Less' : 'Read More',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Related Events',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      filteredEvents.isNotEmpty
                          ? SizedBox(
                              height: 216,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                scrollDirection: Axis.horizontal,
                                itemCount: filteredEvents.length,
                                itemBuilder: (context, index) {
                                  final event = filteredEvents[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? 10 : 5,
                                      right: index == filteredEvents.length - 1
                                          ? 20
                                          : 5,
                                    ),
                                    child: EventCard(
                                      event: event,
                                      onTap: () {
                                        _visitPostDetails(event);
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'lib/assets/icons/mute.png',
                                  fit: BoxFit.contain,
                                  height: 100,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'The are no related events fot this event',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: textColor,
                                            fontSize: 13,
                                          ),
                                      textAlign:
                                          TextAlign.center, // Center the text
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '© 2024 EventLink. All rights reserved.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
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

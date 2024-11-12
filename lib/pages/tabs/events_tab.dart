import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/event_post.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/pages/event_details.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/utils/colors.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  List<Event> userEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      try {
        final events =
            await eventProvider.fetchEventsByUserId(currentUser.userId);

        setState(() {
          userEvents = events;
        });
      } catch (e) {
        print("Error fetching user events: $e");
      }
    }
  }

  void _removeEvent(Event event) {
    setState(() {
      userEvents.removeWhere((e) => e.id == event.id);
    });
  }

  void _visitPostDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetails(event: event)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: userEvents.isNotEmpty
          ? ListView.builder(
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                final event = userEvents[index];
                return EventPost(
                  event: event,
                  onTap: () => _visitPostDetails(event),
                  index: index,
                  removeEvent: _removeEvent,
                );
              },
            )
          : Center(
              child: Text(
                "No events",
                style: GoogleFonts.lato(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}

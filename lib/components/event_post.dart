import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/pages/add_event.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:transitease_app/models/event.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transitease_app/providers/event_provider.dart';

class EventPost extends StatefulWidget {
  final void Function()? onTap;
  final Event event;
  final int index;
  final void Function(Event event) removeEvent; // Callback

  const EventPost({
    super.key,
    required this.event,
    required this.onTap,
    required this.index,
    required this.removeEvent, // Initialize the callback
  });

  @override
  _EventPostState createState() => _EventPostState();
}

class _EventPostState extends State<EventPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteEvent(
      BuildContext context, Event event, int index) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    final docRef = _firestore.collection('events').doc(event.id);

    try {
      if (currentUser != null) {
        await eventProvider.deleteEvent(docRef.id, currentUser.fullName);
        await userProvider.removeEvent(event.id ?? '');
        widget.removeEvent(event);

        if (mounted) {
          print("Event deleted successfully");
        }
      }
    } catch (e) {
      print("Error deleting event: $e");
    }
  }

  void goToForm(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEvent(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Slidable(
        endActionPane: currentUser != null &&
                currentUser.fullName == widget.event.userName
            ? ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        _deleteEvent(context, widget.event, widget.index),
                    icon: Icons.delete,
                    backgroundColor: const Color(0XFFe5383b).withOpacity(.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              )
            : null,
        startActionPane:
            currentUser != null && currentUser.fullName == widget.event.userName
                ? ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => goToForm(widget.event),
                        icon: Icons.edit,
                        backgroundColor: Colors.yellow.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  )
                : null,
        child: Container(
          height: 120,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: GoogleFonts.lato(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        DateFormat('EEE, MMM d').format(widget.event.date),
                        style: TextStyle(color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Expanded(
                        child: Text(
                          widget.event.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: darkGrey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              widget.event.location,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: darkGrey,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("-"),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('h:mm a').format(widget.event.time),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: darkGrey,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    "View Details",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/components/event_post.dart';
import 'package:transitease_app/components/my_dropdown_menu.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/pages/event_details.dart';
import 'package:transitease_app/providers/category_provider.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/utils/colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategoryId = '1';

  @override
  void initState() {
    super.initState();
    _fetchInitialEvents();
  }

  void _fetchInitialEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    await eventProvider.fetchEvents();
  }

  void categoryTap(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  void _visitPostDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetails(event: event),
      ),
    );
  }

  List<Event> _filterEventsBySearchQuery(List<Event> events, String query) {
    return events.where((event) {
      final eventTitle = event.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return eventTitle.contains(searchQuery);
    }).toList();
  }

  void _removeEvent(Event event) {
    setState(() {
      Provider.of<EventProvider>(context, listen: false).removeEvent(event);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    final filteredEvents = selectedCategoryId == '1'
        ? _filterEventsBySearchQuery(events, _searchController.text)
        : _filterEventsBySearchQuery(
            eventProvider.filterEventsByCategory(selectedCategoryId),
            _searchController.text,
          );

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
                            color: white,
                          ),
                        ),
                      ),
                      Text(
                        "Events",
                        style: GoogleFonts.sansita(
                          fontSize: 18,
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const MyDropdownMenu(),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: backgroundColor,
                    ),
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected =
                                  category.categoryId == selectedCategoryId;
                              final boxColor =
                                  isSelected ? primaryColor : backgroundColor;
                              final borderColor =
                                  isSelected ? primaryColor : mediumGrey;
                              final forColor = isSelected ? white : darkGrey;

                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    categoryTap(category.categoryId);
                                  },
                                  child: Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: boxColor,
                                      border: Border.all(color: borderColor),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.categoryName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: forColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        Expanded(
                          child: filteredEvents.isNotEmpty
                              ? ListView.builder(
                                  itemCount: filteredEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = filteredEvents[index];
                                    return EventPost(
                                      event: event,
                                      onTap: () {
                                        _visitPostDetails(event);
                                      },
                                      index: index,
                                      removeEvent: _removeEvent,
                                    );
                                  },
                                )
                              : Text(
                                  'Event not found!',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -20,
                    left: 25,
                    right: 25,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              cursorColor: mediumGrey,
                              cursorHeight: 15,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: 'Search for events...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: mediumGrey),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.filter_list_rounded,
                              color: mediumGrey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

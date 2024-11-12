import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/pages/notification_page.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/pages/event_details.dart';
import 'package:transitease_app/providers/category_provider.dart';
import 'package:transitease_app/screens/events_screen.dart';
import 'package:transitease_app/components/custom_banner.dart';
import 'package:transitease_app/components/customized_drawer.dart';
import 'package:transitease_app/components/event_card.dart';
import 'package:transitease_app/components/event_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    setState(
      () {
        selectedCategoryId = categoryId;
      },
    );
  }

  void _visitPostDetails(event) {
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

  void performSearch(filteredEvents, events) {
    final query = _searchController.text;
    setState(
      () {
        filteredEvents = _filterEventsBySearchQuery(events, query);
      },
    );
  }

  void _removeEvent(Event event) {
    setState(() {
      Provider.of<EventProvider>(context, listen: false).removeEvent(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: white,
          ),
        ),
        title: Text(
          "EventLink",
          style: GoogleFonts.sansita(
            fontSize: 18,
            color: white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ),
              icon: const Icon(
                Icons.notifications,
                color: white,
              ),
            ),
          ),
        ],
      ),
      drawer: CustomizedDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section

              Container(
                height: 150,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: const BoxDecoration(color: primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Find events \n near you.',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: white,
                              ),
                    ),
                    Image.asset(
                      'lib/assets/images/8.png',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          color: mediumGrey,
                        ),
                        onPressed: () {
                          performSearch(filteredEvents, events);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Event Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Event Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              const SizedBox(height: 25),

              // Category ListView
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
                    final borderColor = isSelected ? primaryColor : mediumGrey;
                    final forColor = isSelected ? white : darkGrey;

                    // event categories start
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 5),
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
                                      color: forColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // categories end here

              const SizedBox(height: 25),

              // Upcoming Events
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Popular Events',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              const SizedBox(height: 25),

              events.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    )
                  : Column(
                      children:
                          List.generate(filteredEvents.take(3).length, (index) {
                        Event event = filteredEvents[
                            index];

                        return EventPost(
                          event: event,
                          onTap: () {
                            _visitPostDetails(event);
                          },
                          index: index, 
                          removeEvent: _removeEvent,
                        );
                      }),
                    ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: CustomBanner(),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Featured Events',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const EventsScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: textColor,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // featured events/ list

              events.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : SizedBox(
                      height: 208,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];

                          EdgeInsets padding;
                          if (index == 0) {
                            padding =
                                const EdgeInsets.only(left: 25, right: 10);
                          } else if (index == events.length - 1) {
                            padding =
                                const EdgeInsets.only(left: 10, right: 20);
                          } else {
                            padding =
                                const EdgeInsets.symmetric(horizontal: 10);
                          }

                          return Padding(
                            padding: padding,
                            child: EventCard(
                              event: event,
                              onTap: () {
                                _visitPostDetails(event);
                              },
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(
                height: 25,
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
    );
  }
}

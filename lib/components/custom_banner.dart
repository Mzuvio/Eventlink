import 'package:flutter/material.dart';

import 'package:transitease_app/utils/colors.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF219C85),
            Color(0xFF1D976C),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Embrace the World,\nCelebrate Our Differences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: white,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Our Uniqueness Strengthens Us.',
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: white.withOpacity(0.6)),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: white,
                    backgroundColor: white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3, // Shadow effect
                  ),
                  onPressed: () {},
                  child: Text(
                    'Get Involved',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: darkGrey,
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Image.asset(
              'lib/assets/icons/icon-1.png',
              fit: BoxFit.contain,
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}

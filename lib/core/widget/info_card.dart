import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {

  final IconData icon;

  final String title;

  final String value;

  final Color border;

  final Color primary;

  final Color babyBlue;

  const InfoCard({

    super.key,

    required this.icon,

    required this.title,

    required this.value,

    required this.border,

    required this.primary,

    required this.babyBlue,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: border,
        ),
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 24,

            backgroundColor:
            babyBlue.withOpacity(0.4),

            child: Icon(
              icon,
              color: primary,
            ),
          ),

          const SizedBox(width: 16),

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(

                title,

                style:
                GoogleFonts.montserrat(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 6),

              Text(

                value,

                style:
                GoogleFonts.montserrat(

                  fontWeight:
                  FontWeight.bold,

                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
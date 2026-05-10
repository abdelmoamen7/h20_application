import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/Providers/CalculationProvider.dart';
import '../../../../core/colorsmanger/colorsmanger.dart';

import '../../../../core/widget/MacroCard.dart';
import '../../../../core/widget/MealCard.dart';
import '../../../../core/widget/ProgressCard.dart';
import '../../../../core/widget/WorkoutCard.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/UserModel.dart';
import '../../../../models/HealthMetricsModel.dart';

import '../../../../services/FirebaseServcies/firebaseService.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() =>
      _HomeState();
}

class _HomeState
    extends State<Home> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserModel?>(

      stream:
      Fairebaeservices
          .streamCurrentUser(),

      builder:
          (context, snapshot) {

        /// LOADING

        if(snapshot.connectionState ==
            ConnectionState.waiting){

          return const Center(

            child:
            CircularProgressIndicator(),
          );
        }

        /// NO DATA

        if(snapshot.data == null){

          return const Center(

            child:
            Text("No User Data"),
          );
        }

        /// USER

        UserModel user =
        snapshot.data!;

        /// CALCULATIONS

        HealthMetricsModel metrics =

        CalculationProvider
            .calculate(user);

        return ListView(

          padding:
          EdgeInsets.zero,

          children: [

            /// HEADER

            Container(

              width:
              double.infinity,

              height: 210,

              padding:
              const EdgeInsets.symmetric(

                horizontal: 16,

                vertical: 10,
              ),

              decoration:
              BoxDecoration(

                borderRadius:
                BorderRadius.vertical(

                  bottom:
                  Radius.circular(
                      15.r),
                ),

                color:
                Colorsmanger.Blue,
              ),

              child: Column(

                children: [

                  Row(

                    children: [

                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const SizedBox(
                            height: 30,
                          ),

                          Text(

                            AppLocalizations.of(
                                context)!
                                .welcome_message,

                            style:
                            GoogleFonts.inter(

                              fontSize: 15,

                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),

                          const SizedBox(
                              height: 5),

                          Text(

                            user.name,

                            style:
                            GoogleFonts.inter(

                              fontSize: 22,

                              fontWeight:
                              FontWeight
                                  .w700,

                              color:
                              Colors.white,
                            ),
                          ),

                          Padding(

                            padding:
                            const EdgeInsets
                                .all(8),

                            child: Row(

                              children: [

                                const Icon(

                                  Icons
                                      .location_on,

                                  color:
                                  Colorsmanger
                                      .Whiteblue,
                                ),

                                const SizedBox(
                                    width: 4),

                                Text(

                                  "Cairo, Egypt ✨",

                                  style:
                                  GoogleFonts
                                      .inter(

                                    fontWeight:
                                    FontWeight
                                        .w400,

                                    fontSize:
                                    14,

                                    color:
                                    Colorsmanger
                                        .Whiteblue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      InkWell(

                        onTap: () {

                          /// language
                        },

                        child: Card(

                          child: Padding(

                            padding:
                            const EdgeInsets
                                .all(15),

                            child: Text(

                              "EN",

                              style:
                              Theme.of(
                                  context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PROGRESS CARD

            ProgressCard(
              metrics: metrics,
            ),

            const SizedBox(height: 16),

            /// WORKOUT CARD

            WorkoutCard(
              metrics: metrics,
            ),

            const SizedBox(height: 16),

            /// MEAL CARD

            MealCard(
              metrics: metrics,
            ),

            const SizedBox(height: 16),

            /// MACROS

            MacroCard(
              metrics: metrics,
            ),

            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
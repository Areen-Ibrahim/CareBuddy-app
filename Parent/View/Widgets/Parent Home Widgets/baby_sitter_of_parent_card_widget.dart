import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Parent/View/Screens/create_babysitter_request_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_chat_details_screen.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/Constants/constants.dart';
import '../../../../../Core/Constants/translation_keys.dart';
import '../../../../../Core/Theme/colors.dart';
import '../../../../BabySitter/Models/baby_sitter.dart';
import '../../Screens/babysitter_details_as_parent_page.dart';

class BabySitterOfParentCardWidget extends StatelessWidget {
  final Babysitter babysitter;
  final ParentsCubit cubit;
  const BabySitterOfParentCardWidget({super.key, required this.babysitter, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        BabysitterDetailsAsParentPage(babysitter: babysitter,cubit: cubit,),
      ),
      child: Container(
        padding: AppConstants.kContainerPadding,
        decoration: BoxDecoration(
            borderRadius: AppConstants.kMainRadius,
            color: const Color(0xffF4F4F4)),
        child: Row(
          spacing: 14,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 30,
                  backgroundImage: babysitter.multiMedia.profileImage != null
                      ? NetworkImage(babysitter.multiMedia.profileImage!)
                      : null,
                  child: babysitter.multiMedia.profileImage == null
                      ? const Icon(Icons.person, size: 30, color: Colors.grey)
                      : null,
                ),
                BlocBuilder<ParentsCubit, ParentsStates>(
                    buildWhen: (past, current) =>
                        current is AddOrRemoveBabysitterOnFavoritesState,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () => cubit.addOrRemoveBabysitterOnFavorites(
                            context: context, babysitterID: babysitter.id),
                        child: Image.asset(AppImages.kFavoritesIcon,
                            color:
                                cubit.myData!.favorites.contains(babysitter.id)
                                    ? AppColors.kMain
                                    : AppColors.kWhite),
                      );
                    })
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Row(children: [
                    Flexible(
                      child: Text('${babysitter.fName} ${babysitter.lname}',style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kBlack,
                        overflow: TextOverflow.ellipsis
                      ),),
                    ),
                    Text(
                      ' ${babysitter.pricePerHour} ${TranslationKeys.sar.tr(context)} / ${TranslationKeys.hour.tr(context)}',
                      style: TextStyle(
                        color: AppColors.kMain,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ]),
                  Text(
                    '${TranslationKeys.city.tr(context)} : ${babysitter.city.tr(context)}\n${TranslationKeys.nationality.tr(context)} : ${babysitter.nationality.tr(context)}',
                    style: const TextStyle(
                      color: Color(0xff616161),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              spacing: 10,
              children: [
                GestureDetector(
                  child: Image.asset(
                    "assets/images/Chat.png",
                    color: AppColors.kMain,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentChatDetailsScreen(
                        updateChatsOverview: false,
                        receiverData: BabysitterChatOverviewModel(
                          babysitterID: babysitter.id,
                          babysitterIName:
                              "${babysitter.fName} ${babysitter.lname}",
                          lastMessage: "",
                          babysitterIImage: babysitter.multiMedia.profileImage,
                        ),
                        cubit: cubit,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (cubit.myData!.kids.isNotEmpty) {
                      context.push(CreateBabysitterRequestScreen(
                          babysitter: babysitter, cubit: cubit));
                    } else {
                      showSnackBarWidget(
                        message: TranslationKeys.pleaseAddYourKidsFirst.tr(context),
                        successOrNot: true,
                        context: context,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColors.kMain,
                        borderRadius: AppConstants.kMaxRadius),
                    child: Text(
                      TranslationKeys.request.tr(context),
                      style: TextStyle(
                        color: AppColors.kWhite,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

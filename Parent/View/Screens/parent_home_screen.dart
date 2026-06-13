import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/data_state_builder_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/parents_cubit.dart';
import '../../Controller/Layout/parents_states.dart';
import '../Widgets/Parent Home Widgets/baby_sitter_of_parent_card_widget.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  late TextEditingController _searchCtr;
  @override
  void initState() {
    _searchCtr = TextEditingController();
    ParentsCubit.getInstance(context).getBabySitters();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtr.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context)..emptyFilterOfBabysitters();
    return BlocBuilder<ParentsCubit, ParentsStates>(
        builder: (context,state) {
          return Padding(
            padding: AppConstants.kScaffoldPadding.copyWith(top: context.topPaddingOfScreen + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        cubit.myData!.profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${TranslationKeys.hi.tr(context)} ${cubit.myData!.fName} ${cubit.myData!.lname}',
                            style: TextStyle(
                              color: AppColors.kBlack,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cubit.myData!.city.tr(context),
                            style: TextStyle(
                              color: AppColors.kDarkGrey,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(
                        ParentNotificationsScreen(cubit: cubit),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: AppColors.kMain,
                        size: 30,
                      ),
                    )
                  ],
                ),
                TextFieldComponentWidget(
                  isRequired: false,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff49454F),
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () => cubit.showMenuFilterOfHome(context),
                    child: const Icon(
                      Icons.menu,
                      color: Color(0xff49454F),
                    ),
                  ),
                  controller: _searchCtr,
                  disableMarginOnBottom: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (input) => cubit.filterBabysittersAccordingName(input: input),
                  hint: TranslationKeys.searchForBabysitter.tr(context),
                ),
                Text(
                  TranslationKeys.ourBabysitters.tr(context),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: DataStateBuilderWidget(
                    isError: state is GetBabySittersState && state.status == ApiRequestStatus.Failure,
                    errorTxt: state is GetBabySittersState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                    isLoading: state is GetBabySittersState && state.status == ApiRequestStatus.Loading,
                    failureTap: () => cubit.getBabySitters(),
                    emptyTxt: _searchCtr.text.isNotEmpty ? TranslationKeys.noBabysittersFoundYet.tr(context) : TranslationKeys.noBabysittersAddedYet.tr(context),
                    isDataFound: (cubit.babySitters.isNotEmpty && _searchCtr.text.isEmpty) || cubit.filteredBabysitters.isNotEmpty,
                    widget: ListView.separated(
                      itemCount: cubit.filteredBabysitters.isNotEmpty ? cubit.filteredBabysitters.length : cubit.babySitters.length,
                      padding: EdgeInsets.zero.copyWith(bottom: 22),
                      separatorBuilder: AppConstants.kSeparatorBuilder(),
                      itemBuilder: (context, index) => BabySitterOfParentCardWidget(
                        cubit: cubit,
                        babysitter: cubit.filteredBabysitters.isNotEmpty ? cubit.filteredBabysitters[index] : cubit.babySitters[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

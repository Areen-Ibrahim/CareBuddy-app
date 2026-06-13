import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/data_state_builder_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Parent/View/Widgets/Parent%20Home%20Widgets/baby_sitter_of_parent_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/enum.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../BabySitter/Models/baby_sitter.dart';
import '../../Controller/Layout/parents_cubit.dart';

class ParentFavoritesScreen extends StatelessWidget {
  const ParentFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return AppScaffoldWidget(
      showBackgroundImage: false,
      appBar: AppBar(title: Text(TranslationKeys.favorites.tr(context))),
      body: BlocBuilder<ParentsCubit,ParentsStates>(
        builder: (context,state){
          List<Babysitter> babysittersOnFavorites = cubit.myData!.favorites.isNotEmpty && cubit.babySitters.isNotEmpty ?  List<Babysitter>.from(cubit.babySitters.where((babysitter)=> cubit.myData!.favorites.contains(babysitter.id))) : [];
          return DataStateBuilderWidget(
              isError: ( state is GetBabySittersState && state.status == ApiRequestStatus.Failure ) || (state is AddOrRemoveBabysitterOnFavoritesState && state.status == ApiRequestStatus.Failure),
              errorTxt: TranslationKeys.somethingWentWrong.tr(context),
              isLoading: state is GetBabySittersState && state.status == ApiRequestStatus.Loading,
              failureTap: ()=> cubit.getBabySitters(),
              emptyTxt: TranslationKeys.noBabysittersAddedYet.tr(context),
              isDataFound: babysittersOnFavorites.isNotEmpty,
              widget: ListView.separated(
                padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22),
                itemCount: babysittersOnFavorites.length,
                separatorBuilder: AppConstants.kSeparatorBuilder(),
                itemBuilder: (context,index)=> BabySitterOfParentCardWidget(babysitter: babysittersOnFavorites[index], cubit: cubit),
              )
          );
        },
      ),
    );
  }
}

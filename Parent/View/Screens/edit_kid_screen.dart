import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/txt_field_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class EditKidScreen extends StatefulWidget {
  final ParentsCubit cubit;
  final KidModel kid;
  final bool calledFromDetailsScreen;
  const EditKidScreen(
      {super.key,
      required this.cubit,
      required this.kid,
      required this.calledFromDetailsScreen});

  @override
  State<EditKidScreen> createState() =>
      _EditKidScreenState();
}

class _EditKidScreenState
    extends State<EditKidScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  final TextEditingController _nameCtr =
      TextEditingController();
  final TextEditingController _dateOfBirthCtr =
      TextEditingController();
  final TextEditingController
      _dietaryRequirementsCtr =
      TextEditingController();
  final TextEditingController _notesCtr =
      TextEditingController();

  @override
  void initState() {
    widget.cubit
      ..genderChosen = widget.kid.gender ==
              GenderStatus.Male.name
          ? GenderStatus.Male
          : GenderStatus.Female
      ..kidImageFile = null;
    _nameCtr.text = widget.kid.name;
    _dateOfBirthCtr.text =
        widget.kid.dateOfBirth;
    _dietaryRequirementsCtr.text =
        widget.kid.dietaryRequirements;
    _notesCtr.text = widget.kid.notes;
    super.initState();
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _dateOfBirthCtr.dispose();
    _dietaryRequirementsCtr.dispose();
    _notesCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(
        title: Text(TranslationKeys.editKid
            .tr(context)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:
              AppConstants.kScaffoldPadding,
          child: Column(
            spacing: 22,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    BlocBuilder<ParentsCubit,
                            ParentsStates>(
                        buildWhen: (past,
                                current) =>
                            current
                                is GetKidImageState,
                        builder:
                            (context, state) {
                          return Center(
                            child:
                                GestureDetector(
                              onTap: () => widget
                                  .cubit
                                  .selectKidImage(),
                              child: Stack(
                                alignment:
                                    AlignmentDirectional
                                        .bottomEnd,
                                children: [
                                  Container(
                                    height: 110,
                                    width: 110,
                                    clipBehavior:
                                        Clip.hardEdge,
                                    decoration:
                                        const BoxDecoration(
                                      shape: BoxShape
                                          .circle,
                                    ),
                                    child: widget.cubit.kidImageFile !=
                                            null
                                        ? Image.file(
                                            widget
                                                .cubit.kidImageFile!,
                                            fit: BoxFit
                                                .cover)
                                        : widget.kid.image !=
                                                null
                                            ? Image.network(widget.kid.image!,
                                                fit: BoxFit.cover)
                                            : Image.asset(AppImages.kAccountIcon, fit: BoxFit.cover),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    padding:
                                        const EdgeInsets
                                            .all(
                                            6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle,
                                        color: AppColors
                                            .kMain),
                                    child: Image
                                        .asset(
                                            "assets/images/edit.png"),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                    22.vrSpace,
                    TextFieldComponentWidget(
                        controller: _nameCtr,
                        hint: TranslationKeys
                            .name
                            .tr(context)),
                    DateOrTimeTxtFieldWidget(
                      controller:
                          _dateOfBirthCtr,
                      dateNotTime: true,
                      lastData: DateTime.now(),
                      title: TranslationKeys
                          .dateOfBirth
                          .tr(context),
                    ),
                    TextFieldComponentWidget(
                        controller:
                            _dietaryRequirementsCtr,
                        hint: TranslationKeys
                            .dietaryRequirements
                            .tr(context),
                        maxLines: 3),
                    TextFieldComponentWidget(
                        controller: _notesCtr,
                        hint: TranslationKeys
                            .otherNotes
                            .tr(context),
                        maxLines: 6),
                    Text(
                        "${TranslationKeys.gender.tr(context)} :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w400,
                            color: AppColors
                                .kBlack)),
                    BlocBuilder<ParentsCubit,
                            ParentsStates>(
                        buildWhen: (past,
                                current) =>
                            current
                                is PickedImageOnParentState,
                        builder:
                            (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: RadioListTile
                                    .adaptive(
                                        value: GenderStatus
                                            .Male,
                                        contentPadding:
                                            EdgeInsets
                                                .zero,
                                        title: Text(TranslationKeys
                                            .male
                                            .tr(
                                                context)),
                                        groupValue: widget
                                            .cubit
                                            .genderChosen,
                                        activeColor:
                                            AppColors
                                                .kMain,
                                        onChanged:
                                            (GenderStatus?
                                                value) {
                                          if (value !=
                                              null) {
                                            widget.cubit.chooseGender(value);
                                          }
                                        }),
                              ),
                              Expanded(
                                child: RadioListTile
                                    .adaptive(
                                        value: GenderStatus
                                            .Female,
                                        title: Text(TranslationKeys
                                            .female
                                            .tr(
                                                context)),
                                        contentPadding:
                                            EdgeInsets
                                                .zero,
                                        activeColor:
                                            AppColors
                                                .kMain,
                                        groupValue: widget
                                            .cubit
                                            .genderChosen,
                                        onChanged:
                                            (GenderStatus?
                                                value) {
                                          if (value !=
                                              null) {
                                            widget.cubit.chooseGender(value);
                                          }
                                        }),
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
              BlocBuilder<ParentsCubit,
                      ParentsStates>(
                  buildWhen: (past, current) =>
                      current
                          is AddOrUpdateNewKidState &&
                      !current.addNotUpdate,
                  builder: (context, state) {
                    return BtnWidget(
                        onTap: () {
                          if (_formKey
                              .currentState!
                              .validate()) {
                            widget.cubit.updateKid(
                                calledFromDetailsScreen:
                                    widget
                                        .calledFromDetailsScreen,
                                context:
                                    context,
                                kid: KidModel(
                                    image: widget
                                        .kid
                                        .image,
                                    id: widget
                                        .kid.id,
                                    name: _nameCtr
                                        .text
                                        .trim(),
                                    dateOfBirth:
                                        _dateOfBirthCtr
                                            .text
                                            .trim(),
                                    dietaryRequirements:
                                        _dietaryRequirementsCtr
                                            .text
                                            .trim(),
                                    notes: _notesCtr
                                        .text
                                        .trim(),
                                    gender: widget
                                        .cubit
                                        .genderChosen
                                        .name));
                          }
                        },
                        showLoading: state
                                is AddOrUpdateNewKidState &&
                            !state
                                .addNotUpdate &&
                            state.status ==
                                ApiRequestStatus
                                    .Loading,
                        title: TranslationKeys
                            .confirm
                            .tr(context));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

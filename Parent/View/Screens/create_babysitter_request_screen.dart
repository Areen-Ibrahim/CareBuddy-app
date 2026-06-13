import 'dart:math';
import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../Widgets/Parent Requests Widgets/kid_parent_of_create_request_card_widget.dart';

class CreateBabysitterRequestScreen extends StatefulWidget {
  final Babysitter babysitter;
  final ParentsCubit cubit;
  const CreateBabysitterRequestScreen({super.key, required this.babysitter, required this.cubit});

  @override
  State<CreateBabysitterRequestScreen> createState() => _CreateBabysitterRequestScreenState();
}

class _CreateBabysitterRequestScreenState extends State<CreateBabysitterRequestScreen> {
  final TextEditingController _dateCtr = TextEditingController();
  final TextEditingController _startTimeCtr = TextEditingController();
  final TextEditingController _endTimeCtr = TextEditingController();
  final TextEditingController _notesCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    widget.cubit.selectedKidOnCreateRequestBabysitter = null;
    super.initState();
  }
  @override
  dispose(){
    _dateCtr.dispose();
    _startTimeCtr.dispose();
    _endTimeCtr.dispose();
    _notesCtr.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.requestBabysitter.tr(context))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppConstants.kScaffoldPadding,
          children: [
            BlocBuilder<ParentsCubit,ParentsStates>(
              buildWhen: (past,current)=> current is KidSelectedOnCreateRequestBabysitterState,
              builder: (context,state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 14,
                    children: List.generate(widget.cubit.myData!.kids.length, (index)=> KidParentOfCreateRequestCardWidget(cubit: widget.cubit,kid: widget.cubit.myData!.kids.reversed.toList()[index])),
                  ),
                );
              }
            ),
            22.vrSpace,
            DateOrTimeTxtFieldWidget(
              title: TranslationKeys.date.tr(context),
              dateNotTime: true,
              firstData: DateTime.now(),
              controller: _dateCtr,
            ),
            DateOrTimeTxtFieldWidget(
              title: TranslationKeys.startTime.tr(context),
              dateNotTime: false,
              controller: _startTimeCtr,
            ),
            DateOrTimeTxtFieldWidget(
              title: TranslationKeys.endTime.tr(context),
              dateNotTime: false,
              controller: _endTimeCtr,
            ),
            TextFieldComponentWidget(
              hint: TranslationKeys.anyNotes.tr(context),
              validator: (_)=> null,
              maxLines: 4,
              isRequired: false,
              textInputAction: TextInputAction.done,
              controller: _notesCtr,
            ),
            8.vrSpace,
            BlocBuilder<ParentsCubit,ParentsStates>(
              buildWhen: (past,current)=> current is CreateBabysitterRequestState,
              builder: (context,state) {
                return BtnWidget(
                  title: TranslationKeys.request.tr(context),
                  showLoading: state is CreateBabysitterRequestState && state.status == ApiRequestStatus.Loading,
                  onTap: (){
                    if( _formKey.currentState!.validate() )
                      {
                        if( widget.cubit.selectedKidOnCreateRequestBabysitter != null )
                          {
                            DateTime startTime = DateFormat("dd-MM-yyyy HH:mm").parse(
                                "${_dateCtr.text.trim()} ${_startTimeCtr.text.trim()}"
                            );
                            DateTime endTime = DateFormat("dd-MM-yyyy HH:mm").parse(
                                "${_dateCtr.text.trim()} ${_endTimeCtr.text.trim()}"
                            );
                            if (endTime.isBefore(startTime)) {
                              endTime = endTime.add(Duration(days: 1));
                            }
                            if (
                            startTime.isAfter(DateTime.now()) &&
                                endTime.isAfter(startTime) &&
                                startTime.difference(DateTime.now()) >= Duration(hours: 1) &&
                                endTime.difference(startTime).inMinutes % 60 == 0
                            )
                            {
                                widget.cubit.createBabysitterRequest(request: BabysitterRequestModel(id: "${Random().nextInt(1000000)}",babySitter: widget.babysitter,notes: _notesCtr.text.isNotEmpty ? _notesCtr.text.trim() : null, parent: widget.cubit.myData!, status: BabysitterRequestStatus.Pending.name, childSelected: widget.cubit.selectedKidOnCreateRequestBabysitter!, startAt: DateFormat("dd-MM-yyyy HH:mm").parse("${_dateCtr.text.trim()} ${_startTimeCtr.text.trim()}"), endAt: DateFormat("dd-MM-yyyy HH:mm").parse("${_dateCtr.text.trim()} ${_endTimeCtr.text.trim()}")), babysitter: widget.babysitter, context: context);
                              }
                            else
                              {
                                showSnackBarWidget(message: TranslationKeys.endTimeNotAfterStartTime.tr(context), successOrNot: true, context: context);
                              }
                          }
                        else
                          {
                            showSnackBarWidget(message: TranslationKeys.pleaseAddYourKidsFirst.tr(context), successOrNot: true, context: context);
                          }
                      }
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

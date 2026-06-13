import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import '../../Features/Admin/View/Widgets/txt_field_of_inactive_babysitter_widget.dart';
import '../../Features/Shared/View/Screens/image_view_page.dart';
import '../../Features/Shared/View/Screens/pdf_view_page.dart';
import '../../Features/Shared/View/Screens/video_show_page.dart';

class BabysitterDataListViewWidget extends StatelessWidget {
  final Babysitter babySitter;
  const BabysitterDataListViewWidget({super.key, required this.babySitter});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if( babySitter.multiMedia.profileImage != null )
          Container(
            height: 98,width: 98,
            margin: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage(babySitter.multiMedia.profileImage!),fit: BoxFit.cover,)
            ),
          ),
        Row(
          spacing: 14,
          children: [
            Expanded(child: TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.lastName.tr(context),txt: babySitter.fName,),),
            Expanded(child: TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.firstName.tr(context),txt: babySitter.lname,),),
          ],
        ),
        Row(
          spacing: 14,
          children: [
            Expanded(child: TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.nationality.tr(context),txt: babySitter.nationality,),),
            Expanded(child: TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.city.tr(context),txt: babySitter.city,),),
          ],
        ),
        TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.email.tr(context),txt: babySitter.email,),
        TxtFieldOfInactiveBabysitterWidget(hint: TranslationKeys.pricePerHour.tr(context),txt: babySitter.pricePerHour.toString(),),
        TxtFieldOfInactiveBabysitterWidget(txt: babySitter.phone, hint: TranslationKeys.phoneNumber.tr(context)),
        TxtFieldOfInactiveBabysitterWidget(onTap: ()=> context.push(ImageViewPage(url: babySitter.multiMedia.identification)),txt: babySitter.multiMedia.identification, hint: TranslationKeys.identification.tr(context)),
        TxtFieldOfInactiveBabysitterWidget(onTap: ()=> context.push(PdfViewPage(url: babySitter.multiMedia.securityClearance)),txt: babySitter.multiMedia.securityClearance, hint: TranslationKeys.securityClearance.tr(context)),
        TxtFieldOfInactiveBabysitterWidget(onTap: ()=> context.push(PdfViewPage(url: babySitter.multiMedia.medicalHistory)),txt: babySitter.multiMedia.medicalHistory, hint: TranslationKeys.medicalHistory.tr(context)),
        if( babySitter.multiMedia.certificates != null )
          TxtFieldOfInactiveBabysitterWidget(onTap: ()=> context.push(PdfViewPage(url: babySitter.multiMedia.certificates!)),txt: babySitter.multiMedia.certificates!, hint: TranslationKeys.certificates.tr(context)),
        if( babySitter.multiMedia.introVideo != null )
          TxtFieldOfInactiveBabysitterWidget(onTap: ()=> context.push(VideoPlayerPage(url: babySitter.multiMedia.introVideo!)),txt: babySitter.multiMedia.introVideo!, hint: TranslationKeys.videoIntroduction.tr(context))
      ],
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SkinCard extends StatelessWidget {
  const SkinCard({super.key, required this.child, this.color=AppColors.paper,
    this.padding=const EdgeInsets.all(18), this.onTap});
  final Widget child; final Color color; final EdgeInsets padding; final VoidCallback? onTap;
  @override Widget build(BuildContext context)=>Material(color:color,borderRadius:BorderRadius.circular(17),clipBehavior:Clip.antiAlias,
    child:InkWell(onTap:onTap,child:Padding(padding:padding,child:child)));
}
class SkinButton extends StatelessWidget {
  const SkinButton(this.title,{super.key,required this.onTap,this.outlined=false,this.icon});
  final String title; final VoidCallback? onTap;final bool outlined;final IconData? icon;
  @override Widget build(BuildContext context)=>SizedBox(width:double.infinity,height:54,child:outlined?
    OutlinedButton(style:OutlinedButton.styleFrom(side:const BorderSide(color:AppColors.forest),foregroundColor:AppColors.forest,
      backgroundColor:AppColors.paper,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18))),
      onPressed:onTap,child:_label()):ElevatedButton(onPressed:onTap,child:_label()));
  Widget _label()=>Row(mainAxisSize:MainAxisSize.min,mainAxisAlignment:MainAxisAlignment.center,children:[
    if(icon!=null)...[Icon(icon,size:17),const SizedBox(width:8)],
    Text(title,style:AppTextStyles.body(14).copyWith(fontWeight:FontWeight.w600,color:outlined?AppColors.forest:AppColors.white))]);
}
class SkinField extends StatelessWidget {
  const SkinField(this.label,{super.key,this.controller,this.hint,this.keyboardType,this.obscure=false,this.lines=1});
  final String label;final TextEditingController? controller;final String? hint;final TextInputType? keyboardType;final bool obscure;final int lines;
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(label,style:AppTextStyles.label(12).copyWith(color:AppColors.plum)),const SizedBox(height:9),
    TextField(controller:controller,keyboardType:keyboardType,obscureText:obscure,maxLines:lines,
      style:AppTextStyles.body(13),decoration:InputDecoration(hintText:hint??label))]);
}
class SkinSectionTitle extends StatelessWidget {
  const SkinSectionTitle(this.title,{super.key,this.action,this.onTap});
  final String title;final String? action;final VoidCallback? onTap;
  @override Widget build(BuildContext context)=>Row(children:[Expanded(child:Text(title,style:AppTextStyles.title(25))),
    if(action!=null)TextButton(onPressed:onTap,child:Text(action!,style:AppTextStyles.label(12)))]);
}
class SkinItem extends StatelessWidget {
  const SkinItem({super.key,required this.title,required this.detail,required this.icon,this.onTap,this.trailing,this.accent=AppColors.mist});
  final String title,detail;final IconData icon;final VoidCallback? onTap;final Widget? trailing;final Color accent;
  @override Widget build(BuildContext context)=>SkinCard(onTap:onTap,padding:EdgeInsets.zero,child:ListTile(
    contentPadding:const EdgeInsets.symmetric(horizontal:14,vertical:5),leading:Container(width:43,height:43,
      decoration:BoxDecoration(color:accent,borderRadius:BorderRadius.circular(13)),child:Icon(icon,color:AppColors.forest,size:21)),
    title:Text(title,style:AppTextStyles.body(13).copyWith(fontWeight:FontWeight.w600)),
    subtitle:Text(detail,maxLines:2,overflow:TextOverflow.ellipsis,style:AppTextStyles.muted(11.5)),
    trailing:trailing??const Icon(Icons.chevron_right,color:AppColors.sage,size:20)));
}
class SkinTag extends StatelessWidget {
  const SkinTag(this.title,{super.key,this.selected=false,this.onTap});
  final String title;final bool selected;final VoidCallback? onTap;
  @override Widget build(BuildContext context)=>ActionChip(onPressed:onTap,backgroundColor:selected?AppColors.forest:AppColors.mist,
    side:BorderSide.none,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
    label:Text(title,style:AppTextStyles.label(11).copyWith(color:selected?AppColors.white:AppColors.forest)));
}
/// Decorative fallback; replace with licensed photos exported from Figma.
class BotanicalArt extends StatelessWidget {
  const BotanicalArt({super.key,this.height=240,this.assetPath,this.rounded=22,this.tint=AppColors.mist,this.label=''});
  final double height,rounded;final String? assetPath;final String label;final Color tint;
  @override Widget build(BuildContext context)=>ClipRRect(borderRadius:BorderRadius.circular(rounded),
    child:SizedBox(width:double.infinity,height:height,child:Stack(fit:StackFit.expand,children:[
      if(assetPath!=null)Image.asset(assetPath!,fit:BoxFit.cover,errorBuilder:(_,__,___)=>_art())else _art(),
      if(label.isNotEmpty)Positioned(left:20,bottom:17,right:20,child:Text(label,style:AppTextStyles.title(25)))])));
  Widget _art()=>CustomPaint(painter:BotanicalPainter(tint));
}
class BotanicalPainter extends CustomPainter {
  const BotanicalPainter(this.base);final Color base;
  @override void paint(Canvas canvas,Size size){
    canvas.drawRect(Offset.zero&size,Paint()..color=base);
    canvas.drawCircle(Offset(size.width*.80,size.height*.23),size.width*.34,Paint()..color=AppColors.sand.withOpacity(.73));
    final stem=Paint()..color=AppColors.forest.withOpacity(.45)..style=PaintingStyle.stroke..strokeWidth=2.2;
    final w=size.width,h=size.height;
    canvas.drawPath(Path()..moveTo(w*.14,h*1.05)..cubicTo(w*.34,h*.8,w*.31,h*.45,w*.59,h*.07),stem);
    for(int k=0;k<8;k++){
      final t=k/8.0;canvas.save();canvas.translate(w*(.22+.30*t+.035*math.sin(t*15)),h*(.91-.78*t));
      canvas.rotate((k.isEven?-1:1)*.60);
      canvas.drawPath(Path()..moveTo(0,0)..quadraticBezierTo(-w*.15,-h*.11,0,-h*.24)
        ..quadraticBezierTo(w*.15,-h*.1,0,0),Paint()..color=(k.isEven?AppColors.sage:AppColors.clay).withOpacity(.67));canvas.restore();
    }
  }
  @override bool shouldRepaint(covariant BotanicalPainter old)=>old.base!=base;
}
class SkinStat extends StatelessWidget {
  const SkinStat(this.label,this.value,{super.key,this.muted=false});
  final String label,value;final bool muted;
  @override Widget build(BuildContext context)=>Expanded(child:SkinCard(color:muted?AppColors.mist:AppColors.paper,
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label.toUpperCase(),style:AppTextStyles.label(10)),
      const SizedBox(height:10),Text(value,style:AppTextStyles.display(31))])));
}
class SkinNotice extends StatelessWidget {
  const SkinNotice(this.text,{super.key});final String text;
  @override Widget build(BuildContext context)=>SkinCard(color:AppColors.mist,child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
    const Icon(Icons.info_outline,color:AppColors.forest,size:18),const SizedBox(width:9),
    Expanded(child:Text(text,style:AppTextStyles.muted(12)))]));
}

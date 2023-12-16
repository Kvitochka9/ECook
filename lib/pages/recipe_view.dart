import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RecipeScreen extends StatelessWidget {
  final String name;
  final List<dynamic> idigo;
  final String url;
  final List<dynamic> steps;
  final bool isLiked;
  final int compl;
  final int time;

  RecipeScreen({
    required this.name,
    required this.idigo,
    required this.url,
    required this.steps,
    required this.isLiked,
    required this.compl,
    required this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       actions: [
         Padding(
           padding: const EdgeInsets.only(right: 22.0),
           child: Row(
             children: [
               Icon(Icons.star,color: compl>0? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
               Icon(Icons.star,color: compl>1? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
               Icon(Icons.star,color: compl>2? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
               Icon(Icons.star,color: compl>3? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
               Icon(Icons.star,color: compl>4? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
             ],
           ),
         )
       ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),image: DecorationImage(image: NetworkImage(url),fit: BoxFit.cover)),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' $name',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'BadScript-Regular',
                  ),
                ),
                Row(
                  children: [
                    Text('$timeхв ',style:TextStyle(fontSize: 28,fontWeight: FontWeight.w700,fontFamily: 'Caveat-VariableFont_wght' ),),
                    Icon(Icons.timer_sharp,size: 32,),
                  ],
                )
              ],
            ),
            SizedBox(height: 8.0),
            Container(color:Colors.black, height: 1.5, width: double.infinity,),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.only(left: 15,bottom: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.withOpacity(0.3)),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  itemList(name: 'Інгридієнти:',list: idigo),
                  SizedBox(height: 16.0,),
                  itemList(name: 'Приготування:',list: steps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget itemList({required name,required list}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(name,textAlign: TextAlign.left, style: TextStyle(fontSize:38,fontWeight: FontWeight.w600,fontFamily: 'Caveat-VariableFont_wght')),
          ],
        ),

    ListView.builder(
      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (context,index){
    return Text('- ${list[index]}\n',textAlign: TextAlign.left, style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700 ,fontFamily: 'Caveat-VariableFont_wght',color: Colors.black.withOpacity(0.6)));
    }),
      ],
    );
  }
}
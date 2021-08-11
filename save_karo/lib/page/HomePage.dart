import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_karo/page/MoviesPage.dart';
import 'package:save_karo/provider/GoogleSignInProvider.dart';
import 'package:save_karo/widget/BackgroundPainter.dart';
import 'package:save_karo/widget/LoggedInWidget.dart';
import 'package:save_karo/widget/SignUpWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return MoviesPage();
              } else {
                return SignUpWidget();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}

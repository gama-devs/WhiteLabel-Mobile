import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => new _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  var indexCarousel = 0; 
  PageController pageController;                                     
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

 
  @override
  Widget build(BuildContext context) {
  final List <String> image = ['assets/pizza.png','assets/entregadorpizza.png','assets/mulhercelular.png'];
  final List <String> textBold = ['Sua pizza favorita onde sempre deveria estar, na palma da sua mão.',
  'Receba nossa pizza quentinha no conforto da sua casa.',
  'Compre e ganhe pontos para trocar por produtos.'
  ];
  final List <String> textGrey = ['Um aplicativo para você aproveitar ao máximo o sabor e qualidade das nossas pizzas.',
  'Escolha quando e onde quer receber nossa pizza e aproveite esse momento.',
  'Um aplicativo para você aproveitar ao máximo o sabor e qualidade das nossas pizzas.'];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final nextButon = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFFF805D),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
          onPressed: (){
            print(textBold[indexCarousel]);
          },
          child: Text("Próximo  >",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Roboto',color: Colors.white),
        ),
      )
    );


    CarouselSlider carousel = CarouselSlider(
            options: CarouselOptions(
              height: 400,
              viewportFraction: 1,
              onPageChanged: (index,reason){
                print(index);
                setState(() {
                  indexCarousel = index;
                });
                print(indexCarousel);
              }
            ),
            items: image.map((item) => Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Image.asset(item, fit: BoxFit.cover,height: 400 ,width: MediaQuery.of(context).size.width),
                  ],
                ) 
              ),
            )).toList(),
    );

    Container carouselText = Container(
      child:Column(
        children: <Widget>[
          Text(
            textBold[indexCarousel],
            style: TextStyle(
              color: Color(0xFF413131),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              wordSpacing: 1),
              textAlign: TextAlign.center,),
          SizedBox(height: 30,),
          Text(
            textGrey[indexCarousel],style: TextStyle(
              color: Color(0xFF868484),
              fontSize: 15,
              wordSpacing: 1),
              textAlign: TextAlign.center,),
          SizedBox(height: 30,),
        ]
      )
    );

    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: (){},
                    icon:Icon(Icons.close)),
                  carousel,
                  carouselText,
                  nextButon
              ])),
        )
      ]),
    );
  }
}
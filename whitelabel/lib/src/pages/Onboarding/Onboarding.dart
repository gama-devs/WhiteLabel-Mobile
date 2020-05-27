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
  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  CarouselController buttonCarouselController = CarouselController();
  
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
  final List <String> buttonText = ["Próximo  >","Próximo  >","Ir para pizzas :D"];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    CarouselSlider carousel = CarouselSlider(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
        height: 450,
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
              Image.asset(item, fit: BoxFit.cover,height: 410 ,width: MediaQuery.of(context).size.width),
            ],
          ) 
        ),
      )).toList(),
    );


    checkBox(position,index){
      if(position == index){
        return SizedBox(
          height: 10,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0) ,
              color: Color(0xFFFF805D)
              ),
            ),
          );
      }
      return SizedBox(
        height: 7,
        width: 7,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0) ,
            color: Color(0xFFE5E5E5)
            ),
          ),
        );
    };

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFFFF805D),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
        onPressed: (){
          if(indexCarousel != 2) return buttonCarouselController.nextPage();

          else print(textBold[indexCarousel]);
        },
        child: Text(buttonText[indexCarousel],
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto',color: Colors.white),
      ),
    )
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
                  Stack(children: <Widget>[
                    IconButton(
                    onPressed: (){},
                    icon:Icon(Icons.close)),
                  carousel,
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      checkBox(0, indexCarousel),
                      SizedBox(width: 1,),
                      checkBox(1, indexCarousel),
                      SizedBox(width: 1,),
                      checkBox(2, indexCarousel)
                    ],),
                  SizedBox(height: 20,),
                  carouselText,
                  nextButton,
              ])),
        )
      ]),
    );
  }
}
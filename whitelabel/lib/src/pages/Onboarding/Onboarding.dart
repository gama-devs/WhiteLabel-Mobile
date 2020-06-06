import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:whitelabel/src/pages/CEP/cep.dart';

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
    final List<String> image = ['assets/3.png', 'assets/2.png', 'assets/1.png'];
    final List<String> textBold = [
      'Sua pizza favorita\n onde sempre deveria estar,\n na palma da sua mão.',
      'Receba nossa pizza quentinha no conforto da sua casa.',
      'Compre e ganhe pontos\n para trocar por produtos.'
    ];
    final List<String> textGrey = [
      'Um aplicativo para você aproveitar\n ao máximo o sabor e qualidade\n das nossas pizzas.',
      'Escolha quando e onde quer\n receber nossa pizza e aproveite\n esse momento.',
      'Um aplicativo para você aproveitar\n ao máximo o sabor e qualidade\n das nossas pizzas.'
    ];

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    CarouselSlider carousel = CarouselSlider(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height / 1.8,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            print(index);
            setState(() {
              indexCarousel = index;
            });
            print(indexCarousel);
          }),
      items: image
          .map((item) => Container(
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: Image.asset(
                          item,
                          fit: BoxFit.fitHeight,
                          width: MediaQuery.of(context).size.width,
                        )),
                  ],
                )),
              ))
          .toList(),
    );

    checkBox(position, index) {
      if (position == index) {
        return SizedBox(
          height: 10,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xFFFF805D)),
          ),
        );
      }
      return SizedBox(
        height: 7,
        width: 7,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color(0xFFE5E5E5)),
        ),
      );
    }

    ;

    final nextButton = Material(
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFFFF805D),
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 0),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
            onPressed: () {
              if (indexCarousel != 2)
                return buttonCarouselController.nextPage();
              else
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Cep()));
              print(textBold[indexCarousel]);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  indexCarousel == 0 || indexCarousel == 1
                      ? 'Próximo'
                      : 'Ir para pizzas 🤤',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Roboto', color: Colors.white),
                ),
                indexCarousel == 0 || indexCarousel == 1
                    ? Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.white,
                        ))
                    : Container(
                        width: 30,
                        height: 30,),
              ],
            ),
          )),
    );

    Container carouselText = Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
            width: 300,
            child: Text(
              textBold[indexCarousel],
              style: TextStyle(
                  color: Color(0xFF413131),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  wordSpacing: 1),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            textGrey[indexCarousel],
            style: TextStyle(
                color: Color(0xFF868484), fontSize: 16, wordSpacing: 1),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
        ]));

    return Scaffold(
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Positioned(
          child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                  padding: EdgeInsets.only(bottom: 50.0, left: 30, right: 30),
                  child: nextButton)),
        ),
        Container(
            padding: EdgeInsets.all(0.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      carousel,
                      new GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Cep()));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 40),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cep()));
                              },
                              icon: Icon(Icons.close)),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      checkBox(0, indexCarousel),
                      SizedBox(
                        width: 1,
                        height: 00,
                      ),
                      checkBox(1, indexCarousel),
                      SizedBox(
                        width: 1,
                      ),
                      checkBox(2, indexCarousel)
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Center(child: carouselText)
                ])),
      ]),
    );
  }
}

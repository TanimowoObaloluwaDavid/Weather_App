import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/Provider/theme_provider.dart';
import 'package:food/Services/api_service.dart';

class WeatherAppScreen extends ConsumerStatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  ConsumerState<WeatherAppScreen> createState() => _WeatherAppScreen();
}

class _WeatherAppScreen extends ConsumerState<WeatherAppScreen> {
  final _weatherServices = WeatherApiService();
  String city = "Surkhet";
  String country = '';
  Map<String,dynamic> currentValue ={};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];
bool isLoading = false;

@override
void initState(){
  //TODO:IMPLEMENT INISTATE ITS SIMPLE
  super.initState();
}


  Future<void> _fetchWeather() async {
  setState(() {
    isLoading = true;
  });

  try {
    final forecast = await _weatherServices.getHourlyForecast(city);
    final past = await _weatherServices.getPastSevenDaysWeather(city);

    setState(() {
      currentValue = forecast['current'] ?? {};
      hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
      next7days = forecast['forecast']?['forecastday'] ?? [];
      pastWeek = past;
      city = forecast['location']?['name'] ?? city;
      country = forecast['location']?['country'] ?? '';
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      currentValue = {};
      hourly = [];
      pastWeek = [];
      next7days = [];
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("City not found or invalid. Please enter a valid city name"),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;
   
   String iconPath = currentValue['condition']?['icon']??'';
   String ImageUrl = iconPath.isNotEmpty? "https:$iconPath":"";

    Widget imageWidgets =  ImageUrl.isNotEmpty?Image.network(ImageUrl,height: 200,width: 200,fit: BoxFit.cover):SizedBox();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(width: 25),
          SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              style: TextStyle( color: Theme.of(context).colorScheme.secondary),
              onSubmitted: (value){
                if(value.trim().isEmpty){
                   ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a city name"),
      ),
    );
    return;

                }
                city= value.trim();
                _fetchWeather();
              },
              decoration: InputDecoration(
                labelText: "Search City",
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.surface,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: ref.read(themeNotifierProvider.notifier).toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
          color:isDark ?Colors.black:Colors.white,size: 30,
            ),
          ),
          SizedBox(width: 25),
        ],
      ),
      // AppBar
body: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 20),
    if (isLoading)
      const Center(child: CircularProgressIndicator())
    else if (currentValue.isNotEmpty)
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$city${country.isNotEmpty ? ', $country' : ''}",
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 40,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text("${currentValue['temp_c']}°C," ,  style: TextStyle(
              fontSize: 50,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),),
            Text("${currentValue['condition']['text']}",
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onPrimary,
            ),),
            imageWidgets,
            Padding(padding: EdgeInsets.all(15),
            child: Container(height: 100, width: double.maxFinite,decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
               boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  offset: Offset(1, 1),
                  blurRadius: 10,
                  spreadRadius: 1,
                   
                )
               ],
               borderRadius: BorderRadius.circular(30),

            ),
        child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    /// for humidity
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://cdn-icons-png.flaticon.com/256/4148/4148460.png",
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 8),
        Text(
          "${currentValue['humidity']}%",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Humidity",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ),
    // for wind
     Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://cdn-icons-png.flaticon.com/512/5918/5918654.png",
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 8),
        Text(
          "${currentValue['wind_kph']}kph",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Wind",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
      //for maximum temperature
    ), 
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://cdn-icons-png.flaticon.com/256/6281/6281340.png",
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 8),
        Text(
        "${hourly.isNotEmpty ? hourly.map((h) => h["temp_c"]).reduce((a, b) => a > b ? a : b) : "N/A"}",

          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Max Temp",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ),
  ],
),
 ),
            ),
            
        ],
      ),
  ],
),
    );
  }
}

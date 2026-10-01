 import 'package:flutter/material.dart';

// ------------------------------------------------------------
// PROGRAM START
// ------------------------------------------------------------

void main() {
  // Flutter app ko start karta hai.
  // MyApp hamara root widget hai.
  runApp(const MyApp());
}

// ------------------------------------------------------------
// PARENT WIDGET
// ------------------------------------------------------------

// StatefulWidget use kiya hai kyunki MyApp ke andar
// aisa data hai jo change ho sakta hai.
//
// Yahan isDarkMode change hoga,
// isliye MyApp ko StatefulWidget banaya.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// ------------------------------------------------------------
// MyApp KI STATE
// ------------------------------------------------------------

class _MyAppState extends State<MyApp> {

  // ----------------------------------------------------------
  // GLOBAL / PARENT STATE
  // ----------------------------------------------------------

  // Ye theme ki state hai.
  //
  // false = Light Mode
  // true  = Dark Mode
  //
  // Ye state MyApp ke paas rakhi gayi hai.
  // Isliye MyApp parent hai aur HomeScreen child hai.
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ------------------------------------------------------
      // APP THEME
      // ------------------------------------------------------
      //
      // Agar isDarkMode true hai:
      //     Dark Theme
      //
      // Agar isDarkMode false hai:
      //     Light Theme
      //
      // Jab isDarkMode change hoga aur setState() chalega,
      // MyApp dobara build hoga aur theme bhi change hogi.

      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),

      // ------------------------------------------------------
      // HOME SCREEN KO DATA PASS KARNA
      // ------------------------------------------------------

      home: HomeScreen(

        // Parent ki state child ko pass kar rahe hain.
        //
        // MyApp:
        //     isDarkMode
        //
        // HomeScreen:
        //     widget.isDarkMode
        //
        isDarkMode: isDarkMode,

        // ----------------------------------------------------
        // CALLBACK FUNCTION
        // ----------------------------------------------------
        //
        // Child ke paas directly parent ki state change karne
        // ka access nahi hai.
        //
        // Isliye parent child ko ek function de raha hai.
        //
        // HomeScreen jab theme change karna chahega,
        // ye function call karega.
        //
        // value = Switch ki new value
        //
        onThemeChanged: (value) {

          // Parent ki state update kar rahe hain.
          setState(() {

            // New value ko isDarkMode mein store kar diya.
            isDarkMode = value;

            // ------------------------------------------------
            // YE STATE LIFTING HAI
            // ------------------------------------------------
            //
            // State ko child mein rakhne ke bajaye
            // parent mein rakha gaya.
            //
            // Child sirf event/function ke through parent ko
            // batata hai ki state change karni hai.
          });
        },
      ),
    );
  }
}

// ============================================================
// CHILD WIDGET
// ============================================================

// HomeScreen bhi StatefulWidget hai.
//
// Kyunki iske paas apni LOCAL STATE hai:
//     counter
//
// Saath hi ye parent se theme ki state receive karta hai.
class HomeScreen extends StatefulWidget {

  // ----------------------------------------------------------
  // PARENT SE AANE WALI VALUE
  // ----------------------------------------------------------

  // Parent se isDarkMode receive hoga.
  final bool isDarkMode;

  // ----------------------------------------------------------
  // PARENT SE AANE WALA FUNCTION
  // ----------------------------------------------------------

  // ValueChanged<bool> ka matlab:
  //
  // Ye ek function hai jo bool value receive karega.
  //
  // Example:
  // onThemeChanged(true);
  //
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,

    // Ye dono values parent se aani compulsory hain.
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ------------------------------------------------------------
// HomeScreen KI STATE
// ------------------------------------------------------------

class _HomeScreenState extends State<HomeScreen> {

  // ----------------------------------------------------------
  // LOCAL STATE
  // ----------------------------------------------------------

  // Ye counter sirf HomeScreen ke liye hai.
  //
  // Initially:
  // counter = 0
  //
  // Jab + button dabega:
  // counter = counter + 1
  //
  // Is state ko parent ki zarurat nahi hai,
  // isliye ye local state hai.
  int counter = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(

        title: const Text(
          'Quick State Management Demo',
        ),

        // AppBar ke right side mein widgets.
        actions: [

          // --------------------------------------------------
          // THEME SWITCH
          // --------------------------------------------------

          Switch(

            // Parent se received value use kar rahe hain.
            //
            // widget.isDarkMode
            //
            // Yahan "widget" ka matlab HomeScreen object hai.
            //
            value: widget.isDarkMode,

            // ------------------------------------------------
            // CHILD -> PARENT COMMUNICATION
            // ------------------------------------------------
            //
            // User Switch change karega.
            //
            // Flutter new bool value dega:
            //
            // true / false
            //
            // Ye value parent ke callback function ko
            // bhej di jayegi.
            //
            // Parent mein:
            //
            // isDarkMode = value
            //
            // aur setState() chalega.
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: Center(

        // NOTE:
        // Tumhare original code mein yahan:
        //
        // pressed: Column(...)
        //
        // diya hua hai.
        //
        // Center mein valid property "child" hoti hai.
        // Isliye compile karne ke liye ise:
        //
        // child: Column(...)
        //
        // karna hoga.

        child: Column(


          // Column ke children ko vertically center karega.
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // ------------------------------------------------
            // INFORMATION TEXT
            // ------------------------------------------------

            const Text(
              'Button dabane par counter badhega:',
            ),

            // ------------------------------------------------
            // COUNTER VALUE
            // ------------------------------------------------

            Text(

              // counter ki current value screen par show hogi.
              //
              // Example:
              // counter = 0
              // screen par "0"
              //
              // counter = 1
              // screen par "1"
              //
              '$counter',

              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // FLOATING ACTION BUTTON
      // ======================================================

      floatingActionButton: FloatingActionButton(

        // Jab button press hoga.
        onPressed: () {

          // --------------------------------------------------
          // LOCAL STATE UPDATE
          // --------------------------------------------------

          // setState Flutter ko batata hai:
          //
          // "Meri state change hui hai,
          //  widget ko dobara build karo."
          setState(() {

            // Counter ko 1 se increase kar rahe hain.
            //
            // counter++;
            //
            // same as:
            // counter = counter + 1;
            counter++;

            // ------------------------------------------------
            // YE LOCAL STATE MANAGEMENT HAI
            // ------------------------------------------------
            //
            // counter sirf HomeScreen mein use ho raha hai.
            // Isliye counter ki state HomeScreen ke andar hi hai.
          });
        },

        // Button ke andar + icon.
        child: const Icon(Icons.add),
      ),
    );
  }
}
 
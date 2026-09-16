import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // needed for FilteringTextInputFormatter
import 'package:flutter/gestures.dart'; // (نستخدمه بالـ Custom Scroll Behavior عشان نفعل سحب الماوس)
import 'dart:async'; // (نستخدمه بالـ Splash Screen عشان نأخر الانتقال ثواني)

import 'package:shared_preferences/shared_preferences.dart';

// هذا الباكدج يخلينا نطلع إشعارات 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//  يشغّل ملفات صوتية (من الإنترنت أو من الجهاز)
import 'package:audioplayers/audioplayers.dart';
//يشغّل فيديوهات (من الإنترنت أو من الجهاز)
import 'package:video_player/video_player.dart';
//  يفتح الكاميرا ويمسح رموز QR مباشرة (Live Scan)
import 'package:mobile_scanner/mobile_scanner.dart';
//  يفتح معرض الصور عشان يختار المستخدم صورة الفاتورة
import 'package:image_picker/image_picker.dart';

//  نظام الوضع الليلي/النهاري + قاموس اللغة 
class AppText {
  static const Map<String, Map<String, String>> _strings = {
    'ar': {
      'nav_home': 'الرئيسية',
      'nav_cart': 'السلة',
      'nav_profile': 'حسابي',
      'drawer_title': 'القائمة',
      'drawer_points': 'نقاطي',
      'drawer_sound': 'نغمة الإشعار',
      'drawer_gallery': 'معرض المنتجات',
      'drawer_video': 'فيديو تعريفي',
      'drawer_about': 'عن التطبيق',
      'drawer_contact': 'تواصل معنا',
      'drawer_settings': 'الإعدادات',
      'home_title': 'المنتجات',
      'search_hint': 'ابحث عن منتج...',
      'category_all': 'الكل',
      'category_headphones': 'سماعات',
      'category_watches': 'ساعات',
      'category_chargers': 'شواحن',
      'category_accessories': 'اكسسوارات',
      'category_protection': 'حمايه',
      'banner_summer': 'عروض الصيف 🔥',
      'banner_discount': 'خصم 20% على الطلب',
      'banner_shipping': 'شحن مجاني هالأسبوع',
      'cart_title': 'السلة',
      'cart_empty': 'سلتك فارغة حالياً',
      'cart_pay_button': 'الدفع',
      'payment_title': 'الدفع',
      'payment_total': 'إجمالي المبلغ',
      'payment_card_number': 'رقم البطاقة',
      'payment_card_holder': 'اسم حامل البطاقة',
      'payment_pay_now': 'ادفعي الآن',
      'payment_success': 'تم الدفع بنجاح ✅',
      'payment_back': 'رجوع',
      'tab_description': 'الوصف',
      'tab_specs': 'المواصفات',
      'tab_reviews': 'التقييمات',
      'product_add_to_cart': 'أضف للسلة',
      'product_added': '✓ تمت الإضافة للسلة',
      'product_rate_this': 'قيّمي هذا المنتج',
      'product_your_rating': 'تقييمك',
      'product_faq_title': 'أسئلة شائعة',
      'settings_title': 'الإعدادات',
      'settings_notifications': 'تفعيل الإشعارات',
      'settings_dark_mode': 'الوضع الليلي',
      'settings_language': 'اللغة',
      'settings_arabic': 'العربية',
      'settings_english': 'English',
      'profile_title': 'الملف الشخصي',
      'profile_default_name': 'اسم المستخدم',
    },
    'en': {
      'nav_home': 'Home',
      'nav_cart': 'Cart',
      'nav_profile': 'Profile',
      'drawer_title': 'Menu',
      'drawer_points': 'My Points',
      'drawer_sound': 'Notification Tone',
      'drawer_gallery': 'Product Gallery',
      'drawer_video': 'Intro Video',
      'drawer_about': 'About',
      'drawer_contact': 'Contact Us',
      'drawer_settings': 'Settings',
      'home_title': 'Products',
      'search_hint': 'Search for a product...',
      'category_all': 'All',
      'category_headphones': 'Headphones',
      'category_watches': 'Watches',
      'category_chargers': 'Chargers',
      'category_accessories': 'Accessories',
      'category_protection': 'Protection',
      'banner_summer': 'Summer Offers 🔥',
      'banner_discount': '20% off your order',
      'banner_shipping': 'Free shipping this week',
      'cart_title': 'Cart',
      'cart_empty': 'Your cart is empty',
      'cart_pay_button': 'Pay',
      'payment_title': 'Payment',
      'payment_total': 'Total amount',
      'payment_card_number': 'Card number',
      'payment_card_holder': 'Card holder name',
      'payment_pay_now': 'Pay now',
      'payment_success': 'Payment successful ✅',
      'payment_back': 'Back',
      'tab_description': 'Description',
      'tab_specs': 'Specs',
      'tab_reviews': 'Reviews',
      'product_add_to_cart': 'Add to cart',
      'product_added': '✓ Added to cart',
      'product_rate_this': 'Rate this product',
      'product_your_rating': 'Your rating',
      'product_faq_title': 'FAQ',
      'settings_title': 'Settings',
      'settings_notifications': 'Enable notifications',
      'settings_dark_mode': 'Dark mode',
      'settings_language': 'Language',
      'settings_arabic': 'العربية',
      'settings_english': 'English',
      'profile_title': 'Profile',
      'profile_default_name': 'Username',
    },
  };

  // يرجع النص المترجم لمفتاح معين حسب اللغة الحالية
  // لو المفتاح غير موجود يرجع نفسه (احتياط عشان ما يطلع فاضي)
  static String get(String key, String languageCode) {
    return _strings[languageCode]?[key] ?? _strings['ar']![key] ?? key;
  }
}

// InheritedWidget يحمل اللغة الحالية للتطبيق ويوصلها لأي صفحة
class AppLocale extends InheritedWidget {
  final Locale locale;
  const AppLocale({super.key, required this.locale, required super.child});

  static AppLocale of(BuildContext context) {
    final AppLocale? result =
        context.dependOnInheritedWidgetOfExactType<AppLocale>();
    assert(result != null, 'No AppLocale found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppLocale oldWidget) => oldWidget.locale != locale;
}

//دالة مختصرة نستخدمها بكل الصفحات لجلب النص المترجم بسطر واحد
//  Text(tr(context, 'home_title'))
String tr(BuildContext context, String key) {
  final String languageCode = AppLocale.of(context).locale.languageCode;
  return AppText.get(key, languageCode);
}
// ================================================================================================

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// دالة تهيئة (Setup) الإشعارات - تشتغل مرة وحدة بس عند فتح التطبيق
Future<void> _initNotifications() async {
  // AndroidInitializationSettings: يحدد أيقونة الإشعار على أندرويد
  // '@mipmap/ic_launcher' هي نفس أيقونة التطبيق الافتراضية
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(settings: initSettings);

  final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

  // يطلع بوب-أب فعلي للمستخدم يسألها "تسمحين بالإشعارات؟" (نعم/لا)
  // نفس أي تطبيق ثاني افتحه أول مرة ويطلب صلاحية
  await androidPlugin?.requestNotificationsPermission();
  // ======================================================================================
}

//  دالة عامة مساعدة تطلع إشعار بعنوان ونص - نستدعيها من أي صفحة بالتطبيق
Future<void> showLocalNotification({
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'cart_channel', // معرف فريد للقناة
    'إشعارات المتجر', // اسم القناة يظهر بإعدادات النظام
    channelDescription: 'إشعارات تخص السلة والإعدادات بالتطبيق',
    importance: Importance.high, //  أهمية عالية = يظهر فوراً بأعلى الشاشة
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  // show:يطلع الإشعار فعلياً
  await flutterLocalNotificationsPlugin.show(
    id: 0,
    title: title,
    body: body,
    notificationDetails: details,
  );
}

void main() async {
  //  WidgetsFlutterBinding.ensureInitialized() لازم نستدعيها قبل أي كود async
  // بدالة main() قبل runApp، لأن initialize() فوق async ويحتاج فلاتر يكون جاهز أول
  WidgetsFlutterBinding.ensureInitialized();

  //  نجهز الإشعارات قبل ما نفتح التطبيق
  await _initNotifications();

  runApp(const MyApp());
}

// ======================================================
// Custom Scroll Behavior
// فلاتر افتراضياً ما يسمح بالسحب بالماوس على  widget قابل للتمرير
// ======================================================
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse, //  نضيف الماوس كجهاز مسموح له يسحب
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

// Root widget of the whole app
//راح يجمع ال 3 صفحات
// حولنا MyApp من StatelessWidget إلى StatefulWidget عشان نقدر
// نتحكم بالوضع الليلي/النهاري واللغة (عربي/إنجليزي) ونغيّرهم فعلياً وقت التشغيل
class MyApp extends StatefulWidget {// تشغل التطبيق
  const MyApp({super.key});//الكونستركتور ويتكرر بكل الصفحات

  // دوال ثابتة (static) تقدر أي صفحة بالتطبيق تستدعيها عشان تغيّر
  // الوضع الليلي أو اللغة، بدون ما تحتاج تعرف تفاصيل حالة MyApp الداخلية
  static void setThemeMode(BuildContext context, ThemeMode mode) {
    context.findAncestorStateOfType<_MyAppState>()?._updateThemeMode(mode);
  }

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_MyAppState>()?._updateLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // القيم الافتراضية - فاتح وعربي، وتتغير لو فيه إعدادات محفوظة سابقاً
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  // نقرأ آخر وضع (ليلي/نهاري) وآخر لغة محفوظة على الجهاز، لو المستخدمة
  // غيّرتها بمرة سابقة، عشان تبقى محفوظة حتى بعد إغلاق التطبيق وفتحه
  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _themeMode =
          (prefs.getBool('darkMode') ?? false) ? ThemeMode.dark : ThemeMode.light;
      _locale = Locale(prefs.getString('language') ?? 'ar');
    });
  }

  // تغيّر الوضع الليلي فوراً على كامل التطبيق
  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  // تغيّر اللغة فوراً على كامل التطبيق
  void _updateLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override//داله موروثه
  Widget build(BuildContext context) {
    return AppLocale(
      locale: _locale,
      child: MaterialApp(
        title: 'My Store',// اسم التطبيق 
        debugShowCheckedModeBanner: false,
        // MODIFIED: صار عندنا ثيم فاتح وثيم داكن، والتبديل بينهم يعتمد على themeMode
        theme: ThemeData(primarySwatch: Colors.teal, brightness: Brightness.light),
        darkTheme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        themeMode: _themeMode, //يقرر فلاتر يستخدم الثيم الفاتح أو الداكن حسب هالقيمة
        //  نفعّل سلوك السحب المخصص فوق على كل التطبيق
        scrollBehavior: MyCustomScrollBehavior(),
        // builder يفرض اتجاه الكتابة (يمين-لشمال بالعربي، شمال-ليمين
        // بالإنجليزي) على كل شاشات التطبيق تلقائياً حسب اللغة الحالية
        builder: (context, child) {
          return Directionality(
            textDirection:
                _locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          );
        },
        // بدل ما نفتح التطبيق مباشرة على SignupPage
        // صرنا نفتحه على SplashScreen (شاشة اللوقو/اللانش) وهي اللي بعدين توديه للتسجيل
        home: const SplashScreen(), // first screen shown when app starts
      ),
    );
  }
}

// ======================================================
//  SPLASH SCREEN (Launch Image)
// شاشة بسيطة تظهر أول ما يفتح المستخدم التطبيق (فيها لوقو/صورة)
// وبعد ثواني معينة تسكّر نفسها وتنتقل تلقائياً لصفحة SignupPage
// ======================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer يشتغل مره وحده بعد 3 ثواني من فتح الصفحة
    Timer(const Duration(seconds: 3), () {
      // pushReplacement عشان نمسح شاشة السبلاش من الستاك
      // بحيث لو ضغط المستخدم "رجوع" ما يرجع لها تاني
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // خلفية شاشة اللانش بلون التطبيق الأساسي
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // صورة/لوقو التطبيق - احط مسار  الصوره
            Image.asset(
              'assets/images/logo.png',
              width: 140,
              height: 140,
              errorBuilder: (context, error, stackTrace) {
                // لو الصورة مو موجودة يعرض أيقونة بديلة بدل ما يطلع خطأ
                return const Icon(
                  Icons.shopping_bag,
                  size: 100,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Signup Demo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.white), // مؤشر تحميل بسيط
          ],
        ),
      ),
    );
  }
}

// ======================================================
// SIGNUP PAGE
// ======================================================
class SignupPage extends StatefulWidget { //فيها حقول تتغير مثل اسم المستخدم ورقمه علشان كذا ورث من هالكلاس 
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {//جزء الغلاف فيه كل المتغيرات 
  // GlobalKey lets us control and validate the Form
  final _formKey = GlobalKey<FormState>();

  // Controllers to read what the user types in each field
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override//اذا طلعت من الصفحه يريح الذاكره عشان مايكون فيها تسريب 
  void dispose() {
    // Always dispose controllers to free memory when the page closes
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override//رسم الصفحه
  Widget build(BuildContext context) {
    return Scaffold(// الاب بار الهيكل العام لاي صفحه
      appBar: AppBar(title: const Text('Sign Up')),//الشريط العلوي اللي فيه عنوان الصفحه
      body: Padding(
        padding: const EdgeInsets.all(20),//تضيف مسافه فاضيه حوالين المحتوى عشان مايلزق بحواف الشاشه
        child: Form(// تجمع حقول الادخال كله وتربطهم مع بعض
          key: _formKey, // connects this Form to _formKey
          child: Column(// نربط العناصر عموديا 
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Name field ----------
              TextFormField(// صندوق الكتابه
                controller: nameController,// يربط الصندوق بالكونترولر الي سويناه قبل >>المراقب 
                decoration: const InputDecoration(// شكل الصندوق و الحدود الي حوله
                  hintText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {// داله تتاكد من صحه كتابه المستخدم 
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';// اذا فارغ بيقول خطا
                  }
                  return null; // null means valid اذا تمام مراح ترجع شي
                },
              ),
              const SizedBox(height: 16),

              // ---------- Phone field ----------
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number, // opens numeric keyboard يفتح للمستخدم الارقام فقط
                inputFormatters: [// قائمه قواعد تحدد ايش المسموح يكتب بالصندوق
                  FilteringTextInputFormatter.digitsOnly, // only digits allowed يمنع اي شي مو رقم حتى لو المستخد الصق نص 
                  LengthLimitingTextInputFormatter(11), // max 11 characters  يمنع الكتابه بعد الوصول ل 11 يعني مايقدر يكتب 12 اثناء الكتابه 
                ],
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {// يتاكد ان طول الرقم 11  ويشتغل لما اضغط الزر
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 11) {
                    return 'Phone number must be exactly 11 digits';
                  }
                  if (!value.startsWith('05')) {           
                        return 'Phone number must start with 05';
                  }
                  return null;

                },
              ),
              const SizedBox(height: 16),

              // ---------- Email field ----------
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Password field ----------
              TextFormField(
                controller: passwordController,
                obscureText: true, // hides the typed characters
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // ---------- Sign Up button ----------
              ElevatedButton(
                onPressed: () {// لما يضغط الزر سوي هالشيء 
                  // validate() runs every validator above
                  if (_formKey.currentState!.validate()) {// اذا الحقول صحيحه سوي الانتقال 
                    // if all fields are valid -> go to LoginPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// LOGIN PAGE
// ======================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Phone field ----------
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length != 11) {
                    return 'Enter a valid 11-digit phone number';
                  }
                  if (!value.startsWith('05')) {           
                        return 'Phone number must start with 05';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Password field ----------
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // ---------- Login button ----------
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // if valid -> go to HomePage
                    // pushReplacement removes LoginPage from the back stack
                    // MODIFIED: بدل ما نروح مباشرة لـ HomePage
                    // صرنا نروح لـ MainScreen اللي هي الصفحة الحاوية على BottomNavigationBar
                    // وهي اللي بداخلها HomePage كأول تبويب
                    Navigator.pushReplacement(// احذف صفحه اللوجن و استبدلها بصفحه الهوم 
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// MAIN SCREEN (Bottom Navigation Bar Container)
// هذي الصفحة هي اللي فيها الـ BottomNavigationBar بثلاث أيقونات
// (Home - Cart - Profile) وتتحكم بأي صفحة تظهر فوق حسب الأيقونة المختارة
// ======================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // متغير يحفظ رقم التبويب المختار حالياً (0 = Home, 1 = Cart, 2 = Profile)
  int _selectedIndex = 0;

  // قائمة الصفحات اللي راح تتبدل فوق حسب الأيقونة اللي نضغطها
  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    ProfilePage(),
  ];

  // تستدعى كل ما يضغط المستخدم على أيقونة جديدة بالبار
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // نحدث الفهرس فيعيد بناء الواجهة على الصفحة الجديدة
    });
  }

  @override
  Widget build(BuildContext context) {
    //  MediaQuery - نجيب عرض الشاشة عشان نقرر أي نوع تنقل نعرض
    final screenWidth = MediaQuery.of(context).size.width;
    // لو الشاشة عريضة (تابلت/ويب) نعتبرها "واسعة"
    final bool isWideScreen = screenWidth > 700;

    return Scaffold(
      // MODIFIED: صار body عبارة عن Row لما تكون الشاشة واسعة
      // عشان نقدر نحط NavigationRail على اليمين وباقي المحتوى بجنبه
      body: Row(
        children: [
          // ----------  NavigationRail ----------
          // يظهر بس لو الشاشة واسعة (تابلت/ويب) - شريط تنقل عمودي جنبي
          // بديل عن BottomNavigationBar بالشاشات الكبيرة (نفس فكرة الـ Responsive قبل)
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped, // نفس دالة تغيير الفهرس المستخدمة بالبار تحت
              labelType: NavigationRailLabelType.all, // يعرض التسمية تحت كل أيقونة دايماً
              selectedIconTheme: const IconThemeData(color: Colors.teal),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home),
                  label: Text(tr(context, 'nav_home')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(tr(context, 'nav_cart')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person),
                  label: Text(tr(context, 'nav_profile')),
                ),
              ],
            ),
          // IndexedStack يحافظ على حالة كل صفحة (زي مكان السكرول) حتى لو بدلنا التبويب
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      // MODIFIED: نعرض BottomNavigationBar بس لو الشاشة مو واسعة
      // (لأن NavigationRail فوق أخذ مكانه بالشاشات الواسعة)
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
        currentIndex: _selectedIndex, // الأيقونة المضغوطة حالياً تنلون
        selectedItemColor: Colors.teal, // لون الأيقونة المختارة
        unselectedItemColor: Colors.grey, // لون باقي الأيقونات
        onTap: _onItemTapped, // كل ما يضغط أيقونة تستدعي الدالة فوق
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr(context, 'nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: tr(context, 'nav_cart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: tr(context, 'nav_profile'),
          ),
        ],
      ),
    );
  }
}

// ======================================================
//  CART PAGE
// ======================================================
// ======================================================
// MODIFIED: CART PAGE - حولناها من StatelessWidget إلى StatefulWidget
// عشان نقدر نحذف عنصر من القائمة ونحدث الواجهة بـ setState
// ======================================================
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //  قائمة تجريبية لعناصر السلة (بيانات وهمية للتجربة)
  final List<Product> _cartItems = [
    Product(name: 'سماعات لاسلكية 1', price: 25.0, imageUrl: 'assets/images/prod1.png', category: 'سماعات'),
    Product(name: 'ساعة ذكية 1', price: 32.5, imageUrl: 'assets/images/prod2.png', category: 'ساعات'),
    Product(name: 'شاحن سريع 1', price: 47.5, imageUrl: 'assets/images/prod4.png', category: 'شواحن'),
  ];

  // ============================= NEW (Payment) =============================
  // مجموع أسعار كل عناصر السلة الحالية - نمرره لصفحة الدفع كمبلغ إجمالي
  double get _totalPrice =>
      _cartItems.fold(0.0, (double sum, Product item) => sum + item.price);

  //  تفتح صفحة الدفع وتنتظر النتيجة
  // لو رجعت true (يعني الدفع تم بنجاح فعلاً) نفضّي السلة كاملة
  Future<void> _goToPayment() async {
    if (_cartItems.isEmpty) return;

    final bool? paymentSucceeded = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(totalAmount: _totalPrice),
      ),
    );

    if (paymentSucceeded == true && mounted) {
      setState(() {
        _cartItems.clear(); //  نفضّي السلة بعد نجاح الدفع فعلياً
      });
    }
  }
  // ================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'cart_title')),
        centerTitle: true,
      ),
      // MODIFIED: لو السلة فاضية نعرض نفس رسالة "سلتك فارغة"، غير كذا نعرض القائمة
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    tr(context, 'cart_empty'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          // ---------- MODIFIED: ListView.builder -> ReorderableListView.builder ----------
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _cartItems.length,
              // ADDED: onReorder تستدعى تلقائياً بعد ما نفلت العنصر بمكانه الجديد
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  // تعديل بسيط لازم لـ ReorderableListView تحديداً:
                  // لو حركنا العنصر لأسفل، الفهرس الجديد يكون أكبر بواحد أكثر من اللازم
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _cartItems.removeAt(oldIndex);
                  _cartItems.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Dismissible(
                  key: ValueKey(item.name), // مفتاح فريد لكل عنصر - لازم يكون فريد عشان فلاتر يميز أي عنصر انسحب
                  direction: DismissDirection.endToStart, // اتجاه السحب: من اليمين لليسار بس
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    //  setState - نحذف العنصر من القائمة الفعلية ونحدث الواجهة
                    setState(() {
                      _cartItems.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      child: const Icon(Icons.shopping_bag, color: Colors.teal),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.price.toStringAsFixed(2)} ر.س'),
                    //  أيقونة صغيرة تلمّح إن العنصر قابل للسحب لإعادة الترتيب
                    trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                );
              },
            ),
      // ============================= NEW (Payment) =============================
      // شريط سفلي فيه إجمالي السعر وزر "الدفع" - يظهر بس لو السلة فيها منتجات
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    '${tr(context, 'cart_pay_button')} (${_totalPrice.toStringAsFixed(2)} ر.س)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
      // ================================================================================
    );
  }
}

// ======================================================
//  PAYMENT PAGE
// MODIFIED: صفحة دفع شكلية (UI Only) بدون أي باكدج خارجي وبدون أي اتصال
// حقيقي بأي بوابة دفع - بس واجهة تحاكي شكل الدفع (حقول بطاقة + تحميل +
// نجاح) بناءً على طلب المدرب: "استخدموه بس UI بدون API مانربط أبد"
// ======================================================
class PaymentPage extends StatefulWidget {
  // المبلغ الإجمالي اللي راح تدفعه (نستقبله من صفحة السلة)
  final double totalAmount;
  const PaymentPage({super.key, required this.totalAmount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  //  مفتاح الفورم عشان نتأكد إن الحقول متعبية قبل "الدفع"
  final _formKey = GlobalKey<FormState>();

  // ADDED: كونترولرز حقول البطاقة الشكلية
  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  // نتابع فيها هل العملية "شغالة" حالياً (نعرض مؤشر تحميل شكلي)
  bool _isProcessing = false;

  // نتابع فيها هل الدفع "تم" (نغيّر شكل الصفحة كامل)
  bool _isPaid = false;

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  // محاكاة عملية الدفع - تأخير بسيط (زي انتظار السيرفر) ثم نجاح
  // مباشرة، بدون أي استدعاء حقيقي لأي API أو باكدج دفع خارجي
  Future<void> _startPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    //  تأخير شكلي بس عشان يحس المستخدم إن فيه "معالجة" حقيقية
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _isPaid = true; // دايماً تنجح - ماكو اتصال حقيقي نتأكد منه
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'payment_title')), centerTitle: true),
      body: Center(
        child: _isPaid
            // ---------- حالة "نجاح" الدفع ----------
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 90),
                  const SizedBox(height: 16),
                  Text(
                    tr(context, 'payment_success'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    // MODIFIED: نرجع true لصفحة السلة عشان تفضّي السلة
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(tr(context, 'payment_back'),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            // ---------- حالة ما قبل الدفع - فورم البطاقة الشكلي ----------
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.credit_card, color: Colors.teal, size: 70),
                      const SizedBox(height: 12),
                      Text(
                        '${tr(context, 'payment_total')}: ${widget.totalAmount.toStringAsFixed(2)} ر.س',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // ---------- رقم البطاقة ----------
                      TextFormField(
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        decoration: InputDecoration(
                          hintText: tr(context, 'payment_card_number'),
                          prefixIcon: const Icon(Icons.credit_card),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.length != 16) {
                            return 'رقم البطاقة لازم يكون 16 رقم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // ---------- اسم حامل البطاقة ----------
                      TextFormField(
                        controller: cardHolderController,
                        decoration: InputDecoration(
                          hintText: tr(context, 'payment_card_holder'),
                          prefixIcon: const Icon(Icons.person_outline),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم حامل البطاقة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // ---------- تاريخ الانتهاء + CVV ----------
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: expiryController,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: const InputDecoration(
                                hintText: 'MM/YY',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.length != 5) {
                                  return 'صيغة غير صحيحة';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(
                                hintText: 'CVV',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.length != 3) {
                                  return 'CVV غير صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // ---------- زر الدفع ----------
                      _isProcessing
                          ? const Center(
                              child: CircularProgressIndicator(color: Colors.teal),
                            )
                          : ElevatedButton(
                              onPressed: _startPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(tr(context, 'payment_pay_now'),
                                  style: const TextStyle(color: Colors.white)),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ======================================================
//  PROFILE PAGE
// ======================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'profile_title')),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              tr(context, 'profile_default_name'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// PRODUCT MODEL تنسيق شكل كل منتج 
// ======================================================
class Product {// الاسم-السعر-الصوره
  final String name;
  final double price;
  final String imageUrl;
  final String category; // تصنيف المنتج - نستخدمه بالفلترة حسب الشيبة المختارة
  final double rating; //التقييم العام للمنتج (من 0 إلى 5)

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category, 
    this.rating = 4.0, //  قيمة افتراضية لو ما مررناها
  });
}

// ======================================================
//  ABOUT PAGE
// صفحة بسيطة تفتح لما نختار "عن التطبيق" من الـ Drawer
// ======================================================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق'), centerTitle: true),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.storefront, size: 60, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              'متجرنا',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'تطبيق تسوق بسيط يعرض منتجات متنوعة بأسعار مناسبة، تم تطويره كمشروع تدريبي باستخدام Flutter.',
              style: TextStyle(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
//  CONTACT PAGE
// صفحة بسيطة تفتح لما نختار "تواصل معنا" من الـ Drawer
// ======================================================
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تواصل معنا'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: const Text('البريد الإلكتروني'),
              subtitle: const Text('support@mystore.com'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text('الهاتف'),
              subtitle: const Text('0500000000'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.teal),
              title: const Text('العنوان'),
              subtitle: const Text('القصيم، السعودية'),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
//  SETTINGS PAGE
// صفحة بسيطة تفتح لما نختار "الإعدادات" من الـ Drawer
// ======================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  //  نتابع فيها اللغة الحالية المختارة ('ar' أو 'en')
  String _language = 'ar';

  // ============================= NEW PACKAGE (shared_preferences) =============================
  //  initState تشتغل مرة وحدة بس أول ما تفتح صفحة الإعدادات
  // نستخدمها هنا عشان "نقرأ" القيم المحفوظة سابقاً من الجهاز
  // (لو المستخدم فعّل الوضع الليلي قبل وقفل التطبيق، لازم يرجع مفعّل تلقائياً)
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  //  دالة قراءة القيم المحفوظة على الجهاز
  // SharedPreferences.getInstance() يفتح لنا "صندوق" التخزين المحلي
  // ثم getBool(key) يجيب القيمة المحفوظة تحت هذا المفتاح
  // ?? true / ?? false = قيمة افتراضية لو ما فيه شي محفوظ أصلاً (أول مرة يفتح التطبيق)
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // نتأكد إن الصفحة لسا مفتوحة قبل ما نستخدم setState
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'ar'; 
    });
  }

  //  دالة حفظ قيمة bool جديدة على الجهاز
  // نستدعيها كل ما المستخدم يضغط على أي سويتش، فتحفظ التغيير فوراً
  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  //  دالة حفظ اللغة المختارة على الجهاز
  Future<void> _saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
  }
  // ================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'settings_title')), centerTitle: true),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(tr(context, 'settings_notifications')),
            value: _notificationsEnabled,
            activeColor: Colors.teal,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications', value); // نحفظ القيمة الجديدة فوراً على الجهاز

              // ============================= NEW PACKAGE (flutter_local_notifications) =============================
              // لو المستخدم فعّل الإشعارات، نطلع له إشعار حقيقي فوراً كتأكيد
              // (يظهر بشريط إشعارات الجهاز نفسه، مو رسالة داخل التطبيق بس)
              if (value) {
                showLocalNotification(
                  title: 'الإشعارات مفعّلة ✅',
                  body: 'سوف تصلك إشعارات عند إضافة أي منتج للسلة',
                );
              }
              // ======================================================================================
            },
          ),
          // ---------- MODIFIED: هذا السويتش صار يغيّر الوضع فعلياً على كامل التطبيق ----------
          SwitchListTile(
            title: Text(tr(context, 'settings_dark_mode')),
            value: _darkModeEnabled,
            activeColor: Colors.teal,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              _saveSetting('darkMode', value); // نحفظ القيمة الجديدة فوراً على الجهاز
              //  نطبّق التغيير فوراً على كامل التطبيق عن طريق MyApp
              MyApp.setThemeMode(context, value ? ThemeMode.dark : ThemeMode.light);
            },
          ),

          const Divider(),

          // ----------قسم اختيار اللغة (عربي/إنجليزي) ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                tr(context, 'settings_language'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          RadioListTile<String>(
            title: Text(tr(context, 'settings_arabic')),
            value: 'ar',
            groupValue: _language,
            activeColor: Colors.teal,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _language = value);
              _saveLanguage(value);
              // نطبّق تغيير اللغة فوراً على كامل التطبيق عن طريق MyApp
              MyApp.setLocale(context, Locale(value));
            },
          ),
          RadioListTile<String>(
            title: Text(tr(context, 'settings_english')),
            value: 'en',
            groupValue: _language,
            activeColor: Colors.teal,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _language = value);
              _saveLanguage(value);
              MyApp.setLocale(context, Locale(value));
            },
          ),
        ],
      ),
    );
  }
}

// ======================================================
// HOME PAGE
// Shows 30 products, 2 per row, in a professional-looking grid
// ======================================================
// MODIFIED: حولنا HomePage من StatelessWidget إلى StatefulWidget
// السبب: عشان نقدر نستخدم setState ونخلي التصنيف اللي نضغطه يتلوّن
// (StatelessWidget ما تقدر تستخدم setState لأن ماله "حالة" تتغير أصلاً)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // نخزن المنتجات كمتغير حالة (state) بدل ما نولدها من جديد بكل build
  // كذا لما نستخدم RefreshIndicator نقدر "نحدثها" فعلياً ونشوف فرق واضح
  late List<Product> _allProducts;

  final TextEditingController _searchController = TextEditingController();

  int _selectedDrawerIndex = 0;
  Timer? _searchDebounce;

  //  initState تشتغل مرة وحدة بس أول ما تفتح الصفحة
  // نستخدمها هنا عشان نولد قائمة المنتجات أول مرة فقط
  @override
  void initState() {
    super.initState();
    _allProducts = _generateProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel(); // نلغي أي Timer شغال قبل ما تسكر الصفحة
    super.dispose();
  }

  // Generates a list of 30 sample products. داله تولد المنتجات تلقائيا
  // In a real app this list would come from a database or an API instead.
  List<Product> _generateProducts() {
    final baseNames = [// تحتوي على 10 اسماء منتجات اساسيه
      'سماعات لاسلكية',
      'ساعة ذكية',
      'كابل شحن',
      'شاحن سريع',
      'باور بانك',
      'حافظة جوال',
      'سبيكر بلوتوث',
      'كيبورد لاسلكي',
      'ماوس لاسلكي',
      'شاشة حماية',
    ];

    //  تصنيف كل اسم من baseNames - نفس الترتيب بالضبط
    // مطابق لأسماء الشيبات اللي بالـ Wrap فوق (_categories)
    final categoriesForNames = [
      'سماعات',    // سماعات لاسلكية
      'ساعات',     // ساعة ذكية
      'شواحن',     // كابل شحن
      'شواحن',     // شاحن سريع
      'شواحن',     // باور بانك
      'اكسسوارات', // حافظة جوال
      'سماعات',    // سبيكر بلوتوث
      'اكسسوارات', // كيبورد لاسلكي
      'اكسسوارات', // ماوس لاسلكي
      'حمايه',     // شاشة حماية
    ];

  return List.generate(30, (index) {// 30 منتج ويمر بعداد
      final baseName = baseNames[index % baseNames.length];
      
      // 1. هنا حددي عدد صورك الحقيقية (لو عندك مثلاً 5 صور سميتيها prod1, prod2...)
      int imageNumber = (index % 10) + 1; // يولد ارقام للصور من 1 الى 10

      return Product(
        name: '$baseName ${(index ~/ baseNames.length) + 1}',// دمج الاسم مع رقم المجموعه 
        price: 25.0 + (index * 7.5),// حساب بسعر المنتج تلقائي يبدرا من 25 ويزيد كل مره 7.5 كل لفه 
        
        // 2. تم تغيير المسار هنا ليكون داخلياً من مجلد assets اللي أضفتيه
        imageUrl: 'assets/images/prod$imageNumber.png', // حطيت مسار الصور 
        // ADDED: ناخذ نفس فهرس baseName عشان التصنيف يطابق الاسم بالضبط
        category: categoriesForNames[index % categoriesForNames.length],
        // ADDED: تقييم تجريبي مختلف لكل منتج (يتراوح تقريباً بين 3.5 و 5.0)
        rating: (3.5 + (index % 6) * 0.25).clamp(3.0, 5.0),
      );
    });
  }
  //  قائمة تصنيفات ثابتة نعرضها بالـ Wrap فوق الشبكة
  final List<String> _categories = const [
    'الكل', 'سماعات', 'ساعات', 'شواحن', 'اكسسوارات', 'حمايه',
  ];

  //  هذا هو "الحالة" (state) - يحفظ التصنيف المختار حالياً
  // أول ما تفتح الصفحة يكون "الكل" هو المختار افتراضياً
  String _selectedCategory = 'الكل';

  // يحفظ نص البحث اللي تكتبه بشريط SearchBar
  String _searchQuery = '';

  String _categoryLabel(BuildContext context, String cat) {
    const Map<String, String> keys = {
      'الكل': 'category_all',
      'سماعات': 'category_headphones',
      'ساعات': 'category_watches',
      'شواحن': 'category_chargers',
      'اكسسوارات': 'category_accessories',
      'حمايه': 'category_protection',
    };
    final String? key = keys[cat];
    return key != null ? tr(context, key) : cat;
  }

  Widget _buildBanner(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

// بناء الواجهه الرسميه 
  @override
  Widget build(BuildContext context) {
    // MODIFIED: صرنا نستخدم _allProducts (المخزنة بالحالة) بدل توليد جديد كل build

    // هنا نفعّل الفلترة الحقيقية
    // لو التصنيف المختار "الكل" نعرض كل المنتجات زي ماهي
    // غير كذا نعرض بس المنتجات اللي category تبعها يطابق التصنيف المختار
    // MODIFIED: ضفنا شرط ثاني بعد فلترة التصنيف - يتأكد إن اسم المنتج يحتوي على نص البحث
    final filteredProducts = _allProducts.where((p) {
      final matchesCategory =
          _selectedCategory == 'الكل' || p.category == _selectedCategory;
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // MediaQuery - نجيب عرض الشاشة الكاملة للجهاز
    // نستخدمها هنا عشان نكبر الـ padding الجانبي شوي بالشاشات الكبيرة (تابلت)
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'home_title')),// عنوان الشريط العلوي 
        centerTitle: true,// وضع العنوان بالنصف 
      ),
      // ---------- NavigationDrawer ----------
      // قائمة جانبية تفتح من أيقونة الهامبرغر اللي تضيفها Scaffold تلقائياً بالـ AppBar
      drawer: NavigationDrawer(
        // selectedIndex يخلي العنصر المختار يتلوّن بخلفية مميزة تلقائياً
        selectedIndex: _selectedDrawerIndex,
        onDestinationSelected: (index) {
          // صرنا نفتح صفحة حقيقية فعلياً بدل ما نكتفي برسالة
          setState(() {
            _selectedDrawerIndex = index;
          });
          Navigator.pop(context); // نسكر الدروار الأول قبل ما ننتقل

          const pages = [
            StoresPage(),
            SoundPage(),
            GalleryPage(),
            VideoPage(),
            AboutPage(),
            ContactPage(),
            SettingsPage(),
          ];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pages[index]),
          );
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            child: Text(tr(context, 'drawer_title'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          // ---------- عنصر "نقاطي" بالـ Drawer - نظام نقاط المتاجر ----------
          NavigationDrawerDestination(
            icon: const Icon(Icons.stars_rounded),
            label: Text(tr(context, 'drawer_points')),
          ),
          // ----------عناصر الوسائط الجديدة (صوت، صور، فيديو) ----------
          NavigationDrawerDestination(
            icon: const Icon(Icons.notifications_active_outlined),
            label: Text(tr(context, 'drawer_sound')),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(tr(context, 'drawer_gallery')),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.smart_display_outlined),
            label: Text(tr(context, 'drawer_video')),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.info_outline),
            label: Text(tr(context, 'drawer_about')),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.support_agent),
            label: Text(tr(context, 'drawer_contact')),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings),
            label: Text(tr(context, 'drawer_settings')),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // ---------- شريط البحث (SearchBar) ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SearchBar(
                controller: _searchController, // ربطناها بالـ controller الصريح
                hintText: tr(context, 'search_hint'),
                leading: const Icon(Icons.search),
                // شلنا autoCorrect لأنها مو باراميتر موجود بـ SearchBar أصلاً
                onChanged: (value) {
                  // بدل ما نسوي setState فوري مع كل حرف (كان يمسح حرف الكومبوزيشن العربي)
                  // صرنا نأخر التحديث الفعلي شوي - نلغي أي Timer سابق ونبدأ وحدة جديدة
                  _searchDebounce?.cancel();
                  _searchDebounce = Timer(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _searchQuery = value;
                      });
                    }
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ----------بانر عروض متحرك (PageView) ----------
          SizedBox(
            height: 150,
            child: PageView(
              controller: PageController(viewportFraction: 0.9), // يخلي جزء من البانر الجنبي يبين
              children: [
                _buildBanner(tr(context, 'banner_summer'), Colors.teal),
                _buildBanner(tr(context, 'banner_discount'), Colors.orange),
                _buildBanner(tr(context, 'banner_shipping'), Colors.indigo),
              ],
            ),
          ),

          // ---------- خط فاصل بين البانر والتصنيفات ----------
          const Divider(thickness: 1, indent: 14, endIndent: 14, height: 28),

          // ----------تصنيفات المنتجات (Wrap) ----------
          // Wrap تخلي العناصر تلف لسطر جديد تلقائياً لو ما فيه مساحة كافية بالسطر
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 30 : 14, // padding أكبر بالشاشات الواسعة
            ),
            child: Wrap(
              spacing: 8, // مسافة أفقية بين الشيبات
              runSpacing: 8, // مسافة عمودية بين الأسطر لو لفّت
              children: _categories.map((cat) {
                final bool isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(_categoryLabel(context, cat)),
                  selected: isSelected, // يحدد شكله (ملوّن) لو هو المختار حالياً
                  onSelected: (bool selected) {
                    //  setState - نبلغ فلاتر إن قيمة تغيرت
                    // وبالتالي يعيد رسم build() من جديد ليعكس التصنيف الجديد المختار
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                  selectedColor: Colors.teal,
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.teal,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2; // الافتراضي: جوال عادي
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4; // شاشة كبيرة (تابلت أفقي / ويب)
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 3; // تابلت
                  }

                  // RefreshIndicator - يظهر دائرة تحميل لما نسحب الشاشة لتحت
                  // ويشغل onRefresh، هنا نعيد توليد المنتجات (نحاكي تحديث من سيرفر)
                  return RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1)); // نحاكي وقت انتظار السيرفر
                      setState(() {
                        // نعيد التوليد ونرتب عشوائي عشان نشوف فرق واضح بعد السحب
                        _allProducts = _generateProducts()..shuffle();
                      });
                    },
                    child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, 
                      crossAxisSpacing: 14,// مسافه افقيه فاصله بين العمودين 
                      mainAxisSpacing: 14,// مسافه فاصلهعموديه بين الصفوف
                      childAspectRatio: 0.68,// التحكم بابعاد الكارت 
                    ),
                    itemBuilder: (context, index) {//داله تمر على 30 منتج وتاخذ بيانات كل منتج
                      return ProductCard(product: filteredProducts[index]); // MODIFIED
                    },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// PRODUCT CARD
// One reusable "professional" card: image + name + price
// ======================================================
class ProductCard extends StatelessWidget {// مسوول عن شكل الخارجي لكل منتج
  final Product product;// استقبال بيانات المنتج الممرر له 

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //  GestureDetector - يخلي الكارت كامل قابل للضغط
    // لما نضغط عليه ننتقل لصفحة تفاصيل المنتج (ProductDetailsPage)
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
      //تنسيق الصندوق الخارجي للكارت 
      decoration: BoxDecoration(
        color: Colors.white,// خلفيه بيضاء للكارت 
        borderRadius: BorderRadius.circular(16),// جعل الحواف دائريه بشكل ناعم 
        boxShadow: [// اضافه ظل خفيف اسفل الكارت 
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // makes the image respect the rounded corners تجبر الصور العلويه على قص الزوائد 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,//محاذاه العناصر تبدا من البدايه 
        children: [
          // ---------- Product image ----------
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.1, // أبعاد الصورة لتتناسب مع التصميم الاحترافي الجديد
                // Hero - يعطي الصورة "هوية" مشتركة (tag) بينها وبين
                // نفس الصورة بصفحة التفاصيل. فلاتر يستخدم هالـ tag يسوي
                // أنيميشن انتقال ناعم للصورة بين الصفحتين تلقائياً
                child: Hero(
                  tag: product.name, // اسم المنتج فريد لكل منتج فنقدر نستخدمه كـ tag
                  child: Image.asset(
                    product.imageUrl, // ستقرأ الآن المسار المحلي تلقائياً من جهازكِ
                    fit: BoxFit.cover,// ملء الصوره للمساحه المتاحه بالكامل 
                    errorBuilder: (context, error, stackTrace) {
                      //  إذا حدث خطأ في مسار الصورة أو لم تجدها، ستعرض هذه الأيقونة البديلة بدل من اغلاق التطبيق
                      return Container( 
                        color: Colors.grey[200], 
                        child: const Icon(Icons.image_not_supported, color: Colors.grey), 
                      );
                    },
                  ),
                ),
              ),

              // ---------- بادج التصنيف (Positioned + Transform) ----------
              Positioned(
                // Positioned يحدد مكان العنصر بالضبط جوا الـ Stack
                top: 10,
                right: 10,
                child: Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ---------- Name + price ----------
          Padding(
            padding: const EdgeInsets.all(10),// ابعاد النصوص عن حواف الكارت الداخليه 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(// نص اسم المنتج 
                  product.name,
                  maxLines: 1,// منع الاسم من النزول لسطر ثاني مهما كان طويل 
                  overflow: TextOverflow.ellipsis,// وضع ... اذا كان الاسم طويل جدا 
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                ),
                const SizedBox(height: 6),// مسافه فاصله بين الاسم و السعر
                Text(// نص سعر المنتج 
                  '${product.price.toStringAsFixed(2)} ر.س',// السعر يضهر برقمين بعد الفاصله
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // ---------- بادج التقييم (نجمة + رقم) ----------
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ======================================================
//  PRODUCT DETAILS PAGE
// تفتح لما نضغط على أي منتج بالشبكة، وتعرض صورة كبيرة للمنتج
// باستخدام CustomScrollView + SliverAppBar (Slivers)
// ======================================================
class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  // حالة زر المفضلة (قلب) - تتحكم بشكل وحجم الـ AnimatedContainer
  bool _isFavorite = false;

  //  حالة رسالة "تمت الإضافة للسلة" - تتحكم بظهورها عبر AnimatedOpacity
  bool _showAddedMessage = false;

  //  TabController - يتحكم بمزامنة TabBar مع TabBarView
  late TabController _tabController;

  // ============================= NEW PACKAGE (shared_preferences) =============================
  //  مفتاح فريد لكل منتج نستخدمه بالتخزين المحلي
  // (كل منتج له مفتاحه الخاص عشان "مفضّلة" منتج معين ما تأثر على غيره)
  String get _favoriteKey => 'fav_${widget.product.name}';

  //  مفتاح تخزين تقييم المستخدم لهذا المنتج تحديداً
  String get _ratingKey => 'rating_${widget.product.name}';

  // نتابع فيها التقييم اللي اختارته المستخدمة (0 = لسا ما قيّمت)
  double _userRating = 0;
  // ================================================================================

  @override
  void initState() {
    super.initState();
    // length: 3 عشان عندنا 3 تبويبات (الوصف / المواصفات / التقييمات)
    _tabController = TabController(length: 3, vsync: this);

    //  نقرأ من الجهاز هل هذا المنتج كان محفوظ كمفضلة من قبل أو لا
    _loadFavoriteState();
    //  نقرأ من الجهاز هل المستخدمة قيّمت هذا المنتج من قبل
    _loadUserRating();
  }

  // دالة تقرأ تقييم المستخدمة المحفوظ لهذا المنتج بالتحديد من الجهاز
  Future<void> _loadUserRating() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userRating = prefs.getDouble(_ratingKey) ?? 0;
    });
  }

  //  تستدعى لما تضغط المستخدمة على نجمة - تحفظ التقييم فوراً وتعرض رسالة شكر
  Future<void> _submitRating(int stars) async {
    setState(() => _userRating = stars.toDouble());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_ratingKey, stars.toDouble());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('شكراً على تقييمك: $stars ⭐')),
      );
    }
  }

  //  دالة تقرأ حالة المفضلة المحفوظة لهذا المنتج بالتحديد من الجهاز
  Future<void> _loadFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isFavorite = prefs.getBool(_favoriteKey) ?? false; // false = افتراضياً مو مفضلة
    });
  }

  @override
  void dispose() {
    // نحرر الـ TabController من الذاكرة لما تسكر الصفحة
    _tabController.dispose();
    super.dispose();
  }

  //  تستدعى لما نضغط زر "أضف للسلة"
  void _addToCart() {
    setState(() {
      _showAddedMessage = true; // نظهر الرسالة
    });

    // ============================= NEW PACKAGE (flutter_local_notifications) =============================
    //  بالإضافة لرسالة "تمت الإضافة" الداخلية، نطلع إشعار حقيقي
    // يظهر بشريط إشعارات الجهاز فيه اسم المنتج المضاف بالتحديد
    showLocalNotification(
      title: 'تمت الإضافة للسلة 🛒',
      body: '${widget.product.name} أضيف إلى سلتك بنجاح',
    );
    // ======================================================================================
    // بعد ثانيتين نخفيها تلقائياً
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        // mounted نتأكد إن الصفحة لسا مفتوحة قبل ما نستخدم setState
        setState(() {
          _showAddedMessage = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      //  CustomScrollView - يجمع أكثر من "سليفر" (Sliver) بنفس السكرول الواحد
      body: CustomScrollView(
        slivers: [
          // ---------- SliverAppBar ----------
          SliverAppBar(
            expandedHeight: 320, // الارتفاع وهو موسّع بالكامل بأول الصفحة
            pinned: true, // يثبته فوق بشكل شريط صغير بعد ما ينقلص، بدل ما يختفي كامل
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                // نفس الـ tag اللي بالكارت بالضبط (product.name)
                // عشان فلاتر يعرف إنها نفس الصورة ويسوي لها انتقال ناعم
                tag: product.name,
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),

          // ----------  تفاصيل المنتج تحت الصورة ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // ---------- زر المفضلة (AnimatedContainer) ----------
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          // نحفظ الحالة الجديدة (true/false) على الجهاز فوراً
                          // بحيث لو رجعتِ لهذا المنتج بعدين، يفضل يتذكر اختياري
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setBool(_favoriteKey, _isFavorite);
                          });
                        },
                        // AnimatedContainer يغيّر شكله (اللون والحجم) بشكل
                        // تدريجي وناعم بدل ما يتغير فجأة، كل ما نضغط عليه
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.all(_isFavorite ? 10 : 6),
                          decoration: BoxDecoration(
                            color: _isFavorite
                                ? Colors.red.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.category,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${product.price.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(height: 32),

                  // ---------- تبويبات المنتج (TabBar & TabBarView) ----------
                  // TabBar: الشريط اللي فيه أسماء التبويبات نفسها (نضغط عليها)
                  TabBar(
                    controller: _tabController, // نربطها بنفس الكونترولر حق TabBarView تحت
                    labelColor: Colors.teal, // لون النص للتبويب المختار
                    unselectedLabelColor: Colors.grey, // لون النص للباقي
                    indicatorColor: Colors.teal, // لون الخط تحت التبويب المختار
                    tabs: [
                      Tab(text: tr(context, 'tab_description')),
                      Tab(text: tr(context, 'tab_specs')),
                      Tab(text: tr(context, 'tab_reviews')),
                    ],
                  ),

                  SizedBox(
                    height: 230,
                    child: TabBarView(
                      controller: _tabController, // نفس الكونترولر يربطها بالـ TabBar فوق
                      children: [
                        // ---------- تبويب 1: الوصف ----------
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'منتج عالي الجودة بسعر مناسب، مثالي للاستخدام اليومي. متوفر الآن للشحن السريع.',
                            style: TextStyle(color: Colors.black87, height: 1.5),
                          ),
                        ),
                        // ---------- تبويب 2: المواصفات ----------
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• الضمان: سنة كاملة'),
                              SizedBox(height: 6),
                              Text('• بلد المنشأ: غير محدد'),
                              SizedBox(height: 6),
                              Text('• الوزن: خفيف'),
                            ],
                          ),
                        ),
                        // ---------- تبويب 3: التقييمات ----------
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---------- متوسط تقييم المنتج (غير قابل للضغط) ----------
                              Row(
                                children: [
                                  ...List.generate(5, (i) {
                                    final double diff = product.rating - i;
                                    IconData starIcon;
                                    if (diff >= 1) {
                                      starIcon = Icons.star;
                                    } else if (diff >= 0.5) {
                                      starIcon = Icons.star_half;
                                    } else {
                                      starIcon = Icons.star_border;
                                    }
                                    return Icon(starIcon, color: Colors.amber, size: 20);
                                  }),
                                  const SizedBox(width: 8),
                                  Text('${product.rating.toStringAsFixed(1)} من 5'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 8),

                              // ---------- تقييم المستخدمة التفاعلي ----------
                              Text(
                                tr(context, 'product_rate_this'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(5, (i) {
                                  final int starNumber = i + 1;
                                  return GestureDetector(
                                    onTap: () => _submitRating(starNumber),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(
                                        starNumber <= _userRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 30,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              if (_userRating > 0) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '${tr(context, 'product_your_rating')}: ${_userRating.toStringAsFixed(0)} ⭐',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- أسئلة شائعة (ExpansionTile) ----------
                  // ExpansionTile: عنصر قابل للطي والفتح - يبدأ مطوي ويظهر محتواه
                  Text(
                    tr(context, 'product_faq_title'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ExpansionTile(
                    title: const Text('كم مدة التوصيل؟'),
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    children: const [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('من يوم إلى 3 أيام عمل داخل المدن الرئيسية.'),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('هل يوجد ضمان استبدال؟'),
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    children: const [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('نعم، خلال 14 يوم من تاريخ الاستلام بشرط عدم الاستخدام.'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ---------- زر إضافة للسلة ----------
                  ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(tr(context, 'product_add_to_cart'),
                        style: const TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 12),

                  // ---------- رسالة "تمت الإضافة" (AnimatedOpacity) ----------
                  AnimatedOpacity(
                    opacity: _showAddedMessage ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      tr(context, 'product_added'),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// STORES PAGE (صفحة 1: قائمة المتاجر)
// أول صفحة بنظام "نقاطي" - تعرض شبكة بالمتاجر المشاركة، كل متجر
// اضغط عليه يوديني لصفحة تفاصيل النقاط الخاصة فيه
// ======================================================
class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  // قائمه أسماء المتاجر التجريبية
  static const List<Map<String, dynamic>> _stores = [
    {'name': 'دانكن', 'icon': Icons.local_cafe},
    {'name': 'بندة', 'icon': Icons.storefront},
    {'name': 'الجبر', 'icon': Icons.local_grocery_store},
    {'name': 'الدريس', 'icon': Icons.shopping_bag},
    {'name': 'النهدي', 'icon': Icons.local_pharmacy},
    {'name': 'بترومين', 'icon': Icons.local_gas_station},
    {'name': 'البيك', 'icon': Icons.fastfood},
    {'name': 'نقاط من المتجر', 'icon': Icons.point_of_sale},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نقاط المتاجر'),
        centerTitle: true,
        // ----------زر السهم بأعلى يمين الشاشة - ينقل للصفحة الثانية مباشرة ----------
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StoreDetailsPage()),
              );
            },
          ),
        ],
      ),
      // ---------- شبكة المتاجر (GridView) -----------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _stores.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عمودين بالضبط زي الصورة
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final store = _stores[index];
            return GestureDetector(
              //  الضغط على أي متجر يوديني لصفحة تفاصيل نقاطه
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StoreDetailsPage(storeName: store['name'] as String),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      child: Icon(store['icon'] as IconData,
                          size: 32, color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                    // أيقونة QR صغيرة توحي إن كل متجر له رمز خاص فيه
                    const Icon(Icons.qr_code_2, size: 16, color: Colors.grey),
                    const SizedBox(height: 6),
                    Text(
                      store['name'] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ======================================================
// STORE DETAILS PAGE (صفحة 2: تفاصيل نقاط المتجر)
// تعرض رمز QR الخاص بالمتجر، شرح نظام النقاط، ومستويات العضويات
// ======================================================
class StoreDetailsPage extends StatelessWidget {
  final String? storeName;
  const StoreDetailsPage({super.key, this.storeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName ?? 'نقاط المتاجر'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SendRequestPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SendRequestPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.qr_code_2, size: 60, color: Colors.teal),
                    SizedBox(height: 10),
                    Text('رمز QR',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text('فاتورة إلكترونية',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- بطاقة شرح نظام النقاط (الكرت الملوّن بالصورة المرجعية) ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'نقطة مقابل 5 ريال سعودي',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'العميل سيحصل على نقاط مقابل كل 5 ريال سعودي',
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                  const Divider(height: 24),
                  // ADDED: قائمة نقطية بشروط العرض (bullet points)
                  const _BulletText('العرض ساري لفترة محدودة.'),
                  const _BulletText(
                      'يحصل العميل على النقاط بعد إتمام شروط العرض.'),
                  const _BulletText(
                      'يتم إضافة النقاط إلى محفظة المستخدم داخل التطبيق.'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- قسم العضويات المستفيدة (المستويات الذهبية/الفضية/البرونزية) ----------
            const Text(
              'العضويات المستفيدة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _MembershipBadge(label: 'الذهبية', color: Colors.amber),
                _MembershipBadge(label: 'الفضية', color: Colors.grey),
                _MembershipBadge(label: 'البرونزية', color: Colors.brown),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}

//  ويدجت صغيرة مساعدة لعرض ميدالية عضوية واحدة (أيقونة دائرية + اسم)
class _MembershipBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _MembershipBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.emoji_events, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ======================================================
//  SEND REQUEST PAGE (صفحة 3: إرسال الطلب / مسح الفاتورة)
// آخر صفحة بالتسلسل - تسمح للمستخدم يمسح رمز QR من صورة فاتورة
// ======================================================
class SendRequestPage extends StatefulWidget {
  const SendRequestPage({super.key});

  @override
  State<SendRequestPage> createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> {
  // ============================= NEW PACKAGES (mobile_scanner + image_picker) =============================
  //  نتابع فيه آخر نتيجة مسح ناجحة (نص الرمز نفسه) عشان نعرضها بالشاشة
  String? _scannedValue;

  final ImagePicker _imagePicker = ImagePicker();

  // ----------  دالة المسح عن طريق الكاميرا (Live Scan) ----------
  Future<void> _scanWithCamera() async {
    final String? result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (result != null && mounted) {
      setState(() => _scannedValue = result);
      _showSuccessMessage(); // ADDED: نطلع رسالة النجاح
    }
  }

  // ----------  دالة المسح عن طريق اختيار صورة   ----------
  Future<void> _scanFromGallery() async {
    // pickImage يفتح معرض الصور فعلياً وينتظر اختيارك
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    // لو المستخدم رجع بدون ما يختار صورة (ضغط رجوع)، نوقف هنا
    if (pickedImage == null) return;

    final MobileScannerController tempController = MobileScannerController();

    try {
      final BarcodeCapture? capture =
          await tempController.analyzeImage(pickedImage.path);

      // لو لقى رمز واحد على الأقل بالصورة
      if (capture != null && capture.barcodes.isNotEmpty && mounted) {
        final String? value = capture.barcodes.first.rawValue;
        setState(() => _scannedValue = value ?? 'تم المسح');
        _showSuccessMessage(); // ADDED: نطلع رسالة النجاح
      } else if (mounted) {
        //  الصورة ما فيها رمز QR واضح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' رمز غير موجودQR بهذي الصورة')),
        );
      }
    } finally {
      tempController.dispose();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('تم المسح بنجاح'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
  // ================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال الطلب'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- عنوان ونص توضيحي ----------
            const Text(
              'قم بمسح رمز QR على الفاتورة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'صوّر الفاتورة بالكاميرا مباشرة، أو اختار صورة محفوظة من الالبوم',
              style: TextStyle(color: Colors.grey, fontSize: 12.5),
            ),
            const SizedBox(height: 20),

            // ---------- مربع معاينة نتيجة آخر مسح ----------
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _scannedValue != null
                      ? Colors.green.withOpacity(0.06) // يتلوّن أخضر لو فيه نتيجة ناجحة
                      : Colors.grey.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _scannedValue != null
                        ? Colors.green.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _scannedValue == null
                        //  ما فيه نتيجة بعد - نعرض الحالة الافتراضية
                        ? const [
                            Icon(Icons.receipt_long, size: 70, color: Colors.grey),
                            SizedBox(height: 12),
                            Icon(Icons.qr_code_scanner, size: 40, color: Colors.teal),
                            SizedBox(height: 8),
                            Text('ما فيه مسح لسا',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ]
                        //  فيه نتيجة ناجحة - نعرضها بعلامة صح كبيرة
                        : [
                            const Icon(Icons.check_circle,
                                size: 70, color: Colors.green),
                            const SizedBox(height: 12),
                            const Text('تم المسح بنجاح',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                _scannedValue!,
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- زر المسح بالكاميرا (فتح كاميرا حية) ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _scanWithCamera,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('مسح بالكاميرا'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ----------  زر المسح من صورة الالبوم  ----------
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _scanFromGallery, 
                icon: const Icon(Icons.image_outlined, color: Colors.teal),
                label: const Text('مسح من صورة',
                    style: TextStyle(color: Colors.teal)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// QR SCANNER PAGE (صفحة الكاميرا الحية لمسح رمز QR)
// صفحة منفصلة كاملة الشاشة - تفتح الكاميرا وتمسح تلقائياً أي رمز QR
// تشوفه، وترجع النتيجة لصفحة SendRequestPage اللي فتحتها
// ======================================================
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  //  كونترولر الكاميرا الحية - يدير فتح/إغلاق الكاميرا وحالتها
  final MobileScannerController _cameraController = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('وجّهي الكاميرا على رمز QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _cameraController.toggleTorch(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      // ---------- MobileScanner - عرض الكاميرا الحية بكامل الشاشة ----------
      body: MobileScanner(
        controller: _cameraController,
        // onDetect تستدعى تلقائياً كل ما الكاميرا تكتشف رمز QR بالصورة
        onDetect: (BarcodeCapture capture) {
          if (_hasScanned) return; 

          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            _hasScanned = true; 
            final String value = barcodes.first.rawValue ?? 'تم المسح';
            Navigator.pop(context, value);
          }
        },
      ),
    );
  }
}

// ======================================================
// SOUND PAGE (صفحة الصوت - نغمة تنبيه المتجر)
// ======================================================
class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  // ============================= NEW PACKAGE (audioplayers) =============================
  // كائن AudioPlayer واحد نتحكم فيه بكل صفحة الصوت (تشغيل/إيقاف)
  final AudioPlayer _audioPlayer = AudioPlayer();

  // نتابع فيها هل الصوت شغال حالياً أو لا، عشان نبدّل شكل الزر
  bool _isPlaying = false;

  //  دالة تشغيل/إيقاف الصوت - تستدعى لما نضغط الزر
  Future<void> _toggleSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    } else {
      // UrlSource: نشغّل ملف صوتي من الإنترنت مباشرة (بدون تحميله بالجهاز) قران مثلا
      await _audioPlayer.play(
        UrlSource(
            'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3'),
      );
      setState(() => _isPlaying = true);

      //  لما ينتهي الصوت من نفسه، نرجع شكل الزر لوضعه الطبيعي تلقائياً
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isPlaying = false);
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  // ================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نغمة الإشعار'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isPlaying ? Icons.volume_up : Icons.notifications_active,
              size: 90,
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            const Text(
              'استمع لتلاوة قرآنية قصيرة',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // ----------  زر تشغيل/إيقاف الصوت ----------
            ElevatedButton.icon(
              onPressed: _toggleSound,
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(_isPlaying ? 'إيقاف' : 'تشغيل التلاوة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
//  GALLERY PAGE (صفحة الصور - منتج محلي + عرض من مورد بالإنترنت)
// ======================================================
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معرض المنتجات'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('من منتجاتنا المحلية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/prod1.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------- صورة من الإنترنت - تمثل عرض جديد من مورّد ----------
          const Text('أحدث عروض الموردين',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              'https://picsum.photos/id/26/800/500', //  صورة تجريبية من الإنترنت
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // مؤشر تحميل يظهر لين تجيب الصورة من الإنترنت
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator(color: Colors.teal)),
                );
              },
              // لو ما فيه إنترنت أو فشل التحميل، يعرض بديل بدل ما يطلع خطأ
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.wifi_off, color: Colors.grey, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // ============================= NEW PACKAGE (video_player) =============================
  //  كائن يتحكم بتشغيل الفيديو (تشغيل/إيقاف/تقدّم الوقت...)
  late VideoPlayerController _controller;

  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }
  void _initializeVideo() {
    setState(() {
      _isInitialized = false;
      _hasError = false;
    });
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );

    _controller.initialize().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception('انتهت مهلة تحميل الفيديو');
      },
    ).then((_) {
      if (mounted) {
        setState(() => _isInitialized = true);
        _controller.play();
      }
    }).catchError((error) {
      if (mounted) setState(() => _hasError = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // ================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فيديو تعريفي'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'شاهدي فيديو تعريفي قصير عن متجرنا وأحدث عروضنا',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // ---------- مربع عرض الفيديو - 3 حالات ممكنة ----------
            if (_hasError)
              // حالة الخطأ - رسالة واضحة + زر إعادة محاولة
              Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'تعذّر تحميل الفيديو، تأكدي من اتصالك بالإنترنت',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _initializeVideo, 
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else if (_isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            else
              // حالة التحميل - مؤشر دائري بدل شاشة فاضية
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: Colors.teal)),
              ),

            const SizedBox(height: 16),

            // ---------- زر تشغيل/إيقاف الفيديو - يظهر بس لو تم التحميل بنجاح ----------
            if (_isInitialized && !_hasError)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(_controller.value.isPlaying ? 'إيقاف' : 'تشغيل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
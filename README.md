# Meme App using API and Provider

### Splash Screen
<kbd><img src="https://user-images.githubusercontent.com/109909231/224924545-2479b895-9be3-4436-8401-10c25291e19a.png" width="250" height="550"></kbd>

### Home Screen&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Adding Items&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Cart Screen
<kbd><img src="https://user-images.githubusercontent.com/109909231/224924675-ddb5a35f-4b5a-4390-a4e2-316d9d92852e.png" width="250" height="550"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="https://user-images.githubusercontent.com/109909231/224924803-b9d3270b-e425-4efb-96dc-ec830d5db4f1.png" width="250" height="550"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="https://user-images.githubusercontent.com/109909231/224924817-24c40565-7207-4acf-940d-9eb90619ed0b.png" width="250" height="550"></kbd>


### Downloading Image&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Empty Cart
<kbd><img src="https://user-images.githubusercontent.com/109909231/224925346-cb5bd3cd-c688-4053-a0c8-a56f549ee9ad.png" width="250" height="550"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="https://user-images.githubusercontent.com/109909231/224946487-ecf8b170-bec6-4b91-94ad-96ddbb500327.png" width="250" height="550"></kbd>

### Recording: 

https://user-images.githubusercontent.com/109909231/224942240-a3389d7f-3005-4151-a6e3-20d6f59483f0.mp4

## Packages used:
 - [http](https://pub.dev/packages/http)
 - [provider](https://pub.dev/packages/provider)
 - [dynamic_height_grid_view](https://pub.dev/packages/dynamic_height_grid_view)
 - [path](https://pub.dev/packages/path)
 - [path_provider](https://pub.dev/packages/path_provider)
___
## Detailed description of implementation 

### [i]. Fetching data from API and rendering UI
### [ii]. Provider for state management
### [iii]. Saving Image to Local Storage  
___
  
### [i]. Fetching data from API and rendering UI

#### Memes API : [MemesAPI](https://api.imgflip.com/get_memes) 
#### _Not sure How to parse JSON data from API?_ Detailed Explanation [here](https://github.com/AKR-2803/FlutterAPI-FlutterProvider#readme)

Code here : [home_page.dart](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/home_page.dart)

Parsing the data from memesAPI
```dart
Future<MemesModel> getMemesApi() async {
  final response =
      await http.get(Uri.parse("https://api.imgflip.com/get_memes"));
  var data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return MemesModel.fromJson(data);
  } else {
    return MemesModel.fromJson(data);
  }
}
```
- memes is of type Future<MemesModel> which will contain the fetched data.
- Note : late keyword is important.
- call the method in initState()
```dart
class _HomePageState extends State<HomePage> {
  late Future<MemesModel> memes;

  @override
  void initState() {
    super.initState();
    memes = getMemesApi();
  }
```

- use FutureBuilder to render the data on screen

```dart
body: FutureBuilder<MemesModel>(
        future: memes,
        builder: (context, snapshot) {
```

- I used DynamicHeightGridView (package [here](https://pub.dev/packages/dynamic_height_grid_view)), you may use any preferred widget/package that suits you.
- make sure you give itemCount property
- snapshot will either have data or error (```snapshot.hasData``` , ```snapshot.harError```)
- if ```snapshot.hasData``` render the UI, else if ```snapshot.hasError``` display the error, else render a CircularProgressIndicator, i.e while waiting for data to be fetched.

```dart
DynamicHeightGridView(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 25,
                  itemCount:
                      //nullcheck operator
                      snapshot.hasData ? snapshot.data!.data!.memes!.length : 1,
                  builder: (context, index) {
                  
                 //data fetched successfully
                    if (snapshot.hasData) {
                      //render UI here
                    }
```
```dart
//data couldn't be fetched due to some error
else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error Occured : ${snapshot.error}"),
                      );
```
```dart
//waiting for data to be fetched (just the way youtube videos show circular progressor while buffering)
else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.teal,
                      ));
                    }
```
___

### [ii]. Provider for state management

- We've rendered the UI. Great!
- But, think about the cart feature, whenever the "Get This Meme" button is tapped :
- how will the we increment the counter value on the top right corner on the cart icon?
- how will we render the UI accordingly in the cart page?
#### That's where PROVIDER comes in!

Provider is a state management tool, you can refer more about it here : [ProviderExample](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)

Note : It may take sometime to understand provider, my case was no different. (Remember : Nothing comes overnight, good things take time!)

- Once/If you are familiar with provider, lets move ahead.

We have 2 basic requirements using provider.

Case-1 : Increment/Decreament the counter value on the cart icon on home page(refer images above).

Case-2 : Building the Cart page.
___

Case-1 : Increment/Decreament Counter
Code here : [cart_counter_provider.dart](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/providers/cart_counter_provider.dart)
- define the Provider class
- make sure to extend ChangeNotifier
- declare an integer cartCount
- define the constructor(initalize cartCount value) and getter method
- define the methods increment() and decreament()
- notifyListeners()

```dart
import 'package:flutter/cupertino.dart';

class CartCounterProvider extends ChangeNotifier {
  int cartCount;
  CartCounterProvider({this.cartCount = 0});

  int get getCartCount => cartCount;

  void increment() {
    cartCount += 1;
    notifyListeners();
  }

  void decrement() {
    cartCount -= 1;
    notifyListeners();
  }
}
```
Next, when will we need the provider?, when the button is pressed!, hence write the code inside the onPressed() function of button "Get this Meme"

Code [here](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/home_page.dart#L162)
```dart
context.read<CartCounterProvider>().increment();
```

Code [here](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/home_page.dart#L46)
```dart
//just inside the build method this cartCounter will watch the value of the counter 
//button pressed -> increment() method called using provider -> cartCounter watches the value and updates accordingly
int cartCounter = context.watch<CartCounterProvider>().getCartCount;
```
Using read and watch is one way to do it. Another one is using the instance of the Provider class you made, lets discuss this approach for Case-2.
___

Case-2 : Building the Cart page.

_Note :_ Always try to define the functionalities prior before implementing.

The plan for cart page is simple:
- Displaying a list of memes selected by the user.
- Also include delete functionality.


Provider class for displaying Cart(MemeCartProvider)

Code [meme_cart_provider.dart](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/providers/meme_cart_provider.dart)

```dart
//read below about CartCardModel first

import 'package:memeapp/models/cart_card_model.dart';
import 'package:flutter/cupertino.dart';

class MemeCartProvider extends ChangeNotifier {
  
  //now it's convenient for us to display the memes, we just need a list of CartCardModel!
  //each instance of this class will have the respective id, imageURL, and name of the meme.
  //We just need to traverse and display this list in the cart page, thats it!
  
  
  //_cartList will have the id, imageURL, name of only those memes that are added to cart by user
  final List<CartCardModel> _cartList = <CartCardModel>[];
  
  //memesIdList will only contain the meme ID's which will be used to add/remove memes from the cart
  //also used to prevent duplicates 
  List<String>? memesIdList = <String>[];

  List<CartCardModel> get getCartList => _cartList;
  List<String>? get getMemesIdList => memesIdList;

  void addItem(CartCardModel addThisItem) {
    _cartList.add(addThisItem);
    notifyListeners();
  }

  void removeItem(String memeId) {
    _cartList.removeWhere((element) => element.id == memeId);
    memesIdList!.remove(memeId);
    notifyListeners();
  }
}
```

- Wondering what's CartCardModel? (apologies for the confusing name :| )
- See, we need to show the image and name of the respective memes right.
- So, to not make things complicated, I defined a class named "CartCardModel", which will have id, imageURL, and name of the meme.
- Why id?, to avoid duplicates!...id will ensure that once added, the same meme won't be added again.
- ID can be anything that is unique to each item.
- Thankfully, [MemeAPI](https://api.imgflip.com/get_memes) has IDs for each item already included.

CartCardModel [cart_card_model.dart](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/models/cart_card_model.dart)

```dart
//each instance of this class (CartCardModel) will have the info of id, imageURL, and name.
//it will now be easier to display the memes in the cart page
class CartCardModel {
  String id;
  String? nameCart;
  String? imageUrlCart;
  CartCardModel({
    required this.id,
    this.nameCart,
    this.imageUrlCart,
  });
}
```

Now its convenient for us to render memes in the Cart Page.
We simply traverse the List<CartCardModel> and display items accordingly.

But, how will we make sure only those items are rendered which were added by the user?
Provider it is, again!.


Code [cart_page.dart](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/cart_page.dart#L18)

```dart
  //define an instance of MemeCartProvider class like this inside the build method
   Widget build(BuildContext context) {
    var memeCartProvider = Provider.of<MemeCartProvider>(context);
```

Code [here](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/cart_page.dart#L28)
```dart
//wrap the Listview.builder with CONSUMER<MemeCartProvider>
Consumer<MemeCartProvider>(
              builder: (context, value, child) {
                //ListView will traverse CartCardModel list and render memes accordingly
                return ListView.builder(
                  //itemCount is simply the length of the list. 
                  itemCount: value.getMemesIdList!.length,
                  itemBuilder: ((context, index) {
                    object/instance of CartCardModel class using MemeCartProvider
                    CartCardModel cartObject = value.getCartList[index];
```

Code [here](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/cart_page.dart#L51)
```dart
 //render the image using cartObject
 Image.network(
                "${cartObject.imageUrlCart}",
                     width: 140,
              ),
              
 //render the name using cartObject
 Text(           
                  //limiting name to 20 characters 
                  cartObject.nameCart!.length > 20
                   ? "${cartObject.nameCart!.substring(0, 20)}..."
                   : "${cartObject.nameCart}",
```

Last but not the least, we need to implement the delete feature

```dart
 onPressed: () {
                   //we will remove the item from the list
                   value.removeItem(cartObject.id);                   
                   
                   //why this line? you might've guessed it already, if not, dont worry
                   //remember we incrementes the counter value when user added items to the cart
                   //now user is deleting items, hence we need to decreament that counter value too!, right?
                   context.read<CartCounterProvider>().decrement();
               },

```
___

### [iii]. Saving Image to Local Storage  

- The [code](https://github.com/AKR-2803/MemeAppFlutter/blob/akr-branch/lib/screens/preview_download.dart) is easy to understand. 


And...Thats a Wrap!
I hope this helped you and you learnt something new. If you desire, consider giving this repo a ⭐. In case you have any queries, you can surely reach me out through my socials.

ALL THE BEST🙌


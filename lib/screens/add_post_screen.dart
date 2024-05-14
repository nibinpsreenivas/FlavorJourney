// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FlavorJourney/providers/user_provider.dart';
import 'package:FlavorJourney/resources/firestore_methods.dart';
import 'package:FlavorJourney/resources/foodrep.dart';
import 'package:FlavorJourney/screens/feed_screen.dart';
import 'package:FlavorJourney/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  final File? imageFile;

  const AddPostScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _recipeController = TextEditingController();
  bool isLoading = false;
  late String cuisine;
  String food = "";
  void initState() {
    super.initState();
    setState(() {
      _descriptionController.text = rep.food;

      _file = widget.imageFile?.readAsBytesSync();
    });
  }

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _recipeController.text,
        _file!,
        uid,
        username,
        profImage,
        cuisine,
      );
      Navigator.pop(context);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Using Provider: It will make just one call to Database that's why useful.
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 230),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 250, 230),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(userProvider.getUser.uid,
                userProvider.getUser.username, userProvider.getUser.phototUrl),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 255, 250, 230),
          child: Column(
            children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              Column(
                children: [
                  SizedBox(
                    height: 350,
                    width: 350,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            print(rep.food);
                            _descriptionController.clear();
                            _descriptionController.text = rep.food;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // ignore: prefer_const_constructors
                            image: DecorationImage(
                              // ignore: prefer_const_constructors
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(100, 255, 159, 102),
                      borderRadius: BorderRadius.circular(20), // Circular edges
                    ),
                    child: SizedBox(
                      width: 320,

                      // ignore: prefer_const_constructors
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(100, 255, 159, 102),
                      borderRadius: BorderRadius.circular(20), // Circular edges
                    ),
                    child: SizedBox(
                      width: 320,
                      // ignore: prefer_const_constructors
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _recipeController,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(100, 255, 159, 102),
                          hintText: 'Enter the recipe',
                          border: InputBorder.none,
                        ),
                        maxLines: 6,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Circular edges
                      color: Color.fromARGB(125, 255, 137, 17),
                    ),
                    child: SizedBox(
                        width: 320,
                        // ignore: prefer_const_constructors
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (rep.food == "Apple Pie") {
                                _recipeController.text =
                                    "To make apple pie, start by preparing the pie crust. Combine flour, salt, and cold butter in a bowl, then gradually add ice water until the dough comes together. Divide the dough in half, shape into discs, wrap in plastic wrap, and chill for at least an hour. For the filling, peel and slice tart apples and toss with sugar, cinnamon, nutmeg, and a squeeze of lemon juice. Roll out one disc of dough and place it in a pie dish. Add the apple filling, then roll out the second disc of dough and place it over the filling. Crimp the edges to seal and make slits in the top crust to vent. Bake the pie in a preheated oven until golden brown and bubbly. Let it cool slightly before serving with a scoop of vanilla ice cream for a delicious homemade treat.";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Chicken Curry") {
                                _recipeController.text =
                                    "Begin by marinating diced chicken pieces in a mixture of yogurt, ginger-garlic paste, turmeric, chili powder, and salt. Let it marinate for at least 30 minutes. Meanwhile, heat oil in a large pan and sauté onions until they turn golden brown. Add chopped tomatoes, green chilies, and spices like cumin, coriander, and garam masala. Cook until the tomatoes break down and the mixture forms a thick paste. Then, add the marinated chicken along with some water and let it simmer until the chicken is cooked through and tender. Adjust the seasoning according to taste and garnish with fresh cilantro before serving. Chicken curry pairs well with rice, naan, or roti for a satisfying meal that's bursting with flavor.";
                                cuisine = "Indian";
                                Fluttertoast.showToast(
                                  msg: "Indian",
                                );
                              } else if (rep.food == "Fried Rice") {
                                _recipeController.text =
                                    "start by cooking long-grain rice until it's slightly undercooked, as fully cooked rice can become mushy when stir-fried. Once cooked, spread the rice out on a tray to cool and dry slightly. In a large skillet or wok, heat oil over medium-high heat and add finely chopped garlic and diced onions. Sauté until fragrant and translucent. Then, add your choice of diced vegetables such as carrots, peas, bell peppers, and broccoli. Stir-fry the vegetables until they are slightly tender. Push the vegetables to one side of the pan and crack eggs into the empty space. Scramble the eggs until cooked through, then mix them with the vegetables. Next, add the cooked rice to the skillet and toss everything together. Season with soy sauce, oyster sauce, salt, and pepper to taste. Continue to stir-fry until the rice is heated through and evenly coated with the sauce. Finally, garnish with chopped green onions and serve hot.";
                                cuisine = "Chinese";
                                Fluttertoast.showToast(
                                  msg: "Chinese",
                                );
                              } else if (rep.food == "Soup") {
                                _recipeController.text =
                                    "start by bringing chicken or vegetable broth to a simmer in a pot. Then, add ingredients such as thinly sliced mushrooms, tofu cubes, bamboo shoots, and shredded chicken or pork, depending on your preference. Season the soup with soy sauce, rice vinegar, and a touch of sugar for sweetness. To create the \"hot\" aspect of the soup, add freshly ground white pepper or chili paste for heat. For the \"sour\" component, add rice vinegar or black vinegar to achieve a tangy flavor. Finally, thicken the soup with a cornstarch slurry, stirring until it reaches your desired consistency. Garnish the soup with chopped green onions and a drizzle of sesame oil for extra flavor.";
                                cuisine = "Chinese";
                                Fluttertoast.showToast(
                                  msg: "Chinese",
                                );
                              } else if (rep.food == "Onion Rings") {
                                _recipeController.text =
                                    "To prepare onion rings, thick slices of onions, typically sweet or yellow onions, are separated into individual rings. These rings are then dipped in a batter made from flour, cornstarch, baking powder, and seasonings such as salt, pepper, and paprika. The battered onion rings are then deep-fried in hot oil until they are crispy and golden on the outside while remaining tender on the inside. Once cooked, onion rings are often served hot and can be enjoyed on their own as a snack or appetizer, or as a delicious accompaniment to burgers, sandwiches, or other main dishes.";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Omlette") {
                                _recipeController.text =
                                    "To prepare an omelette, eggs are beaten and seasoned with salt and pepper before being poured into a heated skillet. As the eggs begin to cook, they are gently pushed and folded in the pan, creating layers of fluffy goodness. The filling options for omelettes are endless, ranging from vegetables like bell peppers, onions, and mushrooms to meats like ham, bacon, or sausage, as well as cheeses and herbs. Once the eggs are fully cooked and the filling is heated through, the omelette is folded over itself and slid onto a plate, ready to be enjoyed hot and fresh.";
                                cuisine = "Common";
                                Fluttertoast.showToast(
                                  msg: "Common",
                                );
                              } else if (rep.food == "Hamburger") {
                                _recipeController.text =
                                    "To prepare a classic hamburger, start by forming ground beef into patties seasoned with salt and pepper. Heat a grill or skillet over medium-high heat and cook the patties for about 4-5 minutes per side, or until they reach your desired level of doneness. While the patties are cooking, slice hamburger buns in half and lightly toast them on the grill or in a separate skillet. Once the patties are cooked, place them on the bottom half of the toasted buns. Top the patties with slices of cheese, such as cheddar or American cheese, allowing the residual heat to melt the cheese slightly. Next, add your desired toppings, such as lettuce, sliced tomatoes, onions, pickles, and condiments like ketchup, mustard, and mayonnaise. Finally, place the top half of the bun over the toppings, and your hamburger is ready to serve.";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Club Sandwich") {
                                _recipeController.text =
                                    "To prepare a classic club sandwich, start by toasting three slices of bread until they are lightly golden and crisp. Then, spread mayonnaise on one side of each slice. On the first slice, layer sliced roasted turkey or chicken, followed by crispy bacon slices and fresh lettuce leaves. Place the second slice of bread on top and layer with sliced tomatoes and avocado. Top with a third slice of bread. To assemble the sandwich, carefully insert toothpicks into each corner to hold the layers together. Using a sharp knife, cut the sandwich diagonally into two triangles. Serve the club sandwich with a side of potato chips, coleslaw, or a dill pickle spear for a classic and satisfying meal.";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Icecream") {
                                _recipeController.text =
                                    "Start by preparing the ice cream base. Combine heavy cream, whole milk, sugar, and any desired flavorings such as vanilla extract or cocoa powder in a saucepan over medium heat. Stir the mixture until the sugar dissolves and the mixture is heated through but not boiling. In a separate bowl, whisk egg yolks until smooth. Gradually pour a small amount of the hot cream mixture into the egg yolks, whisking constantly to temper the eggs. Then, pour the egg mixture back into the saucepan with the remaining cream mixture, stirring constantly. Cook the mixture over medium heat until it thickens and coats the back of a spoon, forming a custard-like consistency. Remove from heat and let the mixture cool completely. Once cooled, transfer the mixture to an ice cream maker and churn according to the manufacturer's instructions until it reaches a soft-serve consistency. Transfer the churned ice cream to a freezer-safe container and freeze for several hours or overnight until firm. Serve the homemade ice cream scooped into bowls or cones and enjoy your delicious frozen treat!";
                                cuisine = "Common";
                                Fluttertoast.showToast(
                                  msg: "Common",
                                );
                              } else if (rep.food == "Donuts") {
                                _recipeController.text =
                                    "To make homemade donuts, mix flour, sugar, yeast, salt, warm milk, melted butter, and beaten eggs to form a dough. Let it rise, then roll it out and cut into donut shapes. Fry in hot oil until golden brown. Optionally, coat in cinnamon sugar or glaze with powdered sugar and milk. Enjoy warm and fresh!";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Cake") {
                                _recipeController.text =
                                    "Start by creaming together softened butter and sugar until light and fluffy. Beat in eggs one at a time, then mix in vanilla extract. In a separate bowl, sift together flour, baking powder, and salt. Gradually add the dry ingredients to the wet ingredients, alternating with milk, and mix until just combined. Pour the batter into a greased and floured cake pan and bake in a preheated oven until a toothpick inserted into the center comes out clean. Let the cake cool completely before frosting or decorating as desired. ";
                                cuisine = "Common";
                                Fluttertoast.showToast(
                                  msg: "Common",
                                );
                              } else if (rep.food == "French Toast") {
                                _recipeController.text =
                                    "Start by whisking together eggs, milk, vanilla extract, and cinnamon in a shallow dish. Dip slices of bread into the egg mixture, ensuring they are fully coated. Heat a skillet or griddle over medium heat and melt butter. Cook the soaked bread slices until golden brown and crispy on both sides. Serve hot with maple syrup, powdered sugar, or fresh fruit as desired.";
                                cuisine = "French";
                                Fluttertoast.showToast(
                                  msg: "French",
                                );
                              } else if (rep.food == "Garlic Bread") {
                                _recipeController.text =
                                    "Start by mixing softened butter with minced garlic, chopped parsley, salt, and pepper in a bowl. Slice a loaf of French or Italian bread in half horizontally. Spread the garlic butter mixture evenly over the cut sides of the bread. Place the bread halves, cut side up, on a baking sheet and bake in a preheated oven until the bread is toasted and the garlic butter is melted and fragrant. Serve the garlic bread hot, sliced into pieces.";
                                cuisine = "Italian";
                                Fluttertoast.showToast(
                                  msg: "Italian",
                                );
                              } else if (rep.food == "Oysters") {
                                _recipeController.text =
                                    "Start by shucking fresh oysters and removing them from their shells. Rinse the oysters under cold water to remove any grit or debris. Next, decide on the cooking method: oysters can be enjoyed raw, steamed, grilled, fried, or baked. For raw oysters, serve them immediately on a bed of ice with lemon wedges and cocktail sauce. To steam oysters, place them in a steamer basket over boiling water and steam for a few minutes until the shells open. Grilled oysters are topped with garlic butter or a tangy sauce and cooked on a hot grill until they are firm and opaque. Fried oysters are breaded in seasoned flour or breadcrumbs and deep-fried until golden brown and crispy. Baked oysters are often topped with breadcrumbs, cheese, garlic, and herbs, then baked until bubbly and golden.";
                                cuisine = "Coastal";
                                Fluttertoast.showToast(
                                  msg: "Coastal",
                                );
                              } else if (rep.food == "Waffles") {
                                _recipeController.text =
                                    "Start by whisking together flour, sugar, baking powder, and salt in a mixing bowl. In a separate bowl, whisk together eggs, milk, melted butter, and vanilla extract. Gradually add the wet ingredients to the dry ingredients, mixing until just combined. Preheat a waffle iron and lightly grease it with cooking spray or butter. Pour the waffle batter onto the hot waffle iron and cook according to the manufacturer's instructions until golden brown and crispy. Serve the waffles hot with toppings such as maple syrup, fresh fruit, whipped cream, or chocolate sauce.";
                                cuisine = "Belgian";
                                Fluttertoast.showToast(
                                  msg: "Belgian",
                                );
                              } else if (rep.food == "French Fries") {
                                _recipeController.text =
                                    "To make French fries, start by peeling potatoes and cutting them into thin strips. Rinse the potato strips under cold water to remove excess starch, then pat them dry with a clean towel. Heat vegetable oil in a deep fryer or large pot to 325°F (160°C). Carefully add the potato strips to the hot oil in batches, frying until they are soft but not yet golden brown, about 3-4 minutes. Remove the partially cooked fries from the oil and let them drain on paper towels. Increase the oil temperature to 375°F (190°C). Return the partially cooked fries to the hot oil in batches and fry until they are crispy and golden brown, about 2-3 minutes. Remove the fries from the oil and let them drain on paper towels. Season the fries with salt while they are still hot.";
                                cuisine = "French";
                                Fluttertoast.showToast(
                                  msg: "French",
                                );
                              } else if (rep.food == "Pancakes") {
                                _recipeController.text =
                                    "Start by whisking together flour, sugar, baking powder, and salt in a mixing bowl. In a separate bowl, whisk together eggs, milk, melted butter, and vanilla extract. Gradually add the wet ingredients to the dry ingredients, mixing until just combined. Heat a lightly greased skillet or griddle over medium heat. Pour the pancake batter onto the hot skillet, using about 1/4 cup of batter for each pancake. Cook until bubbles form on the surface of the pancakes and the edges begin to set, then flip and cook until golden brown on the other side. Serve the pancakes hot with toppings such as butter, maple syrup, fresh fruit, or whipped cream.";
                                cuisine = "American";
                                Fluttertoast.showToast(
                                  msg: "American",
                                );
                              } else if (rep.food == "Pizza") {
                                _recipeController.text =
                                    "Start by making the dough. Mix flour, yeast, salt, and water in a bowl and knead until smooth. Let the dough rise until doubled in size. Roll out the dough into a circle and place it on a pizza stone or baking sheet. Spread tomato sauce over the dough, then add toppings such as cheese, vegetables, meats, and herbs. Bake the pizza in a preheated oven until the crust is golden brown and the cheese is melted and bubbly. Serve hot and enjoy! ";
                                cuisine = "Italian";
                                Fluttertoast.showToast(
                                  msg: "Italian",
                                );
                              } else if (rep.food == "Cupcakes") {
                                _recipeController.text =
                                    "start by mixing together flour, sugar, baking powder, and salt in a mixing bowl. In a separate bowl, beat together softened butter, eggs, milk, and vanilla extract until well combined. Gradually add the wet ingredients to the dry ingredients, mixing until smooth. Spoon the batter into cupcake liners, filling each about two-thirds full. Bake in a preheated oven until a toothpick inserted into the center comes out clean, usually about 15-20 minutes. Let the cupcakes cool completely before frosting. For frosting, beat together softened butter, powdered sugar, and vanilla extract until light and fluffy. Pipe or spread the frosting onto the cooled cupcakes and decorate as desired.";
                                cuisine = "Belgian";
                                Fluttertoast.showToast(
                                  msg: "Belgian",
                                );
                              } else if (rep.food == "Samosa") {
                                _recipeController.text =
                                    "start by making the dough. Mix together flour, salt, and oil in a bowl, then gradually add water to form a stiff dough. Knead the dough until smooth, then cover and let it rest for about 30 minutes. Meanwhile, prepare the filling by cooking diced potatoes, peas, and spices such as cumin, coriander, and garam masala in a skillet until tender. Allow the filling to cool completely. Divide the dough into small balls and roll each ball into a thin circle. Cut each circle in half to form semi-circles. Place a spoonful of the filling on one half of each semi-circle, then fold the other half over to enclose the filling and form a triangle. Press the edges together to seal. Heat oil in a deep fryer or skillet and fry the samosas until golden brown and crispy. Serve hot with chutney or dipping sauce.";
                                cuisine = "Indian";
                                Fluttertoast.showToast(
                                  msg: "Indian",
                                );
                              }
                            });
                          },
                          child: Text(
                            "Auto-genarate Recipe",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

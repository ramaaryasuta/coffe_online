import 'package:flutter/material.dart';

class GaleryCoffeScreem extends StatelessWidget {
  const GaleryCoffeScreem({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> coffeeList = [
      {
        "image":
            "https://img.freepik.com/free-photo/fresh-coffee-steams-wooden-table-close-up-generative-ai_188544-8923.jpg",
        "coffee_name": "Espresso",
        "desc": "Kopi dengan rasa penuh, disajikan dalam porsi kecil dan kuat."
      },
      {
        "image":
            "https://images.unsplash.com/photo-1543256840-0709ad5d3726?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y29mZmVlJTIwcGhvdG9ncmFwaHl8ZW58MHx8MHx8fDA%3D",
        "coffee_name": "Latte",
        "desc":
            "Minuman kopi yang dibuat dengan espresso dan susu yang dikukus."
      },
      {
        "image":
            "https://somedayilllearn.com/wp-content/uploads/2020/05/cup-of-black-coffee-scaled-720x540.jpeg",
        "coffee_name": "Cappuccino",
        "desc": "Minuman kopi berbasis espresso dengan busa susu di atasnya."
      },
      {
        "image":
            "https://www.allrecipes.com/thmb/Hqro0FNdnDEwDjrEoxhMfKdWfOY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/21667-easy-iced-coffee-ddmfs-4x3-0093-7becf3932bd64ed7b594d46c02d0889f.jpg",
        "coffee_name": "Americano",
        "desc":
            "Espresso yang dicampur dengan air panas untuk menghasilkan rasa kopi yang lebih ringan."
      },
      {
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXwck4mtr1y1MulgaJWP79_3t4yO57dS0dGw&s",
        "coffee_name": "Mocha",
        "desc": "Kombinasi antara kopi, cokelat, dan susu yang dikukus."
      },
      {
        "image":
            "https://static.scientificamerican.com/sciam/cache/file/4A9B64B5-4625-4635-848AF1CD534EBC1A_source.jpg?w=1200",
        "coffee_name": "Macchiato",
        "desc": "Espresso dengan sedikit busa susu di atasnya."
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Perkopian'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: coffeeList.length,
        itemBuilder: (context, index) {
          final coffee = coffeeList[index];
          return Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    coffee["image"]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    coffee["coffee_name"]!,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    coffee["desc"]!,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

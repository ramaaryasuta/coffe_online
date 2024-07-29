import 'package:flutter/material.dart';

class GaleryCoffeScreem extends StatefulWidget {
  final List<Map<String, dynamic>> coffeeList;

  const GaleryCoffeScreem({super.key, required this.coffeeList});

  @override
  _GaleryCoffeScreemState createState() => _GaleryCoffeScreemState();
}

class _GaleryCoffeScreemState extends State<GaleryCoffeScreem> {
  String selectedType = 'semua';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredCoffeeList = selectedType == 'semua'
        ? widget.coffeeList
        : widget.coffeeList
            .where((coffee) => coffee['type'] == selectedType)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Perkopian'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedType,
              onChanged: (String? newType) {
                setState(() {
                  selectedType = newType ?? 'semua';
                });
              },
              items: ['semua', 'starling', 'modern']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredCoffeeList.length,
              itemBuilder: (context, index) {
                final coffee = filteredCoffeeList[index];
                return Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100, // Set the desired height for the image
                        width: double
                            .infinity, // Set the width to match the card width
                        child: Image.network(
                          coffee["image_link"]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          coffee["name"]!,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SingleChildScrollView(
                            child: Text(
                              coffee["desc"]!,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

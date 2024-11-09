import 'package:flutter/material.dart';

class PetFilter extends StatelessWidget {
  final Function(int) onFilterSelected;

  const PetFilter({Key? key, required this.onFilterSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
           _buildFilterButton(
          icon: 'assets/icons/All_icon.png', 
         
          filterId: 0,
        ),
        const SizedBox(width: 20),
        _buildFilterButton(
          icon: 'assets/icons/Dog_icon.png', 
          
          filterId: 1,
        ),
        const SizedBox(width: 20),
        _buildFilterButton(
           icon: 'assets/icons/Cat_icon.png', 
       
          filterId: 2,
        ),
                

     
      ],
    );
  }

  Widget _buildFilterButton({required String  icon,   required int filterId}) {
    return GestureDetector(
      onTap: () {
        onFilterSelected(filterId); 
      },
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 50, 
            height: 50,
            color: Colors.purple, 
          ),
          
        ],
      ),
    );
  }
}

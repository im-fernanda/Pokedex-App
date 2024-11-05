import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            Image.asset(
              'assets/logo.png',
              height: 100,
              width: 400,
            ),
            const SizedBox(height: 40),
            _buildNavigationButton(context,
                title: 'Pokédex', routeName: '/pokedex'),
            const SizedBox(height: 20),
            _buildNavigationButton(context,
                title: 'Encontro Diário', routeName: '/encontroDiario'),
            const SizedBox(height: 20),
            _buildNavigationButton(context,
                title: 'Meus Pokémons', routeName: '/myPokemons'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context,
      {required String title, required String routeName}) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

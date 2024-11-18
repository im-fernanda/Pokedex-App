[FLUTTER_BADGE]: https://img.shields.io/badge/flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white
[DART_BADGE]: https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white
[SQFLITE_BADGE]: https://img.shields.io/badge/sqflite-%2312100E.svg?style=for-the-badge&logo=sqlite&logoColor=white

<h1 align="center" style="font-weight: bold;"> Pokédex Mobile </h1>

![flutter][FLUTTER_BADGE]
![dart][DART_BADGE]
![sqflite][SQFLITE_BADGE]


<p align="center">
  <a href="#started">Getting Started</a> • 
  <a href="#features">Features</a> • 
  <a href="#database">Database</a>
</p>

<p align="justify">
Aplicativo Flutter que simula uma Pokédex funcional, utilizando Material Design 3, banco de dados local com Sqflite e interações visuais aprimoradas com Awesome Dialogs. O projeto foi desenvolvido com o objetivo de explorar conceitos de Flutter, gerenciamento de estado e persistência de dados.
</p>

---  

<h2 id="started">🚀 Getting Started</h2>

1. Certifique-se de que você tem o Flutter instalado e configurado no seu ambiente. Caso contrário, siga as instruções [aqui](https://docs.flutter.dev/get-started/install).
2. Clone o repositório e acesse o diretório do projeto:
   ```bash
   git clone https://github.com/im-fernanda/pokedex-app.git
   cd pokedex-app
3. Instale as dependências do projeto:
    ```bash
    flutter pub get
4. Execute o aplicativo em um dispositivo físico ou emulador:
    ```bash  
    flutter run

<h2 id="features">✨ Features</h2>
<p>📂 Pokedex: Lista de todos os pokémons até o id 809. </p>

<p>🔍 Encontro Diário: Um Pokémon é sorteado diariamente para que você tenha a oportunidade de capturá-lo.</p>

<p>🗂️ Meus Pokémon: Pokémon capturados e armazenados na sua Pokédex (limite de 6).</p>

<h2 id="database">🗄️ Database </h2>

O aplicativo utiliza o pacote sqflite para persistência local. O banco de dados possui tabelas para armazenar informações sobre Pokémon e seus status de captura.



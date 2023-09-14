class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Guida per la cattura dei fossili',
      image: 'assets/image/coordinate_fossile.png',
      discription: "Quando sarai nelle vicinanze del fossile,l'icona delle coordinate geografiche diventerà verde e potrai proseguire con la cattura."
  ),
  UnbordingContent(
      title: 'Identificazione del piano',
      image: 'assets/image/plane_detected.jpg',
      discription: "Una volta che ti troverai nei pressi del fossile,rimani immobile per permettere alla fotocamera di individuare un piano su cui far apparire il fossile."
  ),
  UnbordingContent(
      title: 'Ancoraggio del fossile',
      image: 'assets/image/plane_detected_draw.png',
      discription: "Una volta che la fotocamera avrà individuato il piano,sarai tu utente a scegliere dove piazzare il fossile cliccando su un nodo del piano."
  ),
  UnbordingContent(
      title: 'Cattura del fossile',
      image: 'assets/image/fossile_spawnato.jpg',
      discription: "Una volta che il fossile sarà apparso,per catturarlo basterà avvicinarsi e quando sarai molto vicino premere il pulsante cattura."
  ),
];
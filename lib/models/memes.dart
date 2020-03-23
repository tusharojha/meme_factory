class Memes {
  final List<Meme> memes;

  Memes({this.memes});

  factory Memes.fromJSON(Map<String, dynamic> json){
    List<Meme> mes = [];
    for(Map<String, dynamic> item in json['data']){
      mes.add(Meme(imageUrl: item['image'], height: item['height'], width: item['width']));
    }
    return Memes(
      memes: mes
    );
  }
}
class Meme {

  final String imageUrl;
  final double height;
  final double width;

  Meme({this.imageUrl, this.height, this.width});

}
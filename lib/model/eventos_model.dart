class EventosListHomePageDTO {
  String id;
  String titulo;
  String date;
  String image;

  EventosListHomePageDTO(this.id, this.titulo, this.date, this.image);

  factory EventosListHomePageDTO.fromJson(Map<String, dynamic> json) {
    return EventosListHomePageDTO(
        json['id'], json['titulo'], json['date'], json['image']);
  }
}

class AnimatedGif {
  Gif gif;
  float x, y;
  float speed;

  AnimatedGif(String fileName, PApplet parent, float startX, float startY, float movementSpeed) {
    gif = new Gif(parent, fileName);
    gif.play();
    x = startX;
    y = startY;
    speed = movementSpeed;
  }

  void display() {
    image(gif, x, y);
  }

  void move(float boundaryWidth) {
    x += speed;
    if (x > boundaryWidth) {
      x = -gif.width;
    }
  }
}

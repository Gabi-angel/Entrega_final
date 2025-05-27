import ddf.minim.*;
import ddf.minim.analysis.*;
float volumen = 0.5;
import processing.event.MouseEvent;
import processing.event.*; // Necesario para MouseEvent


PImage img1, img2;
int estado = 0; // 0: img1, 1: img2, 2: img2 + música

Minim minim;
AudioPlayer player;
FFT fft;

boolean isPaused = false;

void setup() {
  size(400, 600);
  img1 = loadImage("Puerta Roja.jpeg");
  img2 = loadImage("Banda.jpeg");

  minim= new Minim (this);
  player = minim.loadFile("Gorillaz.mp3");
  player.play();
  fft = new FFT ( player.bufferSize(), player.sampleRate ());
}

void draw() {
  background(0);

  if (estado == 0) {
    image(img1, 0, 0, width, height);
  } else {
    image(img2, 0, 0, width, height);

    if (estado == 2) {
      // Dibujar botones
      fill(255, 100);
      rect(50, height - 80, 100, 40); // Pausa/Reanudar
      rect(170, height - 80, 100, 40); // Stop

      fill(0);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(isPaused ? "Reanudar" : "Pausar", 100, height - 60);
      text("Apagar", 220, height - 60);
    }
  }
}

void mousePressed() {
  if (estado == 0) {
    estado = 1;
  } else if (estado == 1) {
    estado = 2;
    player.play();
  } else if (estado == 2) {
    // Verificar si se hizo clic en botón "Pausar/Reanudar"
    if (mouseX > 50 && mouseX < 150 && mouseY > height - 80 && mouseY < height - 40) {
      if (player.isPlaying()) {
        player.pause();
        isPaused = true;
      } else {
        player.play();
        isPaused = false;
      }
    }

    // Verificar si se hizo clic en botón "Detener"
    if (mouseX > 170 && mouseX < 270 && mouseY > height - 80 && mouseY < height - 40) {
      player.pause();
      player.rewind();
      isPaused = false;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  volumen += e * 0.05;
  volumen = constrain(volumen, 0, 1);
  player.setGain(map(volumen, 0, 1, -80, 0)); // Ajusta el volumen
}

import ddf.minim.*;
import ddf.minim.analysis.*;

final float e = 2.71828182846;

Minim      minim;
AudioInput in;
FFT        fft;

PImage head;
PImage mouth;
//PImage eyes;
//PImage eyesBackground;

void setup() {
  fullScreen(P3D, 2);

  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  
  head = loadImage("assets/trond-head.png");
  mouth = loadImage("assets/trond-mouth.png");
  //eyes = loadImage("assets/eyes.png");
  //eyesBackground = loadImage("assets/eyes_background.png");
}

float noiseX = 0;
float noiseY = 9999;

void draw() {
  fft.forward( in.mix );
  
  //image(eyesBackground, 0, 0);
  
  float eyesX = map(noise(noiseX), 0, 1, -30, 25);
  float eyesY = map(noise(noiseY), 0, 1, -20, 15);
  
  noiseX += 0.005;
  noiseY += 0.005;
  
  //image(eyes, eyesX, eyesY);
  
  image(head, 0, 0);
  
  float yPos = map(getAudioLevel(), 0, 200, -5, 5);
  yPos = sigmoid(yPos) * 50;
  image(mouth, 0, yPos);
}

float getAudioLevel() {
  float sum = 0;
  for (int i = 0; i < fft.specSize(); i++) {
    sum += fft.getBand(i);
  }
  return sum;
}

float sigmoid(float x) {
  return 1 / (1 + pow(e, -x));
}

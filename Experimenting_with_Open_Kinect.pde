import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect kinect;
PImage videoImg, depthImg, rawImg;
int[] rawDepth;
boolean ir, colorDepth, mirror, trails;

void setup(){
  size(1283, 963);
  background(30);
  kinect = new Kinect(this);
  rawImg = createImage(kinect.width, kinect.height, RGB);
  ir = false;
  colorDepth = false;
  mirror = false;
  trails = false;
  kinect.initVideo();
  kinect.initDepth();
}

void draw(){
  //background(40);
  
  kinect.enableIR(ir);
  kinect.enableColorDepth(colorDepth);
  kinect.enableMirror(mirror);
  
  depthImg = kinect.getDepthImage();
  videoImg = kinect.getVideoImage();
  rawDepth = kinect.getRawDepth();
  
  /* * * * FRAME 1 * * * */
  
  if (kinect.numDevices() == 0){
    textSize(20);
    textAlign(CENTER);
    text("No Kinect device detected!", width/4, height/4);
  }
  else {
    image(videoImg, 0, 0);
  }
  
  /* * * * FRAME 2 * * * */
  translate(643, 0);
  if (kinect.numDevices() == 0){
    textSize(20);
    textAlign(CENTER);
    text("No Kinect device detected!", width/4, height/4);
  } 
  else {
    rawImg.loadPixels();
  
    colorMode(HSB);
    for (int i = 0; i < kinect.width; i++){
      for (int j = 0; j < kinect.height; j++){
        if (rawDepth[j*kinect.width + i] < 930 && rawDepth[j*kinect.width + i] > 700) {
          rawImg.pixels[j*kinect.width + i] = color(map(rawDepth[j*kinect.width + i], 700, 900, 255, 100), 255, map(rawDepth[j*kinect.width + i], 850, 930, 255, 0));
          //rawImg.pixels[j*kinect.width + i] = videoImg.pixels[j*kinect.width + i];
          //rawImg.pixels[j*kinect.width + i] = color(255);
        } 
        else if (rawDepth[j*kinect.width + i] <= 700) // closerange effects
        {
          rawImg.pixels[j*kinect.width + i] = color(0);
          rawImg.pixels[j*kinect.width + i] = color(map(rawDepth[j*kinect.width + i], 700, 900, 255, 100), 255, map(rawDepth[j*kinect.width + i], 580, 700, 0, 255));
        }
        else if (!trails) {
          rawImg.pixels[j*kinect.width + i] = color(0);
          //rawImg.pixels[j*kinect.width + i] = videoImg.pixels[j*kinect.width + i];
        }
      }
    }
    
    rawImg.updatePixels();
  
    image(rawImg, 0, 0);
  }
  
  /* * * * FRAME 3 * * * */
  translate(-643, 483);
  
  if (kinect.numDevices() == 0){
    textSize(20);
    textAlign(CENTER);
    text("No Kinect device detected!", width/4, height/4);
  }
  else {
    image(depthImg, 0, 0);
  }
  
  /* * * * FRAME 4 * * * */
  translate(643, 0);
  rect(10,10,10,10);
 
  
  translate(-643, -483);
  strokeWeight(3);
  stroke(200);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void keyPressed(){
  if (key == 'i') {
    ir = !ir;
  }
  else if (key == 'c') {
    colorDepth = !colorDepth;
  }
  else if (key == 'm') {
    mirror = !mirror;
  } 
  else if (key == 't') {
    trails = !trails;
  } 
  else if (keyCode == UP) {
    float tilt = kinect.getTilt();
    kinect.setTilt(tilt + 1);
  }
  else if (keyCode == DOWN) {
    float tilt = kinect.getTilt();
    kinect.setTilt(tilt - 1);
  }
}

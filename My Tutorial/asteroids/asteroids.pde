// global variables:
PVector shipPosition; // "Processing Vector" type, 2D or 3D vector
PVector shipVelocity;
float shipAngle = 0;
float shipThrustPower = 0.5; // acceleration of the ship
float shipMaxSpeed = 3; // maximum speed the ship can reach
float shipRadius = 10;

PVector shipOrbiterPosition;
float shipOrbiterDistance = 50; //orbiter's distance from ship
float shipOrbiterAngle;

int numasteroids = 1;  
PVector asteroids[];
float asteroidRadius = 6;

// game state variables:
int gameState;
public final int INTRO = 1;
public final int PLAY = 2;
public final int PAUSE = 3;
public final int GAMEOVER = 4;

void setup() // executes once
{ 
  size(1200,800); // set window size
  
  shipPosition = new PVector(0,0); //the ship's position
  shipVelocity = new PVector(0,0); //the ship's velocity
  
  shipOrbiterPosition = new PVector(-shipOrbiterDistance,0);
  shipOrbiterAngle = 0; //orbiter's angle around ship
  
  asteroids = new PVector[numasteroids];  
 
  for (int i = 0; i < numasteroids; i++)
  {
//       asteroids[i] = new PVector(random(-width,width*2),random(-height,height*2)); // assign each asteroid a random position
         asteroids[i] = new PVector(width/2+50, height/2);
  } 

  gameState = INTRO; // begin with the start state

  noStroke(); // no outlines around shapes  
}


void draw() // draw loop, executes repeatedly
{
  switch(gameState) 
  {
    case INTRO:
      drawScreen("Welcome!", "Press ENTER to begin");
      break;
    case PAUSE:
      drawScreen("PAUSED", "Press p to resume");
      break;
    case GAMEOVER:
      drawScreen("GAMEOVER", "Press ENTER to try again");
      break;
    case PLAY:
      background(30,0,20); // clear screen to this background color
         
      // update ship position
      shipPosition.add(shipVelocity);
      
      // draw ship
      drawShip();
      
      // update ship orbiter position
      shipOrbiterAngle++;
      shipOrbiterPosition.x = sin(radians(shipOrbiterAngle)) * shipOrbiterDistance;
      shipOrbiterPosition.y = cos(radians(shipOrbiterAngle)) * shipOrbiterDistance;
    
      // draw ship orbiter
      drawShipOrbiter();
       
      // draw asteroids & check for collisions
      for (int i = 0; i < numasteroids; i++)
      {
        drawAsteroid(asteroids[i]);
      
        if(isShipCollidingWith(asteroids[i]))
          gameState=GAMEOVER;
      }  
      
      break;
  }
  
}

void drawScreen(String title, String instructions) 
{
  background(0,0,0);
  
  // draw title
  fill(255,100,0);
  textSize(60);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
}

void drawShip()
{ 
  fill(255,255,255); // set draw color
  pushMatrix();
  
  // move the origin to the pivot point
  translate(width/2, height/2); 

  // then pivot the grid
  rotate(radians(shipAngle));
  
  // and draw the ship at the origin
  triangle(-10, 15, 0, -10, 10, 15);
  
  popMatrix();  
}

void drawShipOrbiter()
{
  pushMatrix();

  // move the origin to the pivot point
  translate(width/2, height/2); 
  
  // draw ship orbiter
  fill(0,255,0); // set draw color
  ellipse(shipOrbiterPosition.x, shipOrbiterPosition.y, 10, 10);

  popMatrix();
}

void drawAsteroid(PVector asteroid)
{
  fill(250,230,80); // set draw color
  ellipse(asteroid.x-shipPosition.x, asteroid.y-shipPosition.y, asteroidRadius*2,asteroidRadius*2); // drawn relative to ship's position
}

boolean isShipCollidingWith(PVector asteroid)
{
  float distance = sqrt( sq(shipPosition.x - asteroid.x) + sq(shipPosition.y - asteroid.y) );
  
  println(distance);
  
  return distance < ( shipRadius + asteroidRadius );
}

void keyPressed()
{
  // executed on key press
  
  // menu actions
  if(key==ENTER && ( gameState==INTRO || gameState==GAMEOVER ))
    gameState=PLAY;
  
  if(key=='p' && gameState==PLAY)
    gameState=PAUSE;
  else if(key=='p' && gameState==PAUSE)
    gameState=PLAY;
    
    
  if(keyCode==UP) { //thrust
    // maintain old velocity in case new velocity exceeds maximum speed
    PVector oldVelocity = shipVelocity;
    
    shipVelocity.x += sin(radians(shipAngle)) * shipThrustPower;
    shipVelocity.y -= cos(radians(shipAngle)) * shipThrustPower;
    
    if (shipVelocity.mag() > shipMaxSpeed) shipVelocity = oldVelocity;
  }

  if(keyCode==LEFT)
    shipAngle-=5;
  if(keyCode==RIGHT)
    shipAngle+=5;  
}

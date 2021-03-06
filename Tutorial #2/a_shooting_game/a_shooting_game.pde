// global variables:
PVector ship; // "Processing Vector" type, 2D or 3D vector
float shipVelocity = 0;
int numstars = 40;  
PVector star[];
float []star_moving_speed; 
int []star_shot_flag; //the flag showing whether the star is shot by a bullet

PVector bullets[];
int numbullets = 5;
int start_shooting=0; //the flag that shows whether the ship shoots a bullet
int explode=0; //the flag that shows whether the bullet hits a star and explodes
int score=0; 
int currentBullet = 0;

void setup() // executes once
{
  size(400,400); // set window size
  ship = new PVector(200,350); //the ship's position
  star = new PVector[numstars];
  bullets = new PVector[numbullets];
  star_moving_speed = new float[numstars];
  star_shot_flag= new int[numstars];

 // initialize bullets array
 for (int i = 0; i < numbullets; i ++ ) { // Initialize each Car using a for loop.
    bullets[i] = new PVector(0, -20); 
  }
 
  for (int i = 0; i < numstars; i++)
  {
       star[i] = new PVector(random(0,width),random(0,height/2));
       star_moving_speed[i] =random(0,2.0);
       star_shot_flag[i]= 0; //initially no star is shot
  } 

  noStroke(); // no outlines around shapes  
 
}




void draw() // draw loop, executes repeatedly
{
  background(30,0,20); // clear screen to this background color
  fill(250,230,80); // set draw color
  for (int i = 0; i < numstars && start_shooting==0; i++) // draw all stars before the ship shoots a bullet
     ellipse(star[i].x,star[i].y,12,12);
   
     
  // change ship position
  ship.x += shipVelocity;
  
  if (shipVelocity > 0)
    shipVelocity -= 0.5;
  else if (shipVelocity < 0)
    shipVelocity += 0.5; 
  fill(20,180,250); // set draw color
  ellipse(ship.x,ship.y,20,20); // draw ship

        
  for (int i = 0; i < numstars; i++)
  {
    star[i].x=star[i].x;
    star[i].y=star[i].y+star_moving_speed[i]; // stars move in y direction and each has its own speed   
  }
  
  
  if(start_shooting==1) //after the ship shoots a bullet
  {
    
       if(explode==0) //if the bullet does not hit a star (i.e. it keeps moving), we draw the bullet; otherwise we skip drawing it.
       {  
         for (int i = 0; i < numbullets; i++)
         {
            bullets[i].y -= 5; 
            fill(20,180,250); // set draw color
            ellipse(bullets[i].x,bullets[i].y,10,10); // draw bullet
         }
       }
    
     
      for (int i = 0; i < numstars ; i++) // draw the stars that are not shot by bullets
      {  
         if(star_shot_flag[i]==0) 
         {
             for (int j = 0; j < numbullets; j++)
             {
               float distanceStarBullet; //the distance between star and bullet
               distanceStarBullet= sqrt((bullets[j].x- star[i].x)*(bullets[j].x- star[i].x)+(bullets[j].y- star[i].y)*(bullets[j].y- star[i].y));
               
               if(distanceStarBullet<11) //star that is close to a bullet within a distance is shot
               {  
                  star_shot_flag[i]=1; //set flags
                  explode=1; 
                  score++; //update score
               }
             }
             float distanceStarPlayer; //the distance between star and bullet
             distanceStarPlayer= sqrt((ship.x- star[i].x)*(ship.x- star[i].x)+(ship.y- star[i].y)*(ship.y- star[i].y));
             
             if(distanceStarPlayer<16) //star that is close to player kills player and ends game
               exit();
             
            fill(250,230,80); // set draw color
            ellipse(star[i].x,star[i].y,12,12); 
         }
      }
   
  }
  
  //display the score
  fill(255, 0, 0);
  textSize(32);
  text("Score", 10, 350); 
  text(score, 10, 380);
  
}

void mousePressed()
{
  // executed on mouse click
  // reset star and ship position

  for (int i = 0; i < numstars; i++)
  {
       star[i] = new PVector(random(0,width),random(0,height/2));
       star_moving_speed[i] = random(0,2.0);
       star_shot_flag[i]= 0; 
  }
  
  ship = new PVector(200,350);   
  score=0;
  
}

void keyPressed()
{
  // executed on key press
  
  // destroy half the stars when "a" pressed
  if (key == 'a')
     numstars = numstars/2;
     
  if(key=='f')//shoot a bullet when "f" pressed
  { explode=0;
    bullets[currentBullet]= new PVector(ship.x,ship.y);
    start_shooting=1;
    currentBullet++;
    currentBullet = currentBullet % 5;  
  }  
  
  if(key=='j' && shipVelocity > -10) //move left when "j" pressed
    shipVelocity=shipVelocity-3;
  
  if(key=='k' && shipVelocity < 10) //move right when "k" pressed
    shipVelocity=shipVelocity+3;    
}

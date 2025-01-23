//final project
import gifAnimation.*;
import ddf.minim.*;

Minim minim;
AudioPlayer runSound, attackSound, jumpSound, menuSound;

Gif idle, run, jump, attack, attack2;
Gif menuBackground;

ArrayList<Enemy> enemies;

String currentState = "idle";
float rollScaleFactor = 3.7; // Skala animasi roll, bisa berbeda dari scaleFactor


float x, y; // Posisi karakter utama (pemain)
float scaleFactor = 3.0; // Faktor skala untuk memperbesar karakter
boolean facingRight = true; // Arah karakter pemain, true jika menghadap kanan

// Variabel lompat
float velocityY = 10; // Kecepatan vertikal
float gravity = 1; // Gaya gravitasi
float jumpStrength = -15; // Kekuatan lompat
boolean isJumping = false; // Apakah karakter sedang melompat

PImage bg1, bg2, bg3; // Gambar latar belakang
float bgX1 = 0, bgX2; // Posisi horizontal untuk dua instansi latar
float bgSpeed = 2; // Kecepatan pergerakan latar
boolean movingLeft = false; // Apakah bergerak ke kiri
boolean movingRight = false; // Apakah bergerak ke kanan

// Tambahkan variabel global untuk stage
boolean nearArrow = false; // Apakah pemain berada dekat arrow
boolean onNextStage = false; // Apakah pemain sudah di stage berikutnya

PImage ground; // Gambar tanah (ground)
float groundX1 = 0, groundX2; // Posisi horizontal untuk dua instansi tanah
float groundY; // Posisi vertikal tanah
float groundWidth; // Panjang tanah yang diperbesar
float groundSpeed = 1; // Kecepatan pergerakan tanah (lebih lambat dari latar belakang)

boolean inMenu = true; // State untuk menu
Button playButton; // Tombol untuk memulai game

boolean isAttacking = false; // Apakah karakter sedang menyerang
PFont pixelFont; // Font game

HealthBar playerHealthBar;  // Objek untuk bar darah karakter utama
Gif hit; // Animasi hit saat terkena serangan musuh


// Tambahkan variabel untuk animasi roll
Gif roll;
boolean isRolling = false; // Status apakah karakter sedang roll
boolean isLongRoll = false; // Status untuk roll panjang
float rollSpeed = 0.1; // Kecepatan roll normal
float longRollSpeed = 1.5; // Kecepatan roll panjang (jauh)
AudioPlayer rollSound; // Back sound untuk roll

PImage cursorNext; // Gambar kursor untuk tahap berikutnya
boolean showCursorNext = false; // Status apakah kursor ditampilkan
boolean cursorBlink = true; // Status berkedip kursor
int cursorBlinkTimer = 0; // Timer untuk berkedip
int cursorBlinkInterval = 30; // Interval berkedip (frame)

AnimatedGif bird1;
AnimatedGif bird2;
AnimatedGif bird3;
AnimatedGif bird4;

float zOffset = 1000;  // Variabel untuk mendefinisikan kedalaman (dalam kisaran nilai positif atau negatif)


void setup() {
  fullScreen(P2D);
  menuBackground = new Gif(this, "backgroundMenu.gif");
  menuBackground.play();

  // Inisialisasi tombol
  playButton = new Button(width / 4 - 80, height / 2 - 100, 200, 80, "Play Game");
  
  cursorNext = loadImage("CursorNext.png");

  // Inisialisasi variabel permainan
  x = 200;
  y = 920;
  groundY = height - 1000;
  bgX2 = width;

  bg1 = loadImage("background_layer_1.png");
  bg2 = loadImage("background_layer_2.png");
  bg3 = loadImage("background_layer_3.png");
  
  bird1 = new AnimatedGif("bird.gif", this, 0, height / 3 - 50, 4); 
  bird2 = new AnimatedGif("bird.gif", this, 0, height / 6 + 50, 4); 
  bird3 = new AnimatedGif("bird.gif", this, 0, height / 9 + 150, 4);
  bird4 = new AnimatedGif("bird.gif", this, 0, height / 12 + 250, 4);
  
  
  
  ground = loadImage("NewGround.png");
  groundWidth = width * 1.5;
  groundX2 = groundX1 + groundWidth;

  idle = new Gif(this, "__Idle.gif");
  run = new Gif(this, "__Run.gif");
  jump = new Gif(this, "__Jump.gif");
  attack = new Gif(this, "__Attack.gif");
  roll = new Gif(this, "__Roll.gif");
  attack2 = new Gif(this, "__Attack2.gif");
  hit = new Gif(this, "__Hit.gif");
  


  
  attack2.play(); 
  idle.play();
  run.play();
  jump.play();
  attack.play();
  roll.play();
   hit.play();
  
   
  

  pixelFont = createFont("PixelGameFont.ttf", 32);
  textFont(pixelFont);

  minim = new Minim(this);
  runSound = minim.loadFile("run.mp3");
  attackSound = minim.loadFile("attack.mp3");
  jumpSound = minim.loadFile("jump.mp3");
  rollSound = minim.loadFile("roll.mp3");

  // Tambahkan backsound menu
  menuSound = minim.loadFile("menu.mp3");
  menuSound.loop(); // Putar backsound menu secara berulang

  // Inisialisasi musuh
  enemies = new ArrayList<Enemy>();
  // Inisialisasi animasi musuh
Gif musuh1Idle = new Gif(this, "enemy_idle.gif");
Gif musuh1Run = new Gif(this, "enemy_run.gif");
Gif musuh1Attack = new Gif(this, "enemy_attack.gif");
Gif musuh1Hurt = new Gif(this, "enemy_hurt.gif");
Gif musuh1Death = new Gif(this, "enemy_death.gif");

Gif musuh2Idle = new Gif(this, "enemy2_idle.gif");
Gif musuh2Run = new Gif(this, "enemy2_walk.gif");
Gif musuh2Attack = new Gif(this, "enemy2_attack.gif");
Gif musuh2Hurt = new Gif(this, "enemy2_hurt.gif");
Gif musuh2Death = new Gif(this, "enemy2_death.gif");

// Menambahkan musuh ke dalam array dengan animasi berbeda
enemies.add(new Enemy(musuh1Idle, musuh1Run, musuh1Attack, musuh1Hurt, musuh1Death, 1400, 1002, 1.6, 2, 1200, 1500));
enemies.add(new Enemy(musuh2Idle, musuh2Run, musuh2Attack, musuh2Hurt, musuh2Death, 1700, 921, 1.6, 2, 600, 750));


  // Inisialisasi bar darah karakter utama
  playerHealthBar = new HealthBar(20, 20, 100, 300, 30);  // Posisi (20, 20), Max Health 100, Width 200, Height 20
}

void draw() { 
  if (inMenu) {
    background(0);
    image(menuBackground, 1000, -500, 930, 1600);
    playButton.display();

    fill(255);
    textSize(80);
    textAlign(LEFT, CENTER);
    text("Eternal Knight", width / 6 - 100, height / 3);
    return;
  }



  // Hentikan backsound menu saat masuk permainan
  if (menuSound.isPlaying()) {
    menuSound.pause();
  }
 
  // Latar belakang
  image(bg1, bgX1, 0, width, height);
  image(bg1, bgX2, 0, width, height);
  image(bg2, bgX1, 0, width, height);
  image(bg2, bgX2, 0, width, height);
  image(bg3, bgX1, 0, width, height);
  image(bg3, bgX2, 0, width, height);

  // Tanah
  image(ground, groundX1, groundY, groundWidth, height - groundY);
  image(ground, groundX2, groundY, groundWidth, height - groundY);

  bird1.display();
  bird1.move(width);
  
  bird2.display();
  bird2.move(width + 2);
  
  bird3.display();
  bird3.move(width);
  
  bird4.display();
  bird4.move(width);

  // Pergerakan latar belakang dan tanah jika karakter bergerak
  if (movingRight && !enemies.isEmpty()) {
    bgX1 -= bgSpeed;
    bgX2 -= bgSpeed;
    groundX1 -= groundSpeed;
    groundX2 -= groundSpeed;
  } else if (movingLeft && x > 0 && !enemies.isEmpty()) {
    bgX1 += bgSpeed;
    bgX2 += bgSpeed;
    groundX1 += groundSpeed;
    groundX2 += groundSpeed;
  }

  // Looping latar belakang dan tanah
  if (bgX1 + width < 0) bgX1 = bgX2 + width;
  if (bgX2 + width < 0) bgX2 = bgX1 + width;
  if (groundX1 + groundWidth < 0) groundX1 = groundX2 + groundWidth;
  if (groundX2 + groundWidth < 0) groundX2 = groundX1 + groundWidth;

  // Looping latar belakang
  if (bgX1 >= width) bgX1 = bgX2 - width;
  if (bgX2 >= width) bgX2 = bgX1 - width;
  if (bgX1 + width <= 0) bgX1 = bgX2 + width;
  if (bgX2 + width <= 0) bgX2 = bgX1 + width;

  // Looping tanah
  if (groundX1 >= groundWidth) groundX1 = groundX2 - groundWidth;
  if (groundX2 >= groundWidth) groundX2 = groundX1 - groundWidth;
  if (groundX1 + groundWidth <= 0) groundX1 = groundX2 + groundWidth;
  if (groundX2 + groundWidth <= 0) groundX2 = groundX1 + groundWidth;

  // Gerakan lompat
  if (isJumping) {
    velocityY += gravity;
    y += velocityY;

    if (y >= 920) {
      y = 920;
      isJumping = false;
      currentState = (movingRight || movingLeft) ? "run" : "idle";
    }
  }

  // Pergerakan horizontal karakter
  if (movingRight) {
    x += 5;
  } else if (movingLeft) {
    x -= 5;
  }

  // Animasi utama
  Gif currentAnimation = idle;
  if (isJumping) {
    currentAnimation = jump;
  } else if (isRolling) {
    currentAnimation = roll;
  } else if (currentState.equals("run")) {
    currentAnimation = run;
  } else if (currentState.equals("attack")) {
    currentAnimation = attack;
  }else if (currentState.equals("attack2")) {
    currentAnimation = attack2;
   } else if (currentState.equals("hit")) {  // Jika karakter dalam keadaan "hit"
  currentAnimation = hit;
  }

  float currentScaleFactor = (isRolling) ? rollScaleFactor : scaleFactor;
  float characterWidth = currentAnimation.width * scaleFactor;
  x = constrain(x, 0, width - characterWidth);

  // Render karakter pemain
  pushMatrix();
  if (!facingRight) {
    scale(-1, 1);
    image(currentAnimation, -x - currentAnimation.width * currentScaleFactor, 
          y - currentAnimation.height * currentScaleFactor, 
          currentAnimation.width * currentScaleFactor, 
          currentAnimation.height * currentScaleFactor);
  } else {
    image(currentAnimation, x, 
          y - currentAnimation.height * currentScaleFactor, 
          currentAnimation.width * currentScaleFactor, 
          currentAnimation.height * currentScaleFactor);
  }
  popMatrix();

  // Menggambar bar darah karakter utama
  playerHealthBar.draw();

  // Update dan render musuh
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);

    if (enemy.isReadyToRemove()) {
      enemies.remove(i);
      continue;
    }

    enemy.update(x, y);
    enemy.render(x, y);

    // Memeriksa apakah musuh menyerang dan mengurangi darah karakter utama
    checkEnemyAttack(enemy);
  }

  // Periksa jika semua musuh telah dihilangkan
  if (enemies.isEmpty()) {
    showCursorNext = true; // Tampilkan kursor
  }
  if (enemies.isEmpty() && !onNextStage) {
  showCursorNext = true; // Tampilkan kursor next stage
  
  // Periksa jika karakter mendekati arrow
  float arrowX = width - 200; // Posisi X arrow
  float arrowY = height / 2; // Posisi Y arrow
  float distanceToArrow = dist(x, y, arrowX, arrowY);
  int pressEnterOffset = 320; // Offset vertikal untuk menurunkan teks
  
  if (distanceToArrow < 500) { // Jika dekat arrow
    nearArrow = true;
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Press Enter", width - 200, height - pressEnterOffset);
  } else {
    nearArrow = false;
  }
}

// Tambahkan logika untuk stage 2
if (onNextStage) {
  background(0);
  fill(255);
  textSize(80);
  textAlign(CENTER, CENTER);
  text("Stage 2", width / 2, height / 2);
  return;
}

  // Tampilkan kursor jika aktif
  if (showCursorNext) {
    // Logika berkedip
    cursorBlinkTimer++;
    if (cursorBlinkTimer >= cursorBlinkInterval) {
      cursorBlink = !cursorBlink; // Ubah status berkedip
      cursorBlinkTimer = 0; // Reset timer
    }

    // Gambar kursor jika berkedip aktif
    if (cursorBlink) {
      int cursorWidth = 180;
      int cursorHeight = 180;
      float cursorX = width - cursorWidth - 20; // Margin 20 piksel dari tepi
      float verticalOffset = 200; // Offset tambahan ke bawah
      float cursorY = height / 2 - cursorHeight / 200 + verticalOffset;
      image(cursorNext, cursorX, cursorY, cursorWidth, cursorHeight);
    }
  }
}


boolean checkCollisionWithEnemy(Enemy enemy) {
  // Perbesar jarak deteksi serangan
  return abs(enemy.x - x) < 150 && abs(enemy.y - y) < 100;  // Menggunakan jarak 150 untuk deteksi horizontal
}

// Define a variable for controlling hit animation duration
private boolean isHitAnimationActive = false;
private final long hitDuration = 600; // Duration for which the hit animation plays (in ms)
private long hitStartTime = 0;

void checkEnemyAttack(Enemy enemy) {
  if (checkCollisionWithEnemy(enemy)) {
    if (!isAttacking && !enemy.isDying) {
      // Start the hit animation if not already active
      if (!isHitAnimationActive) {
        playerHealthBar.takeDamage(4); // Karakter utama terkena serangan musuh

        // Mulai animasi hit saat terkena serangan
        currentState = "hit"; // Set current state to "hit"
        hit.stop(); // Stop any previous hit animation
        hit.play(); // Play the hit animation

        // Set the timer to stop the animation after a brief period
        isHitAnimationActive = true;
        hitStartTime = System.currentTimeMillis();
      }
    } else if (isAttacking && !enemy.isDying) {
      enemy.takeDamage(); // Karakter utama menyerang musuh
      enemy.isFocusingOnPlayer = true;  // Musuh mulai mengikuti karakter utama setelah diserang
    }

    // Stop the hit animation after the duration has passed
    if (isHitAnimationActive && (System.currentTimeMillis() - hitStartTime) > hitDuration) {
      isHitAnimationActive = false;
      currentState = "idle"; // Switch to idle or other default state
    }
  }
}


void mousePressed() {
  if (inMenu && playButton.isMouseOver()) {
    inMenu = false;
  }
  if (showCursorNext) {
  float cursorX = width - cursorNext.width * 1.0;
  float cursorY = height / 2;

  // Periksa jika kursor di klik
  if (mouseX >= cursorX && mouseX <= cursorX + cursorNext.width &&
      mouseY >= cursorY && mouseY <= cursorY + cursorNext.height) {
    showCursorNext = false; // Sembunyikan kursor setelah digunakan
  }
}

}

void keyPressed() {
  if (key == 'd') {
    if (!isRolling) { // Backsound hanya aktif jika tidak dalam keadaan roll
      currentState = "run";
      facingRight = true;
      movingRight = true;
      movingLeft = false;
      runSound.loop();
    }
  } else if (key == 'a') {
    if (!isRolling) { // Backsound hanya aktif jika tidak dalam keadaan roll
      currentState = "run";
      facingRight = false;
      movingRight = false;
      movingLeft = true;
      runSound.loop();
    }
  } else if (key == 'w' && !isJumping) {
    isJumping = true;
    velocityY = jumpStrength;
    currentState = "jump";
    jumpSound.rewind();
    jumpSound.play();
  } else if (key == 'j') {
    currentState = "attack";
    isAttacking = true;
    attackSound.rewind();
    attackSound.play();
  } else if (key == 'k') {
    currentState = "attack2";
    isAttacking = true;
    attackSound.rewind(); // Gunakan suara serangan yang sama
    attackSound.play();
  }else if (key == ' ') { // Tombol spasi untuk roll sekali
    if (!isRolling) {
      isRolling = true;
      isLongRoll = false;
      currentState = "roll";
      roll.play();
      rollSound.rewind(); // Putar sound saat roll dimulai
      rollSound.play();
      runSound.pause(); // Hentikan sound lari saat roll
      if (facingRight) {
        x += rollSpeed; // Roll ke kanan dengan kecepatan normal
      } else {
        x -= rollSpeed; // Roll ke kiri dengan kecepatan normal
      }
    }
  } else if (keyCode == SHIFT) { // Tombol shift untuk roll panjang
    if (!isRolling) {
      isRolling = true;
      isLongRoll = true;
      currentState = "roll";
      roll.play();
      rollSound.rewind(); // Putar sound saat roll dimulai
      rollSound.play();
      runSound.pause(); // Hentikan sound lari saat roll
      if (facingRight) {
        x += longRollSpeed; // Roll panjang ke kanan
      } else {
        x -= longRollSpeed; // Roll panjang ke kiri
      }
    }
  }
  // Tambahkan logika dalam fungsi keyPressed untuk pindah stage
  if (key == ENTER && nearArrow && enemies.isEmpty()) {
    onNextStage = true;
    showCursorNext = false; // Sembunyikan kursor next
  }
}

void keyReleased() {
  if ((key == 'd' || key == 'a') && !isJumping) {
    if (!isRolling) { // Pastikan tidak dalam keadaan roll sebelum mengatur ulang
      currentState = "idle";
      movingRight = false;
      movingLeft = false;
      runSound.pause();
    }
  } else if (key == 'j') {
    currentState = movingRight || movingLeft ? "run" : "idle";
    isAttacking = false;
  } else if (key == ' ' || keyCode == SHIFT) { // Reset roll ketika spasi atau shift dilepas
    isRolling = false;
    isLongRoll = false;
    rollSound.pause(); // Hentikan sound saat roll selesai
    currentState = movingRight || movingLeft ? "run" : "idle";
    if (currentState.equals("run")) { // Hanya mulai sound run jika tombol run ditekan kembali
      runSound.loop();
    }
  }
  if ((key == 'j' || key == 'k') && isAttacking) {
    isAttacking = false;
    currentState = (movingRight || movingLeft) ? "run" : "idle";
  }
}

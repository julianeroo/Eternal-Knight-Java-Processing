class Enemy {
  AudioPlayer attackSound;

  Gif idle, run, attack, hurt, death; // Animasi musuh
  float x, y; // Posisi musuh
  float scaleFactor, speed; // Faktor skala dan kecepatan musuh
  int rangeMin, rangeMax; // Batas pergerakan horizontal musuh
  boolean movingRight; // Arah pergerakan musuh
  boolean facingRight; // Arah hadap musuh
  boolean isDying = false; // Status musuh dalam proses mati
  boolean isHurt = false; // Status musuh sedang terkena serangan
  int hurtTimer = 30; // Durasi animasi hurt (frame)
  int deathTimer = 70; // Waktu animasi kematian sebelum musuh dihapus (frame)
  int hitPoints = 15; // Jumlah nyawa musuh (default 15)
  boolean isFocusingOnPlayer = false; // Status untuk mengikuti player setelah diserang

  Enemy(Gif idle, Gif run, Gif attack, Gif hurt, Gif death, float x, float y, float scaleFactor, float speed, int rangeMin, int rangeMax) {
    this.idle = idle;
    this.run = run;
    this.attack = attack;
    this.hurt = hurt;
    this.death = death;
    this.x = x;
    this.y = y;
    this.scaleFactor = scaleFactor;
    this.speed = speed;
    this.rangeMin = rangeMin;
    this.rangeMax = rangeMax;
    this.movingRight = true;
    this.facingRight = true;

    this.idle.loop();
    this.run.loop();
    this.attack.loop();
    this.hurt.stop(); // Animasi hurt dimainkan hanya saat diperlukan
    this.death.stop(); // Animasi death hanya dimainkan saat diperlukan
    
    // Muat file suara
    this.attackSound = minim.loadFile("attackEnemy1.mp3");
  }

  void update(float playerX, float playerY) {
  if (isDying) {
    deathTimer--;
    return; // Tidak ada pembaruan posisi saat sedang mati
  }

  if (isHurt) {
    hurtTimer--;
    if (hurtTimer <= 0) {
      isHurt = false; // Kembali ke animasi normal setelah animasi hurt selesai
    }
    return; // Tidak ada pembaruan posisi saat sedang hurt
  }

  if (isFocusingOnPlayer) {
    // Musuh fokus pada karakter utama setelah diserang
    speed = 4; // Kecepatan penuh saat mengejar karakter utama
    if (playerX > x) {
      x += speed; // Gerak ke kanan
    } else {
      x -= speed; // Gerak ke kiri
    }

    if (Math.abs(x - playerX) < 5) {
      isFocusingOnPlayer = false; // Berhenti fokus jika sudah dekat dengan player
    }

    facingRight = playerX > x; // Pastikan musuh menghadapi karakter utama
    return; // Keluar dari fungsi jika sedang fokus pada player
  }

  float distance = dist(x, y, playerX, playerY); // Jarak musuh dengan karakter utama

  // Jika dalam jarak serangan, atur arah hadap musuh
  if (distance < 150) {
    speed = 0; // Berhenti bergerak
    facingRight = playerX > x; // Hadap ke arah karakter utama
  } else {
    // Jika di luar jarak serangan, kembali bergerak seperti biasa
    speed = 2;
    

    if (movingRight) {
      x += speed;
      if (x >= rangeMax) {
        movingRight = false;
        facingRight = false; // Hadap kiri saat berbalik
      }
    } else {
      x -= speed;
      if (x <= rangeMin) {
        movingRight = true;
        facingRight = true; // Hadap kanan saat berbalik
      }
    }
  }
}


 void render(float playerX, float playerY) {
  Gif currentAnimation;

  // Pilih animasi berdasarkan status musuh
  if (isDying) {
    currentAnimation = death; // Animasi kematian
  } else if (isHurt) {
    currentAnimation = hurt; // Animasi hurt
  } else {
    // Saat musuh sedang mengejar karakter utama
    if (isFocusingOnPlayer) {
      currentAnimation = run; // Gunakan animasi lari
    } else {
      float distance = dist(x, y, playerX, playerY);
      if (distance < 150) {
  currentAnimation = attack; // Animasi menyerang
  if (!attackSound.isPlaying()) {
    attackSound.rewind(); // Mulai ulang jika sebelumnya sudah selesai
    attackSound.play();   // Mainkan suara serangan
  }
} else {
  currentAnimation = run; // Animasi bergerak
}

      currentAnimation = (distance < 150) ? attack : run; // Animasi menyerang atau bergerak
    }
  }

  pushMatrix();
  if (!facingRight) {
    scale(-1, 1); // Flip horizontal jika musuh menghadap ke kiri
    image(currentAnimation, -x - currentAnimation.width * scaleFactor, 
          y - currentAnimation.height * scaleFactor, 
          currentAnimation.width * scaleFactor, currentAnimation.height * scaleFactor);
  } else {
    image(currentAnimation, x, y - currentAnimation.height * scaleFactor, 
          currentAnimation.width * scaleFactor, currentAnimation.height * scaleFactor);
  }
  popMatrix();
}


boolean isReadyToRemove() {
  if (isDying && deathTimer <= 0) {
    // Jika musuh sudah mati, tandai musuh siap untuk dihapus
    return true;
  }
  return false;
}

  void takeDamage() {
    if (isDying || isHurt) return; // Tidak bisa diserang lagi jika sudah mati atau dalam status hurt

    hitPoints--; // Kurangi nyawa musuh
    isHurt = true; // Aktifkan status hurt
    hurtTimer = 2; // Reset durasi animasi hurt
    hurt.play(); // Mainkan animasi hurt

    println("Musuh terkena serangan! HitPoints: " + hitPoints); // Debugging

    if (hitPoints <= 0) {
      die(); // Aktifkan animasi kematian jika nyawa habis
    } else {
      isFocusingOnPlayer = true; // Musuh mulai mengikuti player setelah diserang
    }
  }

void die() {
  if (!isDying) {
    isDying = true; // Aktifkan status kematian
    death.play(); // Mainkan animasi kematian sekali
    println("Musuh mati!"); // Debugging
  }
}

}

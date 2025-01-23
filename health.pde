// Kelas HealthBar
class HealthBar {
  float health;  // Nilai darah saat ini
  float maxHealth;  // Nilai maksimum darah
  float x, y;  // Posisi bar darah
  float width, height;  // Ukuran bar darah

  // Konstruktor untuk menginisialisasi bar darah
  HealthBar(float x, float y, float maxHealth, float width, float height) {
    this.x = x;
    this.y = y;
    this.maxHealth = maxHealth;
    this.health = maxHealth;  // Mulai dengan nilai penuh
    this.width = width;
    this.height = height;
  }

  // Fungsi untuk mengurangi darah
  void takeDamage(float amount) {
    health -= amount;
    if (health < 0) {
      health = 0;  // Tidak boleh kurang dari 0
    }
  }

  // Fungsi untuk menyembuhkan
  void heal(float amount) {
    health += amount;
    if (health > maxHealth) {
      health = maxHealth;  // Tidak boleh melebihi nilai maksimum
    }
  }

  // Fungsi untuk menggambar bar darah
  void draw() {
    // Gambar latar belakang bar darah (merah) dengan border radius
    fill(255, 0, 0);
    noStroke();
    rect(x, y, width, height, 10);  // Corner radius 10

    // Gambar darah yang tersisa (hijau) dengan border radius
    fill(0, 255, 0);
    float healthWidth = map(health, 0, maxHealth, 0, width);  // Menghitung lebar darah yang tersisa
    rect(x, y, healthWidth, height, 10);  // Corner radius 10
    

    // Tampilkan angka kesehatan
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(height * 0.7);  // Ukuran font proporsional dengan tinggi bar darah
    text((int) health + "/" + (int) maxHealth, x + width / 2, y + height / 2);
  }

  // Fungsi untuk mendapatkan persentase darah yang tersisa
  float getHealthPercentage() {
    return health / maxHealth;
  }
}

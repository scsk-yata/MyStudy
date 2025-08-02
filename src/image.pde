// 初期設定 -- (*1) 
void setup(){
  background(255,255,255); // 背景の色
  size(640, 640); // キャンバスサイズ
  noStroke();
}

// -- (*2)
void draw(){
  // --(*3)
  for (int i =0; i < 50; i++){
    fill(random(100,255),random(240,255),random(100,255),200);
    float cSize = random(0, width/2);
    ellipse(random(width), random(height), cSize, cSize); // 円の描画
  }
  noLoop(); // -- (*4)
}

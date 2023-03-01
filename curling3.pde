import ddf.minim.*;  //ライブラリのインポート

Minim minim;  //Minim用変数
AudioInput in; //音入力オブジェクト用変数
float volumeIn;//円の直径になる変数
boolean flagA;//アクションの基準
boolean flagB;//発射フラグ
boolean flagC;//終了フラグ
int fieldX;//フィールド横サイズ
float px, py;//ストーンの位置
float vx, vy;//ストーンの初速度
float vx_now;//ストーンの速度
float offset = 0;//等速の場合この値を増やす
float cnt;//時間の代わりとなる値
float a = 1;//ストーンの加速度


void setup() {
  size(800, 600);
  minim = new Minim (this);//Minin生成
  //AudioInputオブジェクト生成
  in = minim.getLineIn(Minim.MONO, 512);
  px = 0;
  py = height/2;
  cnt = 0;
  vx = -50;
  vx_now = vx;
  vy = 0;
  fieldX = width*3;
  flagB = false;
  flagC = true;
}

void draw() {
  background(255);
  //AudioInputオブジェクトから音量を取得、入力値(0から0.5)を0から500に換算
  volumeIn = map(in.left.level(), 0, 0.5, 0, 100);
  flagA = volumeIn <= 60;//ボリュームの基準を指定
  if (flagA) fill(0, 255, 0);
  else fill(255, 0, 0);
  strokeWeight(1);
  ellipse(50, 50, volumeIn, volumeIn); //ボリュームを描画
  drawField(px);//フィールドの現在地を描画
  strokeWeight(1);
  stroke(64);
  fill(64);
  ellipse(100, py, 40, 40);
  fill(255, 0, 0);
  ellipse(100, py, 30, 30);
  rect(80, py-4, 20, 8);
  if (flagB) {
    boolean stop_St = vx_now >= 0;
    if (!stop_St) {
      py = height/2 + vy*cnt;
      if (flagA) {
        px = offset + vx * cnt + a * pow(cnt, 2) / 2;
        vx_now = vx + a*cnt;
        cnt += 0.1;
      } else {
        strokeWeight (10);
        line(150, height/2 - 100, 150, height/2);
        line(130, height/2, 170, height/2);
        line(200, height/2, 200, height/2 + 100);
        line(180, height/2, 220, height/2);
        offset += vx_now*0.1;
        px = offset + vx * cnt + a * pow(cnt, 2) / 2;
      }
      if (px <= -fieldX+120) {
        px = -fieldX+120;
        vx_now = 0;
      }
      if (py <= 15) {
        py = 15;
        vx_now = 0;
      } else if (py >= height-15) {
        py = height-15;
        vx_now = 0;
      }
    } else {
      if (flagC) {
        String result = "distance = "+dist(fieldX+px-400, height/2, 100, py);
        println(result);
        flagC = false;
      }
    }
  }
}

void stop() {
  in.close(); //音声再生オブジェクトを閉じる
  minim.stop();  //Minimオブジェクトをクリア
  super.stop();  //自分でstop()を定義した時、必須
}

void mousePressed() {
  flagB = true;
  vx = -map(mouseX, 0, width, 25, 75);
  vy = map(mouseY-height/2, -height/2, height/2, -10, 10);
}

void drawField(float x) {
  noFill();
  strokeWeight(10);
  stroke(0);
  rect(x, 0, fieldX, height);
  strokeWeight(50);
  stroke(255, 0, 0);
  ellipse(x+400, height/2, 100, 100);
  ellipse(fieldX+x-400, height/2, 100, 100);
  stroke(0, 0, 255);
  ellipse(x+400, height/2, 300, 300);
  ellipse(fieldX+x-400, height/2, 300, 300);
  strokeWeight(2);
  stroke(0);
  line(x, height/2, x+fieldX, height/2);
  line(x+400, 0, x+400, height);
  line(fieldX+x-400, 0, fieldX+x-400, height);
}

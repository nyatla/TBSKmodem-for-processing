import ddf.minim.*;

/**
 * Modulated wave file.
 */
import jp.nyatla.tbskpsg.*;
import jp.nyatla.tbskpsg.audioif.*;
import jp.nyatla.tbskpsg.result.*;
import jp.nyatla.tbskpsg.utils.*;
float[] wave;
String str;
TbskTone tone=TbskTone.xpskSin();
TbskPreamble preamble=TbskPreamble.coff(tone);

TbskModem modem;


void setup() {
  PFont font = createFont("Osaka", 10);
  textFont(font);
  Minim minim=new Minim(this);
  modem=new TbskModem(this,tone,preamble,new MinimAudioInterface(minim,16000));
  TbskModem._DEBUG=true;
  modem.start();
  size(320, 200);
  noStroke();
  last_rxn=modem.rxNumber();
}
long last_rxn;
String recvd="";
void draw() {
//print(modem.rxReady());
  background(0);
  text("Hit 'A' key to send string!",10,10);
  text(int(modem.acceptedSampleCount()),10,20);
  
  var vol=max(0,(log(modem.rms())+6.5)*3);
  rect(10,30,10+vol*10,10);

  var rxnum=modem.rxNumber();
  text("byteReady " + (modem.rxReady()?"YES":"NO"),10,50);
  text("charReady " +(modem.rxAsCharReady()?"YES":"NO"),10,60);
  text("Signal#   " +rxnum,10,70);
  if(modem.rxAsCharReady()){
    if(last_rxn!=rxnum){
      recvd="";
      last_rxn=rxnum;
    }
    recvd=recvd+modem.rxAsChar();
  }
  println(recvd);
  text(recvd,10,80);
}
void keyPressed() {
  if(key=='A'||key=='a'){
    if(modem.txReady()){
      modem.tx("Hello Processing",true);
    }
  }else{
    modem.txBreak();
  }
}
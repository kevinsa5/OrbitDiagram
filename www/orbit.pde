PlotArea plot;

void setup(){
  size(500,500);
  frameRate(5);
}

void draw(){
  if(update){
    update = false;
    updateDiagram();
    document.getElementById('loading').innerHTML = "";
  }
  if(saveImage){
    saveImage = false;
    saveFrame();
  }
}

void updateDiagram(){
  background(255);
  adapt_iter = math.eval(document.getElementById('adapt_iter').value);
  orbit_iter = math.eval(document.getElementById('orbit_iter').value);
  
  var f = math.eval("f(r,x) = " + document.getElementById('map').value);
  
  float rmin = math.eval(document.getElementById('rmin').value);
  float rmax = math.eval(document.getElementById('rmax').value);
  int Nr = 1e3;
  
  float[] r_array = new float[Nr];
  for(int i = 0; i < Nr; i++){
    r_array[i] = rmin + (rmax-rmin) * i / Nr;
  }
  float[][] mat = new float[Nr][orbit_iter];
  
  for(int i = 0; i < Nr; i++){
    float r = r_array[i];
    float x = math.eval(document.getElementById('xinit').value);
    for(int n = 0; n < adapt_iter; n++){
      x = f(r,x);
    }
    for(int n = 0; n < orbit_iter; n++){
      x = f(r,x);
      mat[i][n] = x;
    }
  }

  float xmax = Math.max(...mat[0]);
  float xmin = Math.min(...mat[0]);
  if(!isFinite(xmax)) xmax = 0;
  if(!isFinite(xmin)) xmin = 0;

  for(int i = 1; i < Nr; i++){
    float a = Math.max(...mat[i]);
    float b = Math.min(...mat[i]);
    if(isFinite(a)){
      xmax = Math.max(xmax,a);
    }
    if(isFinite(b)){
      xmin = Math.min(xmin,b);
    }
  }

  plot = new PlotArea(0,0,width,height,rmin,rmax,xmin,xmax,1);
  for(int i = 0; i < Nr; i++){
    float[] r_vec = new float[orbit_iter];
    for(int j = 0; j < r_vec.length; j++) r_vec[j] = r_array[i];
    plot.points(r_vec, mat[i]);
  }
  plot.draw();
}

String getCoordinateSystem(){ return "Cartesian";}

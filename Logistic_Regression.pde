import java.util.*;



// key bindings
char TrainKey = 't';
char ResetKey='r';


int BackgroundColour=220;


Graph graph=new Graph(1000, 1000, 2, 2);
int UIWidth =500;
TEXTBOX LearningRateEntry=new TEXTBOX(graph.Width+10, 445, 200, 50);


Matrix TrainingPoints = new Matrix();


int count=0;


void settings() {
  size(graph.Width+UIWidth, graph.Height);
}

void setup() {
}

void draw() {

  //println(count);
  count+=1;

  Train();

  DrawPointMatrix(MapToCanvas(TrainingPoints,graph.RowNum,graph.ColNum,graph.Width,graph.Height),color(255,0,0),color(0,0,0),30,5);
  graph.Draw();
  DrawUI();
}

void Train() {
  for (int i =0; i<100; i++) {
  }
}



Matrix SamplePoints(Matrix points, float start, float end, float density, Function function) {
  // function returns a matrix of points, which sample values from a function, from start to end, with a particular density
  for (float x =start; x<=end; x+=density) {
    points.AddColumn(new Float[]{x, function.function(x)});
  }
  return points;
}


void AddPoint(float x, float y) {
  if (x<graph.Width) {
    Point point ;

    if (y>graph.Height/2) {
      // if point is in top half of graph then it is a 1
      point= new Point(x, graph.Height);
    } else {
      // if point is in bottom of graph then it is a 0
      point= new Point(x, 0);
    }
    // map point to cartesian plane 
    println("pre " + point.x + ":"+point.y);
    point=MapPointToCartesian(point, graph.ColNum, graph.RowNum, graph.Width, graph.Height);
    println("post " + point.x + ":"+point.y);
    // add point to training points
    TrainingPoints.AddColumn(new Float[]{point.x, point.y});
    
  }
}



void mousePressed() {
  AddPoint(mouseX,mouseY);
  LearningRateEntry.PRESSED(mouseX, mouseY);
}

void keyPressed() {
  if ( key==TrainKey) {
    Train();
  } else if ( key== ResetKey) {
    Reset();
  }


  LearningRateEntry.KEYPRESSED(key, keyCode);
}

void Reset() {
  println("Reset");
  // resets both the points and the network
}


void DrawUI() {
  // creates UI box at right hand of screen
  fill(220);
  stroke(0);
  rect(graph.Width, 0, width-graph.Width, height);

  // writes instructions
  stroke(0);
  textFont(createFont("Arial", 20, true), 25);
  fill(0);
  text("Click to add a point", graph.Width+10, 75);
  text("Press R to reset points", graph.Width+10, 150);
  text("Press N to reset network", graph.Width+10, 225);
  text("Press S to switch activation functions", graph.Width+10, 300);




  // draws learning rate entry box
  textFont(createFont("Arial", 20, true), 25);
  text("Learning Rate:", graph.Width+10, 435);
  LearningRateEntry.DRAW();
}

float GetLearningRate() {
  // returns the learning rate entered in the learning rate entry box
  float lr=float(LearningRateEntry.Text);

  if (Float.isNaN(lr)) {
    return 0.0004;
  }
  return lr;
}

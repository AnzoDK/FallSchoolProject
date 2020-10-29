/*
Before diving into the madness that is this horrible code.
I'd like to inform you why there is SOOOOOOOO many "{obejct} != null" statements.
It seems that some sort of threading or likewise process is happening in the background.
I'm not sure if that is actually the case, but functions didn't feel like they were always running in the intended order.
Those comparisons are there to waste CPU cycles and protect the unstable code from crashing on even the smallest inconsitencies.
*/

//Usually I'm not a fan of global variables, but had to use a few.
//Map MapCopy is here to allow all classes to access the map. Because this is an editor, it makes a lot of sense for the map to be global
//The reason it's called MapCopy is due to the process of which it is created. From a copy of tb.m
static Map mapCopy;
//tileMapRect is a global rect used for determening the size of the tiles on screen. It's not used enough to justify making it a global(static) varaible. But it will do.
static Rect tileMapRect;

class Editor extends ObjBase
{
  //Declaring of related variables and objects.
  boolean requestReload = true;
  TextBox tb;
  TileMapButton tmBtn;
  SaveButton sBtn;
  DrawModeToggleButton dmBtn;
  TextRotField rotByteField;
  TextSpriteField spriteByteField;
  boolean drawModeTileSelected = false;
  int drawModeTile;
  Editor()
  {
    
    //Initing the base object
    super(new Rect(width/2,height/2,width,height));
    
    //Initing the rest of the objects
    drawModeTile = 0;
    tmBtn = new TileMapButton(new Rect(100,height-50,100,50));
    dmBtn = new DrawModeToggleButton(new Rect(205,height-50,120,50));
    sBtn = new SaveButton(new Rect(0,height-50,100,50));
    dmBtn.btnTxt = "Toggle Draw";
    sBtn.btnTxt = "Save Map";
    tmBtn.btnTxt = "To TileMap";
    dmBtn.btnTxtFntSize = 15;
    tmBtn.btnTxtFntSize = 15;
    sBtn.btnTxtFntSize = 15;
    //Initilizaion of decared variables, and some of the gloal ones.
    tileMapRect = new Rect(0,0,16,16);
    Rect tbR = new Rect(rect.x+10,rect.y,rect.w/2-20,rect.h/10);
    //Create a new "textbox" and place it at the coordinates specified by tbR. Read more about Rects in "coreClasses.pde" and about TextBoxes in "load.pde"
    tb = new TextBox(tbR);
    //Telling the textbox that for some reason also controls the map loader, that we want 16x16 sized tiles.
    tb.mapRect = tileMapRect;
    //Creating two new textfields, each with their own purpose. To set varaibles of the many tiles. Read more about TextFields in "textField.pde" file.
    rotByteField = new TextRotField(new Rect(rect.x+10,rect.y-(1*(rect.h/10)),rect.w/2-20,rect.h/10));
    spriteByteField = new TextSpriteField(new Rect(rect.x+10,rect.y-(2*(rect.h/10)),rect.w/2-20,rect.h/10));
    enabled = true;
    
  }
  //Draw function - Will be run on each frame.
  void Draw()
  {
    if(enabled)
    {
      
      //Pushing to make sure that we don't keep setting we don't want to affect every object and function.
      background(0);
      dmBtn.Draw();
      //Drawing the textbox
      tb.Draw();
      sBtn.Draw();
      //Draw the TileMap Button
      tmBtn.Draw();
      
      //Checking if the textbox has a selected tile - if not it would crash, so this is to prevent that
      if(tb.selectedTile != null)
      {
        //Drawing the textfields
        rotByteField.Draw();
        spriteByteField.Draw();
      
        //Creating the rect, that translates to a block in the upper right corner - This is the "zoomed" view of the selected tile
        tb.selectedTile.rect = new Rect(width-64,0,64,64);
      
        //Draw it.
        tb.selectedTile.Draw();
      
        //Drawing the text - Using push() and pop() again as explained earlier
        push();
      
        //Setting the needed variables for drawing the text we want (this includes setting the color to white)
        textSize(16);
        fill(255);
        text("Tile: " + tb.selectedTile.x + ", " + tb.selectedTile.y,width-100,100);
        text("Sprite: " + ToHex(tb.selectedTile.spriteByte) + ", " + ToHex(tb.selectedTile.rotationByte),width-200,150);
        pop();
      
      }
    
      //Check to see if the mapCopy has been created yet, if not - we just ignore it.
      if(mapCopy != null)
      {
          tb.m = mapCopy; //<<--- This command is stupid and will be removed later, as it just wastes ram.
         //background(0);
         
         //Drawing the map
         mapCopy.Draw();
      }
    }
  }
  
  //Update will run every frame - right before Draw
  void Update()
  {
  if(enabled)
  {
      //Update related classes
      
      tb.Update();
      tmBtn.Update();
      sBtn.Update();
      rotByteField.Update();
      spriteByteField.Update();
      
      if(!dmBtn.toggled)
      {
        drawModeTileSelected = false;
      }
      if(dmBtn.toggled && !drawModeTileSelected)
      {
         sm.SetActiveObj(2); //<>//
      }
      dmBtn.Update();
      
      //Check if we have a selected tile - so we don't crash
      if(tb.selectedTile != null)
      {
        //Updating the fields working tiles with the current selected tile
        rotByteField.workingTile = tb.selectedTile;
        spriteByteField.workingTile = tb.selectedTile;
        //mapCopy.map[spriteByteField.workingTile.x][spriteByteField.workingTile.y] = spriteByteField.workingTile; // <--- To be deleted
        //mapCopy.map[tb.selectedTile.x][tb.selectedTile.y] = tb.selectedTile; // <---- To be deleted
      
        //Check if our textfields are disabled - and if they are we change the text inside them to represent the state of the selected tile
        if(!rotByteField.enabled)
        {
          rotByteField.fieldText = "0x" + rotByteField.workingTile.rotationByte;  
        }
        if(!spriteByteField.enabled)
        {
          spriteByteField.fieldText = "0x" + spriteByteField.workingTile.spriteByte;
        }
      }
    
    }
  }
}

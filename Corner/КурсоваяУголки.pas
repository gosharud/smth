
uses GraphABC;
Const
n=8;
type arr = array [1..n,1..n] of integer;
type pos = array[1..2] of integer;
 var sx, sy, field: arr;
     mover: array[1..2] of integer; 

procedure desk();
var
  i, j, ct1, ct2,width,height: integer;
begin
  width := WindowWidth();
  height := WindowHeight();
  clearwindow(clblue);
  ct1 := 1;
  ct2 := 0;
  DrawRectangle(0, height, width, 0); 
  for i := 1 to 8 do begin
    for j := 1 to 8 do begin
      DrawRectangle(width div 8 * (j - 1), height div 8 * (i - 1), width div 8 * j, height div 8 * i);
    end;
  end;
  for i := 1 to 8 do begin   
    for j := 1 to 8 do begin
      ct1 += 1;    
      if (ct1 mod 2 = 1)  then 
      Rectangle(width div 8 * (j - 1), height div 8 * (i - 1), width div 8 * j, height div 8 * i)
    end;
    ct1 +=1; 
  end;
  
end;
procedure shashk(var field: arr);
var
  a, b, i, j, ct, ct2,width,height: integer;

begin
  SetWindowCaption('Уголки');
  desk();
  width := WindowWidth();
  height := WindowHeight();
  a := width div 8; 
  b := height div 8;
  for i := 1 to 8 do begin
    for j := 1 to 8 do begin
      if field[i][j]=1  then begin    
        DrawCircle(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, (a * (j) - a * (j - 1)) div 4);     
        FloodFill(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, clBlack);   
      end;
      if (field[i][j]=-1) or (field[i][j]=-2) then begin 
        DrawCircle(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, (a * (j) - a * (j - 1)) div 4);
        FloodFill(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, clYellow);  
      end;
      if field[i][j]=2  then begin
        DrawCircle(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, (a * (j) - a * (j - 1)) div 4);
        FloodFill(a * (j - 1) + (a * (j) - a * (j - 1)) div 2, b * (i - 1) + (b * (i) - b * (i - 1)) div 2, clRed);
      end;
  end;
 end;
end;
procedure Win(field:arr);
var s1,s2,i,j:integer;
begin
  for i:=1 to 3 do 
    for j:=1 to 3 do begin
      if field[i][j] = 2 then s2+=2;
      if field[8-i+1][8-j+1] = 1 then s1+=1
    end;
    if s2=18 then  begin clearwindow(clwhite); TextOut(ScreenWidth div 2,ScreenHeight div 2, 'Победил игрок с красными шашками');
      SetWindowCaption('Победитель: Игрок с красными шашками'); Redraw(); sleep(3500);  CloseWindow()    end;
    if s1=9  then begin clearwindow(clwhite); TextOut(ScreenWidth div 2,ScreenHeight div 2, 'Победил игрок с чёрными шашками');
        SetWindowCaption('Победитель: Игрок с чёрными шашками'); Redraw(); sleep(3500); CloseWindow()   end;
    
end;
procedure move(var field: arr; x,y:integer);
 var i,j,size,ctr,cty:integer;
     xy,gr:pos;
begin
  
  size:=100000000;
  gr[1]:=0; gr[2]:=0;
  for i:=1 to 8 do
    for j:=1 to 8 do begin
      if size > (abs(sx[i][j] - x ) + abs(sy[i][j] - y )) then begin 
        size:=(abs(sx[i][j] - x ) + abs(sy[i][j] - y )); 
        xy[1]:=i; 
        xy[2]:=j; 
      end;
      if (field[i][j] = -1) or (field[i][j] = -2) then begin 
        gr[1]:=i; 
        gr[2]:=j 
      end;
    end;
   if (abs(gr[1] - xy[1]) = 1) and (abs(gr[2] - xy[2]) = 0) then 
    if ((field[gr[1]][gr[2]] = -1 ) or (field[gr[1]][gr[2]] = -2)) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end
    else if (field[gr[1]][gr[2]] =-1) and( gr[1] < xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0;
    end
    else if (field[gr[1]][gr[2]] =-2) and( gr[1] > xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end;
    
   if (abs(gr[1] - xy[1]) = 0) and (abs(gr[2] - xy[2]) = 1) then 
    if ((field[gr[1]][gr[2]] = -1 ) or (field[gr[1]][gr[2]] =-2)) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end
    else if (field[gr[1]][gr[2]] =-1) and( gr[1] < xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0;
    end
    else if (field[gr[1]][gr[2]] =-2) and( gr[1] > xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end;
    
    if (abs(gr[1] - xy[1]) = 0) and (abs(gr[2] - xy[2]) = 2) then 
     if ((field[gr[1]][gr[2]] = -1 ) or (field[gr[1]][gr[2]] =-2)) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end
    else if (field[gr[1]][gr[2]] =-1) and( gr[1] < xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0;
    end
    else if (field[gr[1]][gr[2]] =-2) and( gr[1] > xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
      end;
      
        if (abs(gr[1] - xy[1]) = 2) and (abs(gr[2] - xy[2]) = 0) then 
     if ((field[gr[1]][gr[2]] = -1 ) or (field[gr[1]][gr[2]] =-2)) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
    end
    else if (field[gr[1]][gr[2]] =-1) and( gr[1] < xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0;
    end
    else if (field[gr[1]][gr[2]] =-2) and( gr[1] > xy[1]) then  begin 
      field[xy[1]][xy[2]] := abs(field[gr[1]][gr[2]]);  
      field[gr[1]][gr[2]]:=0; 
      end; 
     
   LockDrawing();
   shashk(field);
   Redraw(); 
end;

procedure change(x,y, button: integer);
var i,j,a,b,size:integer;
    xy:array[1..2] of integer;
begin
  size:=1000000;
  if button = 1 then 
    if ((GetPixel(x,y).A = 255) and (GetPixel(x,y).B = 0) and (GetPixel(x,y).G = 0) and (GetPixel(x,y).R = 255)) or ((GetPixel(x,y).A = 255) and (GetPixel(x,y).R = 0) and (GetPixel(x,y).G = 0) and (GetPixel(x,y).B = 0)) then begin  
      for i:=1 to 8 do
        for j:=1 to 8 do
          if field[i][j] < 0 then field[i][j]:=abs(field[i][j]);
      for i:=1 to 8 do
        for j:=1 to 8 do 
          if size > (abs(sx[i][j] -x ) + abs(sy[i][j] -y )) then begin 
            size:=(abs(sx[i][j] -x) + abs(sy[i][j] -y)); 
            xy[1]:=i; 
            xy[2]:=j;
          end;
    field[xy[1]][xy[2]]*= -1;
    LockDrawing();
    shashk(field);
    Redraw();
  end;
  
  if button = 2 then 
    if ((GetPixel(x,y).A = 255) and (GetPixel(x,y).R = 0) and (GetPixel(x,y).G = 0) and (GetPixel(x,y).B = 255)) or ((GetPixel(x,y).A = 255) and (GetPixel(x,y).R = 255) and (GetPixel(x,y).G = 255) and (GetPixel(x,y).B = 255)) then begin
      for i:=1 to 8 do
        for j:=1 to 8 do 
          if size > (abs(sx[i][j] - x) + abs(sy[i][j] - y)) then begin 
            size:=(abs(sx[i][j] - x) + abs(sy[i][j] - y));
            xy[1]:=i; 
            xy[2]:=j; 
          end;
          if (field[xy[1]][xy[2]] = 0) then 
            move(field,x,y); 
    end;
   Win(field)
    
end;



var
  game: boolean;
  width, height,i,j,ct,a,b: integer;


begin
  width := WindowWidth();
  height := WindowHeight();
  ct := 0;
  a := width div 8; 
  b := height div 8; 
    for i := 1 to 8 do
    begin
      for j := 1 to 8 do
      begin
        ct += 1;
        sx[i][j]:=a * (j - 1) + (a * (j) - a * (j - 1)) div 2;
        sy[i][j]:= b * (i - 1) + (b * (i) - b * (i - 1)) div 2;
       if (ct <= 24) and ((ct mod 8 = 1) or (ct mod 8 = 2) or (ct mod 8 = 3)) then field[i][j]:= 1 ; 
        if (ct >= 41) and ((ct mod 8 = 6) or (ct mod 8 = 7) or (ct mod 8 = 0)) then field[i][j]:=2;
      end;
    end;
    
  SetWindowSize(width, height);
  mover[random(2)+1]:=1;
  SetWindowIsFixedSize(True);
  LockDrawing();
  desk();
  shashk(field);
  redraw();
   if mover[1]= 0 then   
    SetWindowCaption('Первый ход делает игрок с красными шашками')
  else  
    SetWindowCaption('Первый ход делает игрок с чёрными шашками');
  OnMouseDown := change
end.
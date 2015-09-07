unit unit_colors;

interface

const
  COL_Red     = $FF0000;
  COL_Lime    = $00FF00;
  COL_Blue    = $0000FF;
  COL_Yellow  = $FFFF00;
  COL_Aqua    = $00FFFF;
  COL_Fuchsia = $FF00FF;

  COL_Green   = $008000;

  COL_Black   = $000000;
  COL_White   = $FFFFFF;

  COL_Maroon  = $800000;
  COL_Olive   = $808000;
  COL_Navy    = $000080;
  COL_Purple  = $800080;
  COL_Teal    = $008080;
  COL_Gray    = $36454F;

  COL_DkRed   = $800000; // COL_Maroon
  COL_DkGreen = $004000;
  COL_DkBlue  = $000080; // COL_Navy

  COL_Silver  = $C0C0C0;
  COL_LtGray  = $C0C0C0; // COL_Silver
  COL_DkGray  = $808080; // COL_Gray

  COL_Orange = $FF8000;
  COL_Pink   = $FF0080;
  COL_Violet = $8000FF;
  COL_LtBlue = $0080FF;
  COL_SpringGreen  = $00FF80;
  COL_YellowGreen  = $80FF00;

  COL_LtBrown = $A05000;
  COL_Brown   = $804000;
  COL_DkBrown = $502800;

  { RGB }
  COL_R   = 255<<16;
  COL_G   = 255<<8;
  COL_B   = 255;

  { CMY }
  COL_C = COL_G + COL_B;
  COL_M = COL_R + COL_B;
  COL_Y = COL_R + COL_G;
  COL_K = COL_Black;

function MakeColor(r,g,b:byte):integer;
function GetRed(color:integer):byte;
function GetGreen(color:integer):byte;
function GetBlue(color:integer):byte;

implementation

function  MakeColor(r,g,b:byte):integer;
begin
  result := r<<16 + g<<8 + b;
end;

function GetRed(color:integer):byte;
begin
  result := color>>16;
end;

function GetGreen(color:integer):byte;
begin
  result := (color>>8) mod 256;
end;

function GetBlue(color:integer):byte;
begin
  result := (color mod 256);
end;


end.



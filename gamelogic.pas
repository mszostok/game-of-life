unit GameLogic;

{$mode objfpc}{$H+}

interface

uses
  Crt,Classes, SysUtils, MyType, Lists;


procedure createNextGeneration(game :PTGame);
procedure NextGeneration(LRunGames : TLRunGames; FPS: integer);
procedure initGames(var Game: TLGames);
procedure Pause(var LGames : TLGames; actual: PTGame);

implementation

{procedura inicjuje liste gier poczatkowymi
wartosciami }
procedure initGames(var Game: TLGames);
var
  LRunGames: TLRunGames;
begin
  with Game do begin
  count:=0;
  head:=NIL;
  tail:=NIL;
  sizeX:=0;
  sizeY:=0;
  config:='';
  LRunGames.head:=NIL;
  LRunGames.count:=0;
  end;
end;

{ Funkcja countNeighbours zwraca liczbę żywych sąsiadów konkretnej komórki
  w wywołaniu podajemy wspolrzedne komorki(x,y)  oraz wskaznik na liste generacji
  dla ktorej chcemy uzyskac ich liczbe}
function countNeighbours(x,y:integer; TLGen: PTLGen):integer;
var
  i,j,numbers: integer;
  prevGeneration: TGenArray;
begin
  prevGeneration:=TLGen^.head^.next^.GenArray;
  numbers:=0; //wyzerowanie liczby sasiadow
  //sprawdzenie wszystkich komorek dookola podanej komorki(x,y)
  for i:= (x-1) to (x+1) do
      if not( (i<1) or (i>TLGen^.Height-1) ) then // sprawdzanie czy znienna 'i' nie wychodzi po za zakres
                                     //tablicy( liczbe wierszy )
        for j:=(y-1) to (y+1) do
            begin
            if not ( ((j<1) or (j>TLGen^.Width-1)) or ((i=x) and (j=y))) then // sprawdzenie czy nie wychodzimy
            //poza zakres (liczba kolumn) oraz czy nie jestesmy w komorce(x,y) jesli nie to wykonujemy nastepne polecenie
              if  prevGeneration[i,j] then inc(numbers); // jesli sasiad jest zywy to zwiekszamy zmienna o 1
            end;
  countNeighbours:=numbers; //zwrocenie ilosci sasiadow
end;


{ Funkcja sprawdza czy dana komorka bedzie zywa czy tez martwa w następnym pokoleniu.
W wywołaniu podajemy wspołrzedne komorki (x,y) oraz wskaznik na liste generacji w ktorej
ma nastapic przejscie.
Zwroci wartosc true jesli komorka ma byc zywa lub false jesli ma byc martwa}
function transition(x,y:integer; TLGen: PTLGen): Boolean;
var
  number:integer;
  prevGeneration: TGenArray;
begin
prevGeneration:=TLGen^.head^.next^.GenArray;
  number:=countNeighbours(x,y, TLGen); //przypisanie do zmiennej number ilosc sasiadow komorki (x,y)
   if ( ( number = 3 ) or (prevGeneration[x,y] and (number = 2)) ) then //jesli komorka ma trzech sasiadow
    //to w kolejnym pokoleniu jest zywa, a jesli ma dwoch i w aktualnym pokoleniu jest zywa to  w nastepnym tez bedzie
      transition:= true
    else //wszystkie innie komorki sa w nastepny pokoleniu martwe
      transition:= false;
end;


{ Procedura odpowiedzialna jest za tworzenie nastepnej populacji.
Wywolaniu podajemy wskaznik na rekord gry, a listy
LGen zostanie przypisane nastepne pokolenie}
procedure createNextGeneration(game : PTGame);
var
  i,j:integer;
  generation,prevGeneration: PTGen;
begin
  addGeneration(game);

  generation:=game^.TLGen^.head;
  prevGeneration:=game^.TLGen^.head^.next;

for i:=1 to game^.TLGen^.Height-1 do
 for j:=1 to game^.TLGen^.Width-1 do
   generation^.GenArray[i,j] := transition(i,j,game^.TLGen);
inc(game^.TLGen^.count);
end;

{ Procedura dla kazdej uruchomionej gry tworzy
pokolenie w okreslonym odstepie czasu okreslonym
dla kazdej gry z osobna.
W Wywolaniu podajemy liste gier uruchomionych
i aktualny FPS}
procedure NextGeneration(LRunGames : TLRunGames; FPS: integer);
var
  p: PTRunGame;
begin
p:=LRunGames.head;

 while p<> nil do begin
  p^.game^.fpsPoint:=p^.game^.fpsPoint + (1000 div FPS);
  while p^.game^.fpsPoint >= (1000 div p^.game^.fps) do begin
   createNextGeneration(p^.game);
   p^.game^.fpsPoint:=p^.game^.fpsPoint-(1000 div p^.game^.fps);
  end;
  p:=p^.next;
 end;
end;


{ Procedura zatrzymuje gre jesli trwa lub uruchamia
jesli jest zatrzymana. W wywolaniu podajemy liste gier
oraz wskaznik na gre ktora chcemy uruchomic}
procedure Pause(var LGames : TLGames; actual: PTGame);
begin
  actual^.pause:=not(actual^.pause);
  if not(actual^.pause) then
  addRunGame(LGames.LRunGames,actual)
  else removeRunGame(LGames.LRunGames,actual);

end;
end.


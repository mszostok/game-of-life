unit Lists;

{$mode objfpc}{$H+}

interface

uses
  Crt,Classes, SysUtils, MyType, iface;

function initFirstGeneration( newGame: PTGame; pattern:string):integer;
procedure addGame(var LGames : TLGames; pattern :string;FPS:integer);
procedure addGeneration( game: PTGame);
procedure removeRunGame(var LRunGames: TLRunGames; actual : PTGame);
procedure addRunGame(var LRunGames: TLRunGames; actual :PTGame);

implementation

{Procedura dodaj do listy uruchomionych gier wznowiona gre.
Wywolaniu podajemy liste gier, oraz gre ktora zostala wznowiona}
procedure addRunGame(var LRunGames: TLRunGames; actual :PTGame);
var
  runGame : PTRunGame;
begin
  new(runGame);
  runGame^.game:=actual;
  runGame^.next:=LRunGames.head;
  LRunGames.head:=runGame;
  inc(LRunGames.count);
end;

{Procedura usuwa zatrzymana gre z listy uruchomionych gier
Wywolaniu podajemy liste gier, oraz gre ktora zostala zatrzymana}
procedure removeRunGame(var LRunGames: TLRunGames; actual : PTGame);
var
  p,e: PTRunGame;
begin
   p:=LRunGames.head;
   if actual = p^.game then begin
   LRunGames.head:=LRunGames.head^.next;
   dispose(p);
   end
   else begin
    while p^.next^.game <> actual do p := p^.next;
    e:=p^.next;      //wazne by zapamietac element ktory trzeba zwolnic !!!
    p^.next := p^.next^.next;
    dispose(e);
   end;
   dec(LRunGames.count);
end;

{ Funkcja dodaje do listy generacji danej gry pierwsze pokolenie
zwraca:
0 - jesli wszystko udal sie odczyt pokolenia
1 - jesli wystapil blad
Wywolaniu podajemy wskaznik na gre oraz sciezke do pliku z pierwszym pokoleniem }
function initFirstGeneration( newGame: PTGame; pattern:string):integer;
var
  generation: PTGen;
begin
  new(generation);
  generation^.next:=NIL;
  generation^.prev:=NIL;

  newGame^.TLGen^.head:=generation;

  if loadGeneration(newGame^.TLGen,pattern)  then begin
     newGame^.TLGen^.head:=NIL;
     dispose(generation);
  end
  else begin
     newGame^.TLGen^.tail:=generation;
     newGame^.TLGen^.count:=1; // pierwsze pokolenie
     initFirstGeneration:=0;
  end;

end;
//////end addFirstGeneration();

{Procedura usuwa wybrany element z listy
lecz nie dekrementuje licznika listy
ze wzgledu na dalsza logike gry}
procedure RemoveGen(TLGen : PTLGen; e : PTGen);
begin
  if e^.prev <> nil then e^.prev^.next := e^.next
  else TLGen^.head := e^.next;
  if e^.next <> nil then e^.next^.prev := e^.prev
  else TLGen^.tail := e^.prev;
  dispose(e);
end;

{Procedura pobiera wskaźnik na gre i dodaje do jej listy
nastepne pokolenie (pusta tablice), jesli liczba pokolen
jest wieszka od 100 wtedy usuwa ostatni element }
procedure addGeneration( game: PTGame);
var
  generation: PTGen;
begin
  if game^.TLGen^.count > 100 then begin
    removeGen(game^.TlGen,game^.TLGen^.tail);  //usuwa ostatni element z listy
  end;
  new(generation);
  SetLength(generation^.GenArray, (game^.TLGen^.Width+1), (game^.TLGen^.Height+1) );
  generation^.prev:=NIL;
  generation^.next:=game^.TLGen^.head;
  game^.TLGen^.head:=generation;
  generation^.next^.prev := generation;
end;
//////end addGeneration();

{Procedura dodajaca nowa gre do listy gier
Wywolaniu podajemy liste gry, sciezke do pliku z pierwszym pokoleniem
oraz FPS dla danej gry}
procedure addGame(var LGames : TLGames; pattern :string; FPS:integer);
var
  newGame: PTGame;
  TLGen: PTLGen;
  error:integer;
begin
  new(newGame); //dodanie nowej gry
  new(TLGen);    // dodanie listy pokoleni
  TLGen^.head:=NIL; //inicjalizacja
  TLGen^.tail:=NIL;
  TLGen^.count:=0;

  newGame^.TLGen:=TLGen; //przypisanie listy do aktualnej gry
  ///dodanie pierwszego pokolenia
  error:=initFirstGeneration(newGame, pattern);
  if error <> 0  then
  begin
    newGame^.TLGen:=Nil;
    dispose(TLGen);
    dispose(newGame);
    showErr(LGames, error);
  end
  else
  newGame^.pattern:=pattern;
  newGame^.fps:=FPS;
  newGame^.fpsPoint:=0;
  newGame^.pause:=true;
  newGame^.next := nil;
  newGame^.prev := LGames.tail;
  LGames.tail:= newGame;
  inc(LGames.count);
  if newGame^.prev <> nil then newGame^.prev^.next := newGame
  else LGames.head := newGame;
end;
/////end addGame();

end.


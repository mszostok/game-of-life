unit Iface;

{$mode objfpc}{$H+}

interface

uses
  Crt,Classes, SysUtils, MyType, unit_sdl,unit_colors;


procedure showGame(LGames: TLGames; Game: PTGame); //pokazuje pierwsze pokoleni gry
procedure refreshGame(LGames: TLGames; Game: PTGame); //odswieza stan pokolenia na ekranie
function loadGeneration(TLGen : PTLGen; path:string): boolean;
procedure showErr(LGames : TLGames; err: word);
procedure patternStan(name:string; Exists: boolean);
procedure menuGUI(LGames:TLGames; actual :PTGame);
procedure infogeneration(actual: PTGame);  //Wyswietla ilosc aktualnych pokolen

implementation
{ Procedura wyswietla sciezki zaladowanych plansz
oraz liczbe uruchomionych gier.
Wywolaniu podajemy liste gier oraz aktualnie wyswietlna gre}
procedure menuGUI(LGames:TLGames; actual :PTGame);
var
  p: PTGame;
  p2: PTRunGame;
  y0,color:integer;
begin
  p:=LGames.head;
  y0:=10;
  while p <> nil do begin
    if p=actual then color:=COL_Lime
    else color:=Col_White;
    draw_text(p^.pattern,LGames.sizeX-250,y0, color);
    p:=p^.next;
    y0:=y0+20;
  end;
  draw_text('Uruchomionych: ' + IntToStr(LGames.LRunGames.count),LGames.sizeX-180, y0, Col_White);
  draw_Refresh()
end;


{Procedura wyswietla w konsoli  stan podanych sciezek
w pliku *.ini. W Wywoalniu podajemy sciezke planszy oraz
to czy zostala zaladowana}
procedure patternStan(name:string; exists: boolean);
begin
if not(exists) then
name:=name+' nie';
writeln('Plik ', name, ' zostal zaladowany');
end;


{Procedura wyswietla kod bledu w konsoli oraz po 3s
konczy dzialanie programu zamykajac go z podanym kodem bledu}
procedure showErr(LGames: TLGames; err: word);
begin
  write(LGames.ErrArray[err]);
  delay(3000);
  Halt(err);
end;


{ Funkcja wypełnia tablice GenArray danym z podanego pliku.
 Zwraca wartość true, gdy wystąpił błąd lub false jeśli wszystko zakończyło
 się pomyślnie. W wywołaniu podajemy wskaznik na liste generacji
 oraz sciezke z ktorej ma zostac zaladowane pierwsze pokolenie}
function loadGeneration(TLGen : PTLGen;path:string): boolean;
var
  map: TextFile; //uchwyt pliku
  i,j,x,xMax,yMax:integer; // zmienne wykorzystywane w petlach krokowych
  buff: string; // wczytuje tylko tyle znakow ile w tablicy jest kolumn od 1 do COL
  error:boolean;
  GenArray : TGenArray;
begin
  xMax:=0;
  yMax:=0;

  if FileExists(path) then begin //prowadzimy operacje na pliku tylko jesli
                               //istnieje i mamy do niego dostep
    AssignFile(map, path);
    Reset(map); // otwieranie pliku w trybie do odczytu
    Readln(map, buff);

    while not eof(map) do {dopoki nie koniec pliku, wtedy odczytaj x,y}
    begin
      readLN(map,buff);
      if Length(buff)> xMax then xMax:=Length(buff);
      inc(yMax);
    end;

    TLGen^.Height:=yMax;
    TLGen^.Width:=xMax;

    SetLength(GenArray, xMax, yMax);

    CloseFile(map);
    Reset(map);

    for i:=1 to yMax do begin
        Readln(map, buff);
        for j:=1 to xMax do begin
          if buff[j] = 'x' then
            GenArray[i,j] := true
          else
            GenArray[i,j] := false;
        end;
    end;
    CloseFile(map); // zamkniecie pliku
    error:=false; //zakonczenie bez bledu
  end
  else begin
    writeln('Brak dostępu do pliku lub plik nie istnieje !');
    error:=true; //zwrocenie bledu
  end;
  TLGen^.head^.GenArray:= GenArray;
 loadGeneration:=error;
end;


{ Procedura przerysowywuje cala plansze z akutalnym
pokoleniem. Wywolaniu podajemy liste gier oraz wskaznik na gre do wyswietlenia}
procedure showGame(LGames: TLGames; Game: PTGame);
var
  i,j,k:integer;
  generation: TGenArray;
  offsetX,offsetY: integer;
begin
k:=10;
  draw_PutPoint((LGames.sizeX div 2),(LGames.sizeY div 2), 2000, $36454F);
  infogeneration(game);
  offsetX:=(LGames.sizeX div 2) - ((game^.TLGen^.Width*k) div 2);
  offsetY:=(LGames.sizeY div 2) - ((game^.TLGen^.Height*k) div 2);
  Generation:=Game^.TLGen^.head^.GenArray;
  for i:=1 to game^.TLGen^.Height-1 do begin
    for j:=1 to game^.TLGen^.Width-1 do begin
    if Generation[i,j] then draw_PutPoint(((j*k)+offsetX),(i*k)+offsetY,k-1, COL_White)
    end;
  end;
 draw_Refresh()
end;

{Funkcja odpowiedzialna za pobranie
od uzytkownika informacje na temat
ilosc wyswietlanych klatek na sekunde
zwraca ich ilosc}
function userFPS():word;
  var
      frame: word;
begin
  clrscr;
  repeat
  write('Podaj ilosc klatek na sekunde: ');
  {$i-} //Wylaczenie oslugi bledow dyskowych
  readln(frame);
  if (IOResult<>0) or (frame=0) then begin //jesli wystapil jakis blad
  writeln('Blad danych!');  // powiadom uzytkownika
  continue; //i wykonaj petle jeszcze raz
  end;
  {$i+} //wlaczenie obslugi bledow dyskowych
  until (frame<>0);
  userFPS:=frame;
end;


{Procedura odswieza tylko te miejsa na ekranie
w ktorych zaszly jakies zmiany
Wywolaniu podajemy liste gier oraz wskaznik na gre do wyswietlenia}
procedure refreshGame(LGames: TLGames;game: PTGame);
var
  i,j,k:integer;
  prevGeneration,generation: PTGen;
  offsetX,offsetY: integer;
begin
  k:=10;
  infoGeneration(game);
  offsetX:=(LGames.sizeX div 2) - ((game^.TLGen^.Width*k) div 2); //wysrodkowanie planszy X
  offsetY:=(LGames.sizeY div 2) - ((game^.TLGen^.Height*k) div 2); //wysrodkowanie planszy Y
  generation:=game^.TLGen^.head;
  prevGeneration:=game^.TLGen^.head^.next;
  for i:=1 to game^.TLGen^.Height-1 do begin
    for j:=1 to game^.TLGen^.Width-1 do
    //sprawdzenie czy wartosci w komorkach generacji wczesniejszej i akutalnej sa rozne jesli tak
    //to uaktualnia stan komorki
      if not(Generation^.GenArray[i,j] = prevGeneration^.GenArray[i,j]) then
        if Generation^.GenArray[i,j] then begin //jesli komorka aktualnej generacji jest zywa
            draw_PutPoint((j*k)+offsetX,(i*k)+offsetY,k-1, COL_White);                   //to przechodzi w miejsce x,y  i+1?
          end
          else begin // wprzeciwnym wypadku
            draw_PutPoint((j*k)+offsetX,(i*k)+offsetY,k-1, COL_Gray); ;
          end;
  end;
  draw_Refresh()
end;

{ Procedura wyswietla nr aktualnego pokolenia
Wywolaniu podajemy wskaznik na gre}
procedure infoGeneration(  actual: PTGame);
var
  i:integer;
begin
  for i:=0 to 5 do
draw_PutPoint(125+(i*10), 8, 10, COL_Gray);
draw_text('Pokolenie nr: ' + IntToStr(actual^.TLGen^.count), 2, 2, COL_White);
end;
end.


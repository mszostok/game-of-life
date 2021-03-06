unit getFile;

{$mode objfpc}{$H+}

interface

uses
  Crt,Classes, SysUtils, MyType,Lists,iface;

function getConfig(var LGames: TLGames;path:string):word;
procedure getErrArray(var LGames :TLGames; path:string);

implementation

{ Funkcja odczytuje dane z pliku .ini
i zapisuje je do listy gier. Zwraca nastepujace
wartosci typu word:
 0 – jesli zakonczyła sie pomyslnie
 1 – jesli plik nie istnieje lub nie ma do niego dostepu

Wywolaniu podajemy liste gier oraz
sciezke dostepu do pliku
}
function getConfig(var LGames: TLGames;path:string):word;
var
  f : TextFile;
  buff:string[1];
  name,FPS:string;
begin
    if FileExists(path) then begin
    AssignFile(f,path);
    Reset(f);
    while not eof(f) do
    begin
    Read(f, buff);
    if ((buff <> '=' ) and (buff <> ''))then  name:=name+buff
    else
     case LowerCase(name) of
       'setx' : begin
              readln(f,name);
              Delete(name, Length(name), 1);
              LGames.sizeX:=StrToInt(name);
              name:='';
              end;
       'sety' : begin
              readln(f,name);
              Delete(name, Length(name), 1);
              LGames.sizeY:=StrToInt(name);
              name:='';
              end;
       'setpatterns' : begin
              readln(f,name);
              read(f, buff);
              name:='';
              while buff <> ';' do
              begin
              //nazwa wzorca
                while buff <> ':' do
                  begin
                   name:=name+buff;
                   read(f,buff);
                  end;
              //ilosc klatek dla wzorca
                  readln(f,FPS);
               //jesli wzorzec istnieje to gra zostanie dodana
               if FileExists(name) then  addGame(LGames, name, StrToInt(FPS));
                patternStan(name,FileExists(name));
               //odczytanie pierwszego znaku nastepnej lini
               read(f, buff);
               name:='';
              end;
              readln(f,buff);
             end;

     end;
    Result:=0;
    end;
     CloseFile(f);
    end
    else Result:=1;
end;


{Procedura odczytuje dane z pliku .dat i zapisuje je
do tablicy ErrArray w podanej liscie gier.
Jesli plik nie istnieje wyswietli powiadomienie
i zakonczy dzialanie programu.
W wywolaniu podajemy liste gier oraz sciezke dostepu
do pliku
}
procedure getErrArray(var LGames :TLGames; path:string);
var
    f : TextFile;
    buff1: string[1];
    ErrCode,ErrName: string;
    max:integer;
begin
    max:=0;
    if FileExists(path) then begin
      AssignFile(f,path);
      Reset(f);
      while not eof(f) do begin
       readln(f,buff1);
       inc(max);
      end;

      SetLength(LGames.ErrArray, max+1);
      Reset(f);
      while not eof(f) do begin
       read(f,buff1);
       if (buff1 <> ';' )then
          ErrCode:=ErrCode+buff1
       else begin
          readln(f,ErrName);
          LGames.ErrArray[StrToInt(ErrCode)]:=ErrName;
          ErrCode:='';
       end;
      end;
      CloseFile(f);
    end
    else begin
    writeln('Error 00');
    write('Zakonczenie programu po nacisnieciu dowolnego klawisza..');
    repeat
    until KeyPressed;
    Halt(1);
    end;
end;
end.


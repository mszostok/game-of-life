unit appMode;

{$mode objfpc}{$H+}

interface

uses
  Crt,Classes, SysUtils,getFile,MyType,iface;

procedure normalGameMode(var LGames: TLGames);
procedure batchMode(var LGames: TLGames);

implementation
{Procedura pobiera liste gier
i przypisuje do niej plik 'config.ini'
jesli operacja sie nie powiedzie
wyswietli kod blad i zakonczy dzialanie programu
}
procedure normalGameMode(var LGames: TLGames);
var
   err:word;
begin
 LGames.config:='Data\config.ini';
 err:=getConfig(LGames,LGames.config);
 if err <> 0 then showErr(LGames,err);

end;

{ Funkcja przypisuje  wartosci parametrow uruchomieniowych
jakie podal uzytkownik.Funkcja zwraca nastepujace wartosci
typu integer:
 0 – jesli zakonczyła sie pomyslnie
 2 – jesli uzytkownik uzyl blednej flagi
W wywolaniu podaje liste gier do ktorej maja zostac
przypisane wartosci
}
function assignParam(var LGames: TLGames):integer;
var
i:integer;
flag:string;
begin
for i := 0 to ((ParamCount div 2)-1) do
begin
  flag:=ParamStr((2*i)+1); //flagi zawsze znajduja sie na nieparzystych miejsach (program.exe -i [wartosc] -p [wartosc] itd.)
  case LowerCase(flag) of
    '-c': LGames.config:=ParamStr((2*i)+2);
    else  begin
    Result:=2; break;
    end;
  end;
Result:=0;
end;
end;

{ Procedura realizuje tryb wsadowy
przypisuje parametry jesli operacja sie
nie powiedzie wyswietli kod bledu zwrocony
przez funkcje assignParam i zakonczy dzialanie programu
}
procedure batchMode(var LGames: TLGames);
var
  err:word;
begin
   err:=assignParam(LGames);
     if err <> 0 then showErr(LGames,err);

   err:=getConfig(LGames,LGames.config);
     if err <> 0 then showErr(LGames,err);
end;

end.


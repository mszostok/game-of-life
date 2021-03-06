program Sym;

uses
  crt, SysUtils, MyType, GameLogic, Lists, unit_const, unit_sdl, unit_colors,
  Iface, getFile, appMode;


var
  LGames:TLGames;
  actual: PTGame;
  exit,menu: boolean;
  e:Event;

BEGIN 
getErrArray(LGames,'data\ErrCode.dat');
initGames(LGames);

cursoroff;
//sprawdzanie parametrow wywoalania programu
if (ParamCount <> 2) and (ParamCount<>0)then begin
    showErr(LGames,2);
end
else if (ParamCount = 0) then begin
  normalGameMode(LGames);
end
else begin
  batchMode(LGames);
end;

{#############################################################}

actual:=LGames.head;
exit:=false;
menu:=false;
draw_InitWindow(LGames.sizeX,LGames.sizeY);
{*********************************************************************************}
showGame(LGames,actual);
draw_Refresh();

while not exit do
  begin
    repeat
      e := get_event();
        nextGeneration(LGames.LRunGames, actual^.fps);
        if actual^.TLGen^.head^.next <> nil then
        refreshGame(Lgames,actual)
        else if not(menu) then showGame(Lgames,actual);

        delay(1000 div actual^.fps)
    until (e.typ = KEY_DOWN);

    case e.key of
       SDLK_TAB : begin
                  createNextGeneration(actual);
                  refreshGame(Lgames,actual);
       end;
       SDLK_SPACE : Pause(LGames,actual);
       SDLK_LEFT  : begin
                      if (actual^.prev<> nil) and not(menu) then begin
                      actual:=actual^.prev;
                      showGame(Lgames,actual);
                      end;
       end;
       SDLK_RIGHT : begin
                      if (actual^.next<> nil) and not(menu) then begin
                      actual:=actual^.next;
                      showGame(LGames,actual);
                      end;
       end;
       SDLK_m      : begin
                      menu:=not(menu);
                      if menu then menuGUI(LGames,actual)
                      else showGame(LGames,actual);
       end;
       SDLK_ESCAPE : exit := true;
    end;

  end;

draw_CloseWindow();
end.


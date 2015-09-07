unit MyType;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TGenArray =  array of array of Boolean;
  TErrArray = array of string;
  PTLGen = ^TLGen;
  PTGen = ^TGen;
  PTGame = ^TGame;
  PTRunGame = ^TRunGame;

  TRunGame = record   //uruchomione gry
  game: PTGame;
  next : PTRunGame;
  end;

  TLRunGames = record //lista uruchomionych gier
  head: PTRunGame;
  count: integer;
  end;

  TGen = record     // generacja
    GenArray: TGenArray;
    next: PTGen;
    prev: PTGen;
  end;

  TLGen = record   //lista genracji
  head: PTGen;
  tail: PTGen;
  count: integer;
  Height:integer; //wyskosc plansz
  Width:integer; // szerokosc planszy
  end;

  TGame = record   //gra
  fps: word;
  fpsPoint:word;
  pattern:string;
  pause: boolean;
  TLGen: PTLGen;
  next: PTGame;
  prev: PTGame;
  end;

  TLGames = record  //lista gier
  head: PTGame;
  tail: PTGame;
  LRunGames: TLRunGames;
  count: integer;
  sizeX: integer;
  sizeY: integer;
  config: string;
  ErrArray: TErrArray;
  end;

implementation

end.


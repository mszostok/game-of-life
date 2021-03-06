unit unit_sdl;
interface
uses unit_const;
type

  EventType   = ( NO_EVENT, KEY_DOWN, KEY_UP, MOUSE_MOVE, BTN_DOWN, BTN_UP, FULL_QUEUE );
  EventSource = ( SRC_UNKNOWN, SRC_KEYBOARD, SRC_MOUSE );

  Event = record
	src:EventSource;// all              Event source
	typ:EventType;	// all              Event type
	key:word;	// key              key code (keyboard)
	down:word;	// key/btn
	btn:word;  // btn                   with button (mouse)
	mx:word;   // btn/move              mouse position X
	my:word;   // btn/move              mouse position Y
	dx:word;   // move                  (mouse)
	dy:word;   // move                  (mouse)
  end;


{============================= FUNKCJE i PROCEDURY =============================>>>>    FUNKCJE i PROCEDURY    <<<<}

  procedure draw_InitWindow(w,h:word);                                          cdecl; external 'sdlpas13.dll' name 'draw_init'; {
            Inicjalizacja i wyswietlenie okna graficznego.
            w - szerokosc okna w pikselach
            h - wysokosc okna w pikselach                                      }

  procedure draw_CloseWindow();                                                 cdecl; external 'sdlpas13.dll' name 'draw_close'; {
            Zwolnienie zasobow i zamkniecie okna graficznego.                  }

  procedure draw_Refresh();                                                     cdecl; external 'sdlpas13.dll' name 'draw_refresh'; {
            Odswierzenie obrazu - aktualzuje zawartosc okna, nalezy wywoluwac
            raz (na koncu kazdek klatki animacji) po narysowaiu calej sceny    }

  procedure draw_PutPoint(x, y:word; size: word; color: integer);               cdecl; external 'sdlpas13.dll' name 'draw_point'; {
            Rysowanie kolorowego punktu na ekranie.
             x, y  - pozycja punktu
             size  - rozmiar punktu
             color - kolor punktu                                              }

  procedure draw_PutChar(x, y:word; sign: char; scale: word; c: longword);      cdecl; external 'sdlpas13.dll' name 'draw_char'; {
            Rysowanie kolorowego znaku na ekranie.
             x, y  - pozycja
             sign  - znak (kod znaku w kodowaniu CP852)
             scale - rozmiar podawany jako skala 1 oznacza standardowy rozmiar
                     parametr pozwala powiekszac znak o calkowity mnoznik
             color - kolor                                                     }

  procedure show_info();                                                        cdecl; external 'sdlpas13.dll' name 'show_info'; {
            Procedura wyswietlajaca informacje kontrolne zalezne od wersji dll.}

  function get_qlen(): word;                                                    cdecl; external 'sdlpas13.dll' name 'get_qlen';  {
           Funkcja zwracajaca dlugosc kolejki zdarzen oczekujacych na pobranie
           i obsluzenie. Zdarzenia nalezy odczytywac w miare mozliwosci
           na biezaco aby uniknac przepelnienia kolejki.
           Jesli kolejka zostanie przepelniona pojawia sie zdarzenia FULL_QUEUE
           oznaczajace ze pewne zdarzenia zostaly odrzucone ze wzgledu na brak
           miejsca w kolejce.
           Wartosc zracana: liczba zdarzen w koejce                            }

  function get_event(): Event;                                                  cdecl; external 'sdlpas13.dll' name 'get_event'; {
           Pobranie zdarzenia z kolejki.
           Jesli sa zdarzenia w kolejce zwraca pierwsze z nich.
           Jesli kolejka jest pusta zwraca puste zdarzenie NO_EVENT.           }

  function wait_event(): Event;                                                 cdecl; external 'sdlpas13.dll' name 'wait_event';{
           Pobranie zdarzenia z kolejki z oczekiwaniem.
           Jesli sa zdarzenia w kolejce zwraca pierwsze z nich.
           Jesli kolejka jest czeka na zdarzenie a nastepnie je zwraca.
           Nie zwraca zdarzenia NO_EVENT!                                      }

  function Dec2Hex(val: word): string;                                    {
   Funkcja zwraca podana wartosc val jako string w formacie szesnastkowym }

  procedure draw_text(s:string;x,y,color:integer);                             {
            Wypisanie tekstu na ekranie.
             s     - tekst do wypisania (narysowania)
             x, y  - pozycja
             color - kolor                                                     }



implementation  {====================== IMPLEMENTACJA ==========================>>>>    IMPLEMENTACJA    <<<<}

  function Dec2Hex(val: word): string;
  { Funkcja zwraca podana wartosc val jako string w formacie szesnastkowym }
  const
    HexDigits: string[16] = '0123456789ABCDEF';
  begin
      Dec2Hex := '';
      repeat
          Dec2Hex := HexDigits[val mod 16 + 1] + Dec2Hex;
          val := val div 16;
      until val = 0;
  end;


  procedure draw_text(s:string;x,y,color:integer);
  var i:integer;
  begin
      for i:=0 to Length(s) do draw_PutChar(x+i*8,y,s[i],1,color);
  end;

end.



program TimerTest;

{$APPTYPE CONSOLE}
{$WARN SYMBOL_PLATFORM OFF}

{$R *.res}

uses
  Winapi.Windows,
  System.SysUtils;

const
  C100NsecPerSec = Round(1E+4);
  CPeriod = 80;

var
  Freq, Start, Stop: Int64;
  FreqMSec: Double;
  i: Integer;
  Timer: THandle;
  Period: Int64;
begin
  Win32Check(QueryPerformanceFrequency(Freq));
  FreqMSec := Freq / 1E+3;
  Timer := CreateWaitableTimer(nil, False, nil);
  Win32Check(Timer <> 0);
  try
    Period := - CPeriod * C100NsecPerSec;
    //Win32Check(SetWaitableTimer(Timer, Period, CPeriod, nil, nil, False));
    for i := 0 to 9 do begin
      Win32Check(QueryPerformanceCounter(Start));
      if WaitForSingleObject(Timer, CPeriod) = WAIT_TIMEOUT then begin
        Win32Check(QueryPerformanceCounter(Stop));
        Writeln((Stop - Start) / FreqMSec : 3 : 3);
      end else
        Writeln('Other result');
    end;
  finally
    CloseHandle(Timer);
  end;
  Readln;
end.

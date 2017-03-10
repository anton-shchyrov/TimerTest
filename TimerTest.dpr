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
  EndTime: Double;
begin
  Win32Check(QueryPerformanceFrequency(Freq));
  FreqMSec := Freq / 1E+3;
  Timer := CreateWaitableTimer(nil, False, nil);
  Win32Check(Timer <> 0);
  try
    Period := - CPeriod * C100NsecPerSec;
    for i := 0 to 9 do begin
      Win32Check(QueryPerformanceCounter(Start));
      Win32Check(SetWaitableTimer(Timer, Period, 0, nil, nil, False));
      if WaitForSingleObject(Timer, INFINITE) = WAIT_OBJECT_0 then begin
        EndTime := Start + CPeriod * FreqMSec;
        repeat
          Win32Check(QueryPerformanceCounter(Stop));
        until Stop >= EndTime;
        Writeln((Stop - Start) / FreqMSec : 3 : 3);
      end else
        Writeln('Other result');
    end;
  finally
    CloseHandle(Timer);
  end;
  Readln;
end.

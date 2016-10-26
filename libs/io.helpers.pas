unit io.helpers;

interface

function readValidNumber(min: integer; max: integer): integer;

function readValidAmount(title: string): integer;

function readYesNo(title: string): boolean;

procedure wait(title: string);

procedure waitUser(title: string);

function readOption(title: string; opMin: integer; opMax: integer): shortint;

implementation

function readValidNumber(min: integer; max: integer): integer;
var data: integer;
begin
    repeat
        readLn(data);
    until (min <= data) and (data <= max);
    readValidNumber := data;
end;

function readValidAmount(title: string): integer;
var data: integer;
begin
    repeat
    begin
        write(title);
        readLn(data) ;
    end;
    until (0 < data);
    readValidAmount := data;
end;

function readYesNo(title: string): boolean;
var data: char;
begin
    repeat
    begin
        write(title);
        readln(data);
        data := upcase(data);
    end;
    until (data = 'S') or
          (data = 'N');
    if (data = 'S') then
        readYesNo := true
    else
        readYesNo := false;
end;

procedure wait(title: string);
begin;
  write(title);readln;
end;
{
    Helpers
    funciones especificas a este sistema
}
procedure waitUser(title: string);
begin
  wait(title);
end;

function readOption(title: string; opMin: integer; opMax: integer): shortint;
begin
    write(title);
    readOption := readValidNumber(opMin, opMax);
end;

end.
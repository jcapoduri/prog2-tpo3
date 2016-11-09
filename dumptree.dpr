program dumptree;

{$APPTYPE CONSOLE}

uses
  sysutils,
  StrUtils,
  lib.tree.avl in 'libs\lib.tree.avl.pas',
  io.helpers in 'libs\io.helpers.pas'
{$IFNDEF FPC}
  ,Console in 'libs\Console.pas'
{$ENDIF}
  ;
const
  PATH     = 'data/';
  FILENAME = 'avltree';

var
  tree : tAVLtree;
  idx  : idxRange;
  op   : integer;
  key  : tKey;
  node : tNode;

begin
  Randomize;

  //lib.tree.avl.loadTree(tree, PATH, FILENAME);
  assign(tree.data, PATH + FILENAME + '.dat');
  reset(tree.data);
  idx := 0;

  while not eof(tree.data) do
    begin
      seek(tree.data, idx);
      read(tree.data, node);
      writeln(idx:2, ':', node.key, ':', node.parent:3, ':', node.left:3, ':', node.right:3);
      idx := idx + 1;
    end;
  wait('relala');
end.


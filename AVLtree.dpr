program AVLtree;

{$APPTYPE CONSOLE}

uses
  sysutils,
  lib.tree.avl in 'libs\lib.tree.avl.pas',
  io.helpers   in 'libs\io.helpers.pas';

const
  PATH     = 'data/';
  FILENAME = 'avltree';

var
  tree : tAVLtree;
  idx  : idxRange;
  op   : integer;
  key  : tKey;

procedure dumpTree(var tree : tAVLtree; root : idxRange);
var
  node : tNode;
begin
  if root <> NULLIDX then
    begin
      node := lib.tree.avl.fetch(tree, root);
      write(node.key, ' ->(');
      dumpTree(tree, node.left);
      write(', ');
      dumpTree(tree, node.right);
      write(')');
    end;
end;

function getRandomKey() : tKey;
var
  letter : char;
  number : integer;
begin
  letter := char(Random(25) + 65);
  number := Random(100);
  getRandomKey := concat(letter, IntToStr(number));
end;

begin
  Randomize;

  lib.tree.avl.newEmptyTree(tree, PATH, FILENAME);

  lib.tree.avl.search(tree, 'T12', idx);
  writeln('inserting T12 ', idx);
  lib.tree.avl.insert(tree, idx, 'T12');

  lib.tree.avl.search(tree, 'K12', idx);
  writeln('inserting K12 ', idx);
  lib.tree.avl.insert(tree, idx, 'K12');

  lib.tree.avl.search(tree, 'A12', idx);
  writeln('inserting A12 ', idx);
  lib.tree.avl.insert(tree, idx, 'A12');

  writeln('dump tree:');
  dumpTree(tree, lib.tree.avl.root(tree));
  writeln;

  while true do
    begin
      key := getRandomKey();
      writeln('inserting ', key, '...');
      lib.tree.avl.search(tree, key, idx);
      lib.tree.avl.insert(tree, idx, key);
      writeln('dump tree:');
      dumpTree(tree, lib.tree.avl.root(tree));

      wait('press any key to insert a new value');
    end;

end.

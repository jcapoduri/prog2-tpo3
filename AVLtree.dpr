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

begin
  Randomize;

  lib.tree.avl.newEmptyTree(tree, PATH, FILENAME);

  lib.tree.avl.search(tree, 'A12', idx);
  lib.tree.avl.insert(tree, idx, 'A12');
  lib.tree.avl.search(tree, 'K12', idx);
  lib.tree.avl.insert(tree, idx, 'K12');
  lib.tree.avl.search(tree, 'T12', idx);
  lib.tree.avl.insert(tree, idx, 'T12');

end.

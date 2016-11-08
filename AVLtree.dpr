program AVLtree;

{$APPTYPE CONSOLE}

uses
  sysutils,
  lib.tree.avl in 'libs\lib.tree.avl.pas',
  io.helpers in 'libs\io.helpers.pas';
  //Console in 'libs\console.pas';

const
  PATH     = 'data/';
  FILENAME = 'avltree';

var
  tree : tAVLtree;
  idx  : idxRange;
  op   : integer;
  key  : tKey;

procedure dumpTree(var tree : tAVLtree; root : idxRange; gap : integer; tag : string);
var
  node : tNode;
begin
  if root <> NULLIDX then
    begin
      node := lib.tree.avl.fetch(tree, root);
      write(' ':gap);
      writeln(tag, node.key, ' ->');
      dumpTree(tree, node.left, gap + 1, 'left:');
      dumpTree(tree, node.right, gap + 1, 'right:');
    end;
end;

procedure showTree();
begin
  dumpTree(tree, lib.tree.avl.root(tree), 0, 'root:');
  wait('presione enter para continuar.');
end;

function getRandomKey() : tKey;
var
  letter : char;
  number : integer;
begin
  letter := char(Random(25) + 65);
  number := Random(100);
  getRandomKey := concat(letter, SysUtils.Format('%.*d', [2, number]));
end;

function getKey() : string;
var
  key: string;
begin
  write('ingrese una clave: ');
  readln(key);
  getKey := key;
end;

function menu() : integer;
begin
  //ClrScr;
  writeln('Menu (1-4)');
  writeln('1- Cargar al azar arbol');
  writeln('2- Cargar un nodo al arbol');
  writeln('3- Visualizar arbol');
  writeln('4- Eliminar nodo');
  writeln('0- Salir');
  menu := readValidNumber(0, 4);
end;

procedure loadTree();
var
  amount : Integer;
  idx    : idxRange;
begin
  amount := readValidAmount('Ingrese cantidad de nodos a cargar aleatoriamente: ');
  while amount <> 0 do
    begin
      key := getRandomKey();
      if not lib.tree.avl.search(tree, key, idx) then
        begin
          lib.tree.avl.insert(tree, idx, key);
          amount := amount - 1;
        end;
    end;
end;

procedure loadNode();
var
  key : string;
  idx : idxRange;
begin
  key := getKey();
  lib.tree.avl.search(tree, key, idx);
  lib.tree.avl.insert(tree, idx, key);
end;

procedure eraseNode();
var
  key : string;
  idx : idxRange;
begin
  key := getKey();
  lib.tree.avl.search(tree, key, idx);
  lib.tree.avl.remove(tree, idx);
end;

begin
  Randomize;

  lib.tree.avl.newEmptyTree(tree, PATH, FILENAME);

  op := -1;

  while op <> 0 do
    begin
      op := menu;
      case op of
        1 : loadTree;
        2 : loadNode;
        3 : showTree;
        4 : eraseNode;
      end;
    end;
end.


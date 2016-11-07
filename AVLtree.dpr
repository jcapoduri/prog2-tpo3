program AVLtree;

{$APPTYPE CONSOLE}

uses
  sysutils,
  lib.tree.avl in 'libs\lib.tree.avl.pas',
  io.helpers in 'libs\io.helpers.pas',
  Console in 'libs\console.pas';

const
  PATH     = 'data/';
  FILENAME = 'avltree';

var
  tree       : tAVLtree;
  idx        : idxRange;
  op,i, cant : integer;
  key        : tKey;

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

  Repeat

   Repeat

    writeln('Menu (1-4)');
    writeln('1- Cargar arbol');
    writeln('2- Visualizar arbol');
    writeln('3- Eliminar nodo');
    writeln('4- Salir');
    readln(op);

    if (op<1) or (op>4) then
     begin
      writeln('Error en el ingreso de datos, pulse una tecla para continuar');
      readln;
     end;
   Until (op>=1) and (op<=4);

  Case op of

  1: begin
     write('Cantidad de claves aleatoreas a ingresar: ');
     read(cant);
     For i:=1 to cant do
      begin
        key := getRandomKey();
        lib.tree.avl.search(tree, key, idx);
        lib.tree.avl.insert(tree, idx, key);
      end;
     end;//op 1
  2: begin
       dumpTree(tree, lib.tree.avl.root(tree));
       writeln;
     end;//op 2

  3: begin
      writeln('Ingrese la clave a eliminar');
      readln(key);
      if (lib.tree.avl.search(tree,key,idx)) then
       lib.tree.avl.remove(tree,idx)
      Else
       writeln('Clave ingresada no encontrada');
     end;//op 3

  end;// case


  Until  op = 4;
end.

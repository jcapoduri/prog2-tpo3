unit lib.tree.avl;

interface

uses
  sysutils;

const
  NULLIDX  = -1;

type
  idxRange       = NULLIDX..MAXINT;
  tNode          = record
                     key      : string[3];
                     parent   : idxRange;
                     left     : idxRange;
                     right    : idxRange;
                   end;
  tControlRecord = record
                     root   : idxRange;
                     erased : idxRange;
                   end;
  tControl       = file of tControlRecord;
  tData          = file of tNode;
  tAVLtree       = record
                     data    : tData;
                     control : tControl;
                   end;

  procedure loadTree         (var this : tAVLtree; path, filename : string);
  procedure newEmptyTree     (var this : tAVLtree; path, filename : string);
  function  isEmpty          (var this : tAVLtree) : boolean;
  function  search           (var this : tAVLtree; key : string; pos: idxRange) : boolean;
  procedure insert           (var this : tAVLtree; key : string);
  procedure remove           (var this: tAVLtree; pos: idxRange);


implementation
  { Helpers }
  procedure  _openTree (var this : tAVLtree);
  begin
  end;

  procedure  _closeTree (var this : tAVLtree);
  begin
  end;

  function  _get (var this : tAVLtree; pos : idxRange) : tNode;
  begin
  end;

  procedure _set (var this : tAVLtree; pos : idxRange; node : tNode);
  begin
  end;

  function  _getControl (var this : tAVLtree) : tControlRecord;
  begin
  end;

  procedure _setControl(var this : tAVLtree; RC : tControlRecord);
  begin
  end;

  {Public}
  procedure loadTree         (var this : tAVLtree; path, filename : string);
  begin
  end;

  procedure newEmptyTree     (var this : tAVLtree; path, filename : string);
  begin
  end;

  function  isEmpty          (var this : tAVLtree) : boolean;
  begin
  end;

  function  search           (var this : tAVLtree; key : string; pos: idxRange) : boolean;
  begin
  end;

  procedure insert           (var this : tAVLtree; key : string);
  begin
  end;

  procedure remove           (var this: tAVLtree; pos: idxRange);
  begin
  end;


end.

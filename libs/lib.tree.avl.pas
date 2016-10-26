unit lib.tree.avl;

interface

uses
  sysutils;

const
  NULLIDX  = -1;

type
  idxRange       = NULLIDX..MAXINT;
  tKey           = string[3];
  tNode          = record
                     key      : tKey;
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
  function  search           (var this : tAVLtree; key : tKey; pos: idxRange) : boolean;
  procedure insert           (var this : tAVLtree; key : tKey);
  procedure remove           (var this: tAVLtree; pos: idxRange);


implementation
  { Helpers }
  procedure  _openTree (var this : tAVLtree);
  begin
    reset(this.data);
    reset(this.control);
  end;

  procedure  _closeTree (var this : tAVLtree);
  begin
    close(this.data);
    close(this.control);
  end;

  function  _get (var this : tAVLtree; pos : idxRange) : tNode;
  var
    node : tNode;
  begin
    seek(this.data, pos);
    read(this.data, node);
    _get := node;
  end;

  procedure _set (var this : tAVLtree; pos : idxRange; node : tNode);
  begin
    seek(this.data, pos);
    write(this.data, node);
  end;

  function  _getControl (var this : tAVLtree) : tControlRecord;
  var
    rc : tControlRecord;
  begin
    seek(this.control, 0);
    read(this.control, rc);
    _getControl := rc;
  end;

  procedure _setControl(var this : tAVLtree; RC : tControlRecord);
  begin
    seek(this.control, 0);
    write(this.control, RC);
  end;

  procedure _balanceLeft(var this : tAVLtree; pivot : idxRange);
  begin
  end;

  { key helpers }
  function keyGt(key1, key2 : tKey) : boolean;
  begin
    keyGt := key1 > key2;
  end;

  function keyLt(key1, key2 : tKey) : boolean;
  begin
    keyLt := key1 < key2;
  end;

  function keyEq(key1, key2 : tKey) : boolean;
  begin
    keyEq := key1 = key2;
  end;

  {Public}
  procedure loadTree         (var this : tAVLtree; path, filename : string);
  var
    controlError, dataError : boolean;
    fullFileName : string;
    rc : tControlRecord;
  begin
    fullFileName := path + filename;
    {$I-}
    //check if data file exists
    assign(this.data, fullFileName + '.dat');
    reset(this.data);
    dataError := IOResult = 0;

    assign(this.data, fullFileName + '.dat');
    reset(this.data);
    controlError := IOResult = 0;
    {$I+}

    if (controlError and dataError) then
      begin
        rewrite(this.data);
        rewrite(this.control);
        rc.root := NULLIDX;
        rc.erased := NULLIDX;
        _setControl(this, rc);
      end;

    _closeTree(this);
  end;

  procedure newEmptyTree     (var this : tAVLtree; path, filename : string);
  begin
  end;

  function  isEmpty          (var this : tAVLtree) : boolean;
  var
    empty : boolean;
    rc    : tControlRecord;
  begin
    _openTree(this);
    rc    := _getControl(this);
    empty := rc.root = NULLIDX;
    _closeTree(this);
    isEmpty := empty;
  end;

  function  search           (var this : tAVLtree; key : tKey; pos: idxRange) : boolean;
  var
    found      : boolean;
    curNodeIdx : idxRange;
    curNode    : tNode;
    rc         : tControlRecord;
  begin
    _openTree(this);
    found      := false;
    rc         := _getControl(this);
    curNodeIdx := rc.root;
    pos        := NULLIDX;
    while (curNodeIdx <> NULLIDX) and not found do
      begin
        curNode := _get(this, curNodeIdx);
        if keyEq(curNode.key, key) then
          begin
            found := true;
            pos   := curNodeIdx;
          end
        else
          begin
            pos := curNodeIdx;
            if keyGt(key, curNode.key) then
              curNodeIdx := curNode.right
            else
              curNodeIdx := curNode.left;
          end;
      end;
    _closeTree(this);
    search := found;
  end;

  procedure insert           (var this : tAVLtree; key : tKey);
  begin
  end;

  procedure remove           (var this: tAVLtree; pos: idxRange);
  begin
  end;


end.

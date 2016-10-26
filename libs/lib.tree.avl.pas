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
  procedure insert           (var this : tAVLtree; pos: idxRange; key : tKey);
  procedure remove           (var this: tAVLtree; pos: idxRange);
  function  fetch            (var this : tAVLtree; pos: idxRange) : tNode;
  function  root             (var this : tAVLtree) : idxRange;
  function  leftChild        (var this : tAVLtree; pos: idxRange) : idxRange;
  function  rightChild       (var this : tAVLtree; pos: idxRange) : idxRange;
  function  parent           (var this : tAVLtree; pos: idxRange) : idxRange;



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

  function _max(a, b : integer) : integer;
  begin
    if a > b then
      _max := a
    else
      _max := b;
  end;

  function _height (var this : tAVLtree; branchRoot : idxRange) : integer;
  var
    h    : integer;
    node : tNode;
  begin
    if branchRoot = NULLIDX then
      h := 0
    else
      begin
        node := _get(this, branchRoot);
        h := _max(_height(this, node.right), _height(this, node.left)) + 1;
      end;
    _height := h;
  end;

  function _append (var this : tAVLtree; var item : tNode) : idxRange;
  var
    rc      : tControlRecord;
    pos     : idxRange;
    auxNode : tNode;
  begin
    rc  := _getControl(this);
    pos := NULLIDX;
    if Rc.erased = NULLIDX then
      begin
        pos := filesize(this.data);
        seek(this.data, pos);
        item.right := NULLIDX;
        item.left  := NULLIDX;
        write(this.data, item);
      end
    else
      begin
        pos        := rc.erased;
        auxNode    := _get(this, pos);
        rc.erased  := auxNode.parent;
        item.right := NULLIDX;
        item.left  := NULLIDX;
        _set(this, pos, item);
        _setControl(this, rc);
      end;
    _append := pos;
  end;

  procedure _detach (var this : tAVLtree; pos : idxRange; var node : tNode);
  var
    rc : tControlRecord;
  begin
    rc          := _getControl(this);
    node.right  := NULLIDX;
    node.left   := NULLIDX;
    node.parent := rc.erased;
    rc.erased   := pos;
    _set(this, pos, node);
    _setControl(this, rc);
  end;

  function _isLeaf(var node : tNode) : boolean;
  begin
    _isLeaf := (node.left = NULLIDX) and (node.right = NULLIDX);
  end;

  function _getBiggerFromBranch (var this : tAVLtree; var pivot : idxRange) : tKey;
  var
    node : tNode;
  begin
    node := _get(this, pivot);
    while (node.right <> NULLIDX) do
      begin
        pivot := node.right;
        node  := _get(this, pivot);
      end;
    _getBiggerFromBranch := node.key;
  end;

  function _getSmallerFromBranch (var this : tAVLtree; var pivot : idxRange) : tKey;
  var
    node : tNode;
  begin
    node := _get(this, pivot);
    while (node.left <> NULLIDX) do
      begin
        pivot := node.left;
        node  := _get(this, pivot);
      end;
    _getSmallerFromBranch := node.key;
  end;

  procedure _balanceLeft(var this : tAVLtree; pivot : idxRange);
  begin
  end;

  procedure _balanceRight (var this : tAVLtree; pivot : idxRange);
  begin
  end;

  procedure _balanceIfNeeded (var this : tAVLtree; pivot : idxRange; var node : tNode);
  var
    hLeft, hRight  : integer;
  begin
    hLeft  := _height(this, node.left);
    hRight := _height(this, node.right);
    if abs(hLeft - hRight) > 1 then
      if hLeft > hRight then
        _balanceRight (this, pivot)
      else
        _balanceLeft  (this, pivot);
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

    assign(this.control, fullFileName + '.ctrl');
    reset(this.control);
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
  var
    fullFileName : string;
    rc : tControlRecord;
  begin
    fullFileName := path + filename;
    {$I-}
    assign(this.data, fullFileName + '.dat');
    assign(this.control, fullFileName + '.ctrl');
    rewrite(this.data);
    rewrite(this.control);
    rc.root := NULLIDX;
    rc.erased := NULLIDX;
    _setControl(this, rc);

    _closeTree(this);
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

  procedure insert           (var this : tAVLtree; pos: idxRange; key : tKey);
  var
    node, parent : tNode;
    rc           : tControlRecord;
    auxIdx       : idxRange;
  begin
    _openTree(this);
    rc          := _getControl(this);
    node.key    := key;
    node.parent := pos;
    auxIdx      := _append(this, node);

    if pos = NULLIDX then //empty tree, insert at root
      begin
        rc      := _getControl(this);
        rc.root := pos;
      end
    else
      begin
        parent := _get(this, pos);
        if keyGt(parent.key, key) then
          parent.right := auxIdx
        else
          parent.left  := auxIdx;
        _set(this, pos, parent);
      end;

    _balanceIfNeeded(this, pos, node);

    _setControl(this, rc);
    _closeTree(this);
  end;

  procedure remove           (var this: tAVLtree; pos: idxRange);
  var
    node, parent   : tNode;
    rc             : tControlRecord;
    auxIdx         : idxRange;
    replacementKey : tKey;
  begin
    _openTree(this);
    node        := _get(this, pos);

    if _isLeaf(node) then //easy
      begin
        if node.parent = NULLIDX then // is the root
          begin
            rc      := _getControl(this);
            rc.root := NULLIDX;
            _setControl(this, rc);
          end
        else
          begin
            parent := _get(this, node.parent);
            if parent.right = pos then
              parent.right := NULLIDX
            else
              parent.left  := NULLIDX;
            _set(this, node.parent, parent);
          end;
        _detach(this, pos, node);
      end
    else
      begin
        if node.right = NULLIDX then
          begin
            auxIdx         := node.left;
            replacementKey := _getSmallerFromBranch(this, auxIdx);
          end
        else
          begin
            auxIdx         := node.right;
            replacementKey := _getBiggerFromBranch(this, auxIdx);
          end;
        remove(this, auxIdx);
        node.key := replacementKey;
        _set(this, pos, node);
      end;

    _balanceIfNeeded(this, pos, node);

    _closeTree(this);
  end;

  function  fetch            (var this : tAVLtree; pos: idxRange) : tNode;
  var
    node : tNode;
  begin
    _openTree(this);
    node := _get(this, pos);
    _closeTree(this);
    fetch := node;
  end;

  function  root             (var this : tAVLtree) : idxRange;
  var
    rc : tControlRecord;
  begin
    _openTree(this);
    rc := _getControl(this);
    _closeTree(this);
    root := rc.root;
  end;

  function  leftChild        (var this : tAVLtree; pos: idxRange) : idxRange;
  var
    node : tNode;
  begin
    _openTree(this);
    node := _get(this, pos);
    _closeTree(this);
    leftChild := node.left;
  end;

  function  rightChild       (var this : tAVLtree; pos: idxRange) : idxRange;
  var
    node : tNode;
  begin
    _openTree(this);
    node := _get(this, pos);
    _closeTree(this);
    rightChild := node.right;
  end;

  function  parent           (var this : tAVLtree; pos: idxRange) : idxRange;
  var
    node : tNode;
  begin
    _openTree(this);
    node := _get(this, pos);
    _closeTree(this);
    parent := node.parent;
  end;


end.

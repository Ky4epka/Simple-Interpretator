unit LinkedList;

interface

type
  TLinkedList = class;

  PLinkedNode = ^TLinkedNode;
  TLinkedNode = record

  public
    ln_Data: Pointer;

    ln_list: TLinkedList;
    ln_PrevNode,
    ln_NextNode: PLinkedNode;

    procedure Init();

  end;

  TLinkedListExecuteCallback = function (List: TLinkedList; Node: PLinkedNode; Value: Pointer): Boolean;

  TLinkedList = class
    fFirstNode,
    fLastNode,
    fCurrentNode: PLinkedNode;
    fDirection: Boolean;

  private

    procedure Initialize;

  public

    constructor Create();
    destructor Destroy(); override;

    procedure Merge(List: TLinkedList);
    procedure Copy(List: TLinkedList);
    procedure Include(List: TLinkedList);
    procedure Exclude(List: TLinkedList);

    function InsertBefore(Node: PLinkedNode; Val: Pointer; ContainsCheck: Boolean = false): Boolean;
    function InsertAfter(Node: PLinkedNode; Val: Pointer; ContainsCheck: Boolean = false): Boolean;
    function Append(Val: Pointer; ContainsCheck: Boolean = false): Boolean;
    function Delete(Node: PLinkedNode; ExecuteDestructor: Boolean=false): Boolean; overload;
    function Delete(Val: Pointer; ExecuteDestructor: Boolean=false): Boolean; overload;
    function Delete(Index: Integer; ExecuteDestructor: Boolean=false): Boolean; overload;

    function Contains(Node: PLinkedNode): Boolean; overload;
    function Contains(Val: Pointer): Boolean; overload;

    function GetFirstNode(): PLinkedNode;
    function GetLastNode(): PLinkedNode;

    function GetNodeByVal(Val: Pointer): PLinkedNode;
    function GetNodeByIndex(Index: Integer): PLinkedNode;

    procedure EnumList(Callback: TLinkedListExecuteCallback);

    function Empty(): Boolean;

    procedure Clear(ExecuteDestructor: Boolean = false);

  end;

implementation


procedure TLinkedNode.Init;
begin
  ln_Data := nil;
  ln_list := nil;
  ln_PrevNode := nil;
  ln_NextNode := nil;
end;

procedure TLinkedList.Initialize;
begin
  fFirstNode := 0;
  fLastNode := 0;
  fCurrentNode := 0;
  fDirection := false;
end;

constructor TLinkedList.Create;
begin
  Initialize();
end;

destructor TLinkedList.Destroy;
begin
  Clear();
  Inherited Destroy;
end;

procedure TLinkedList.Merge(List: TLinkedList);
  var
    CN: PLinkedNode;
begin

  if not Assigned(List) then begin
    Exit;
  end;

  CN := List.fFirstNode;

  while (CN<>nil) do begin
    Append(CN^.ln_Data, false);
    CN := CN^.ln_NextNode;
  end;

end;

procedure TLinkedList.Copy(List: TLinkedList);
  var
    CN: PLinkedNode;
begin

  if not Assigned(List) then begin
    Exit;
  end;

  Clear(false);
  CN := List.fFirstNode;

  while (CN<>nil) do begin
    Append(CN^.ln_Data, false);
    CN := CN^.ln_NextNode;
  end;

end;

procedure TLinkedList.Include(List: TLinkedList);
  var
    CN: PLinkedNode;
begin

  if not Assigned(List) then begin
    Exit;
  end;

  Clear(false);
  CN := List.fFirstNode;

  while (CN<>nil) do begin
    Append(CN^.ln_Data, true);
    CN := CN^.ln_NextNode;
  end;

end;

procedure TLinkedList.Exclude(List: TLinkedList);
  var
    CN: PLinkedNode;
begin

  if not Assigned(List) then begin
    Exit;
  end;

  Clear(false);
  CN := List.fFirstNode;

  while (CN<>nil) do begin
    Delete(CN^.ln_Data);
    CN := CN^.ln_NextNode;
  end;

end;

function TLinkedList.InsertBefore(Node: PLinkedNode; Val: Pointer; ContainsCheck: Boolean = False): Boolean;
 var
   N: PLinkedNode;
begin
  Result := false;

  if ((Node<>nil) and (Node.ln_list<>Self)) or ((ContainsCheck) and (Contains(Val))) then begin
    Exit;
  end;

  New(N);
  N^.Init();
  N^.ln_Data := Val;
  N^.ln_list := Self;

  if (fFirstNode=nil) then begin
    fFirstNode := N;
    fLastNode := N;
    N^.ln_PrevNode := nil;
    N^.ln_NextNode := nil;
  end
  else if ((Node=fFirstNode) or (Node=nil)) then begin
    N^.ln_PrevNode := nil;
    N^.ln_NextNode := fFirstNode;
    fFirstNode^.ln_PrevNode := N;
    fFirstNode := N;
  end
  else begin
    N^.ln_PrevNode := Node^.ln_PrevNode;
    N^.ln_NextNode := Node;
    Node^.ln_PrevNode^.ln_NextNode := N;
    Node^.ln_PrevNode := N;
  end;

  Result := true;
end;

function TLinkedList.InsertAfter(Node: PLinkedNode; Val: Pointer; ContainsCheck: Boolean = False): Boolean;
  var
    N: PLinkedNode;
begin
  Result := false;

  if ((Node<>nil) and (Node.ln_list<>Self)) or ((ContainsCheck) and (Contains(Val))) then begin
    Exit;
  end;

  N := 0;
  New(N);
  N^.ln_Data := nil;
  N^.Init();
  N^.ln_Data := Val;
  N^.ln_list := Self;

  if (fFirstNode=nil) then begin
    fFirstNode := N;
    fLastNode := N;
    N^.ln_PrevNode := nil;
    N^.ln_NextNode := nil;
  end
  else if ((Node=nil) or (Node=fLastNode)) then begin
    N^.ln_PrevNode := fLastNode;
    N^.ln_NextNode := nil;
    fLastNode^.ln_NextNode := N;
    fLastNode := N;
  end
  else begin
    N^.ln_PrevNode := Node;
    N^.ln_NextNode := Node^.ln_NextNode;
    Node^.ln_NextNode^.ln_PrevNode := N;
    Node^.ln_NextNode := N;
  end;

  Result := true;
end;

function TLinkedList.Append(Val: Pointer; ContainsCheck: Boolean = False): Boolean;
begin
  Result := InsertAfter(nil, Val, ContainsCheck);
end;

function TLinkedList.Delete(Node: PLinkedNode; ExecuteDestructor: Boolean=false): Boolean;
  var
    D: Pointer;
begin
  Result := false;

  if (Node=nil) or (Node.ln_list<>Self) then begin
    Exit;
  end;

  if (fFirstNode=fLastNode) then begin
    fFirstNode := nil;
    fLastNode := nil;
  end
  else if (Node=fFirstNode) then begin
    fFirstNode := fFirstNode^.ln_NextNode;
    fFirstNode^.ln_PrevNode := nil;
  end
  else if (Node=fLastNode) then begin
    fLastNode := fLastNode^.ln_PrevNode;
    fLastNode^.ln_NextNode := nil;
  end
  else begin
    Node^.ln_PrevNode^.ln_NextNode := Node^.ln_NextNode;
    Node^.ln_NextNode^.ln_PrevNode := Node^.ln_PrevNode;
  end;

  D := Node^.ln_Data;
  Dispose(Node);

  if (TObject(D).ClassType<>nil) then begin
    TObject(D).Free;
  end;

  Result := true;
end;

function TLinkedList.Delete(Val: Pointer; ExecuteDestructor: Boolean=false): Boolean;
begin
  Result := Delete(GetNodeByVal(Val), ExecuteDestructor);
end;

function TLinkedList.Delete(Index: Integer; ExecuteDestructor: Boolean=false): Boolean;
begin
  Result := Delete(GetNodeByIndex(Index), ExecuteDestructor);
end;

function TLinkedList.Contains(Node: PLinkedNode): Boolean;
  var
    CN: PLinkedNode;
begin
  Result := false;
  CN := fFirstNode;

  while (CN<>nil) do begin

    if (CN=Node) then begin
      Result := true;
      Exit;
    end;

    CN := CN^.ln_NextNode;
  end;

end;

function TLinkedList.Contains(Val: Pointer): Boolean;
begin
  Result := GetNodeByVal(Val)<>nil;
end;

function TLinkedList.GetFirstNode;
begin
  Result := fFirstNode;
end;

function TLinkedList.GetLastNode;
begin
  Result := fLastNode;
end;

function TLinkedList.GetNodeByVal(Val: Pointer): PLinkedNode;
  var
    CN: PLinkedNode;
begin
  Result := nil;
  CN := fFirstNode;

  while (CN<>nil) do begin

    if (CN^.ln_Data=Val) then begin
      Result := CN;
      Exit;
    end;

    CN := CN^.ln_NextNode;
  end;

end;

function TLinkedList.GetNodeByIndex(Index: Integer): PLinkedNode;
  var
    CN: PLinkedNode;
    I: Integer;
begin
  Result := nil;
  CN := fFirstNode;
  I := 0;

  while (CN<>nil) do begin

    if (I=Index) then begin
      Result := CN;
      Exit;
    end;

    Inc(I);
    CN := CN^.ln_NextNode;
  end;
end;

procedure TLinkedList.EnumList(Callback: TLinkedListExecuteCallback);
  var
    CN: PLinkedNode;
begin

  if not Assigned(Callback) then begin
    Exit;
  end;

  CN := fFirstNode;

  while (CN<>nil) do begin
    Callback(Self, CN, CN^.ln_Data);
    CN := CN^.ln_NextNode;
  end;

end;

function TLinkedList.Empty;
begin
  Result := fFirstNode=nil;
end;

procedure TLinkedList.Clear;
  var
    Tmp: PLinkedNode;
    CN: PLinkedNode;
begin
  CN := fFirstNode;

  while (CN<>nil) do begin
    Delete(CN, ExecuteDestructor);
    CN := fFirstNode;
  end;

  fFirstNode := nil;
  fLastNode := nil;
  fCurrentNode := nil;
end;

end.

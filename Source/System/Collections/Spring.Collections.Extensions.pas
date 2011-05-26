{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (C) 2009-2011 DevJET                                  }
{                                                                           }
{           http://www.DevJET.net                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

unit Spring.Collections.Extensions;

{$I Spring.inc}

interface

uses
  SysUtils,
  Spring,
  Spring.Collections;

type
  TNullEnumerator<T> = class(TEnumeratorBase<T>)
  protected
    function GetCurrent: T; override;
  public
    function MoveNext: Boolean; override;
  end;

  TNullEnumerable<T> = class(TEnumerableBase<T>)
  public
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TEnumeratorDecorator<T> = class abstract(TEnumeratorBase<T>)
  private
    fEnumerator: IEnumerator<T>;
  protected
    function GetCurrent: T; override;
    property Enumerator: IEnumerator<T> read fEnumerator;
  public
    constructor Create(const enumerator: IEnumerator<T>);
    function MoveNext: Boolean; override;
    procedure Reset; override;
  end;

  TEnumerableDecorator<T> = class abstract(TEnumerableBase<T>)
  private
    fCollection: IEnumerable<T>;
  protected
    property Collection: IEnumerable<T> read fCollection;
  public
    constructor Create(const collection: IEnumerable<T>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TEnumeratorWithPredicate<T> = class(TEnumeratorDecorator<T>)
  private
    fPredicate: TPredicate<T>;
  public
    constructor Create(const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
    function MoveNext: Boolean; override;
  end;

  TWhereEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    fPredicate: TPredicate<T>;
  public
    constructor Create(const collection: IEnumerable<T>; const predicate: TPredicate<T>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TSkipEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fCount: Integer;
        fSkipped: Boolean;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; count: Integer);
        function MoveNext: Boolean; override;
      end;
  private
    fCount: Integer;
  public
    constructor Create(const collection: IEnumerable<T>; count: Integer);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TSkipWhileEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fPredicate: TPredicate<T>;
        fSkipped: Boolean;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
        function MoveNext: Boolean; override;
      end;
  private
    fPredicate: TPredicate<T>;
  public
    constructor Create(const collection: IEnumerable<T>; const predicate: TPredicate<T>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TSkipWhileIndexEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fPredicate: TFunc<T, Integer, Boolean>;
        fSkipped: Boolean;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; const predicate: TFunc<T, Integer, Boolean>);
        function MoveNext: Boolean; override;
      end;
  private
    fPredicate: TFunc<T, Integer, Boolean>;
  public
    constructor Create(const collection: IEnumerable<T>; const predicate: TFunc<T, Integer, Boolean>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TTakeEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fCount: Integer;
        fTakenCount: Integer;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; count: Integer);
        function MoveNext: Boolean; override;
      end;
  private
    fCount: Integer;
  public
    constructor Create(const collection: IEnumerable<T>; count: Integer);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TTakeWhileEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fPredicate: TPredicate<T>;
        fStopped: Boolean;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
        function MoveNext: Boolean; override;
      end;
  private
    fPredicate: TPredicate<T>;
  public
    constructor Create(const collection: IEnumerable<T>; const predicate: TPredicate<T>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

  TTakeWhileIndexEnumerable<T> = class(TEnumerableDecorator<T>)
  private
    type
      TEnumerator = class(TEnumeratorBase<T>)
      private
        fEnumerator: IEnumerator<T>;
        fPredicate: TFunc<T, Integer, Boolean>;
        fStopped: Boolean;
        fIndex: Integer;
      protected
        function GetCurrent: T; override;
      public
        constructor Create(const enumerator: IEnumerator<T>; const predicate: TFunc<T, Integer, Boolean>);
        function MoveNext: Boolean; override;
      end;
  private
    fPredicate: TFunc<T, Integer, Boolean>;
  public
    constructor Create(const collection: IEnumerable<T>; const predicate: TFunc<T, Integer, Boolean>);
    function GetEnumerator: IEnumerator<T>; override;
  end;

implementation

uses
  Spring.ResourceStrings;

{$REGION 'TNullEnumerator<T>'}

function TNullEnumerator<T>.GetCurrent: T;
begin
  raise EInvalidOperation.CreateRes(@SEnumEmpty);
end;

function TNullEnumerator<T>.MoveNext: Boolean;
begin
  Result := False;
end;

{$ENDREGION}


{$REGION 'TNullEnumerable<T>'}

function TNullEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TNullEnumerator<T>.Create;
end;

{$ENDREGION}


{$REGION 'TEnumerableDecorator<T>'}

constructor TEnumerableDecorator<T>.Create(const collection: IEnumerable<T>);
begin
  inherited Create;
  fCollection := collection;
end;

function TEnumerableDecorator<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := fCollection.GetEnumerator;
end;

{$ENDREGION}


{$REGION 'TEnumeratorDecorator<T>'}

constructor TEnumeratorDecorator<T>.Create(const enumerator: IEnumerator<T>);
begin
  inherited Create;
  fEnumerator := enumerator;
end;

function TEnumeratorDecorator<T>.GetCurrent: T;
begin
  Result := fEnumerator.Current;
end;

function TEnumeratorDecorator<T>.MoveNext: Boolean;
begin
  Result := fEnumerator.MoveNext;
end;

procedure TEnumeratorDecorator<T>.Reset;
begin
  fEnumerator.Reset;
end;

{$ENDREGION}


{$REGION 'TEnumeratorWithPredicate<T>'}

constructor TEnumeratorWithPredicate<T>.Create(
  const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
begin
  inherited Create(enumerator);
  fPredicate := predicate;
end;

function TEnumeratorWithPredicate<T>.MoveNext: Boolean;
begin
  Result := Enumerator.MoveNext;
  while Result and not fPredicate(Enumerator.Current) do
  begin
    Result := Enumerator.MoveNext;
  end;
end;

{$ENDREGION}


{$REGION 'TEnumerableWithPredicate'}

constructor TWhereEnumerable<T>.Create(
  const collection: IEnumerable<T>; const predicate: TPredicate<T>);
begin
  inherited Create(collection);
  fPredicate := predicate;
end;

function TWhereEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumeratorWithPredicate<T>.Create(Collection.GetEnumerator, fPredicate);
end;

{$ENDREGION}

{ TSkipEnumerable<T> }

constructor TSkipEnumerable<T>.Create(const collection: IEnumerable<T>;
  count: Integer);
begin
  inherited Create(collection);
  fCount := count;
end;

function TSkipEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fCount);
end;

{ TSkipEnumerable<T>.TEnumerator }

constructor TSkipEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>; count: Integer);
begin
  inherited Create;
  fEnumerator := enumerator;
  fCount := count;
end;

function TSkipEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  if not fSkipped then
    raise EInvalidOperation.Create('GetCurrent');
  Result := fEnumerator.Current;
end;

function TSkipEnumerable<T>.TEnumerator.MoveNext: Boolean;
var
  n: Integer;
begin
  if fSkipped then
  begin
    Result := fEnumerator.MoveNext;
  end
  else
  begin
    n := 0;
    while not fSkipped and fEnumerator.MoveNext do
    begin
      Inc(n);
      fSkipped := n > fCount;
    end;
    Result := fSkipped;
  end;
end;

{ TSkipWhileEnumerable<T> }

constructor TSkipWhileEnumerable<T>.Create(const collection: IEnumerable<T>;
  const predicate: TPredicate<T>);
begin
  inherited Create(collection);
  fPredicate := predicate;
end;

function TSkipWhileEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fPredicate);
end;

{ TSkipWhileEnumerable<T>.TEnumerator }

constructor TSkipWhileEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
begin
  inherited Create;
  fEnumerator := enumerator;
  fPredicate := predicate;
end;

function TSkipWhileEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  if not fSkipped then
    raise EInvalidOperation.Create('GetCurrent');
  Result := fEnumerator.Current;
end;

function TSkipWhileEnumerable<T>.TEnumerator.MoveNext: Boolean;
begin
  if fSkipped then
  begin
    Result := fEnumerator.MoveNext;
  end
  else
  begin
    while not fSkipped and fEnumerator.MoveNext do
    begin
      fSkipped := fPredicate(fEnumerator.Current);
    end;
    Result := fSkipped;
  end;
end;

{ TSkipWhile2Enumerable<T> }

constructor TSkipWhileIndexEnumerable<T>.Create(const collection: IEnumerable<T>;
  const predicate: TFunc<T, Integer, Boolean>);
begin
  inherited Create(collection);
  fPredicate := predicate;
end;

function TSkipWhileIndexEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fPredicate);
end;

{ TSkipWhile2Enumerable<T>.TEnumerator }

constructor TSkipWhileIndexEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>;
  const predicate: TFunc<T, Integer, Boolean>);
begin
  inherited Create;
  fEnumerator := enumerator;
  fPredicate := predicate;
end;

function TSkipWhileIndexEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  if not fSkipped then
    raise EInvalidOperation.Create('GetCurrent');
  Result := fEnumerator.Current;
end;

function TSkipWhileIndexEnumerable<T>.TEnumerator.MoveNext: Boolean;
var
  index: Integer;
begin
  if fSkipped then
  begin
    Result := fEnumerator.MoveNext;
  end
  else
  begin
    index := 0;
    while not fSkipped and fEnumerator.MoveNext do
    begin
      fSkipped := fPredicate(fEnumerator.Current, index);
      Inc(index);
    end;
    Result := fSkipped;
  end;
end;

{ TTakeEnumerable<T> }

constructor TTakeEnumerable<T>.Create(const collection: IEnumerable<T>;
  count: Integer);
begin
  inherited Create(collection);
  fCount := count;
end;

function TTakeEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fCount);
end;

{ TTakeEnumerable<T>.TEnumerator }

constructor TTakeEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>; count: Integer);
begin
  inherited Create;
  fEnumerator := enumerator;
  fCount := count;
end;

function TTakeEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  Result := fEnumerator.Current;
end;

function TTakeEnumerable<T>.TEnumerator.MoveNext: Boolean;
begin
  Result := (fTakenCount < fCount) and fEnumerator.MoveNext;
  if Result then
  begin
    Inc(fTakenCount);
  end;
end;

{ TTakeWhileEnumerable<T> }

constructor TTakeWhileEnumerable<T>.Create(const collection: IEnumerable<T>;
  const predicate: TPredicate<T>);
begin
  inherited Create(collection);
  fPredicate := predicate;
end;

function TTakeWhileEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fPredicate);
end;

{ TTakeWhileEnumerable<T>.TEnumerator }

constructor TTakeWhileEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>; const predicate: TPredicate<T>);
begin
  inherited Create;
  fEnumerator := enumerator;
  fPredicate := predicate;
end;

function TTakeWhileEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  if fStopped then
    raise EInvalidOperation.Create('GetCurrent');
  Result := fEnumerator.Current;
end;

function TTakeWhileEnumerable<T>.TEnumerator.MoveNext: Boolean;
begin
  Result := not fStopped;
  if Result then
  begin
    fStopped := not fEnumerator.MoveNext or not fPredicate(fEnumerator.Current);
    Result := not fStopped;
  end;
end;

{ TTakeWhileIndexEnumerable<T> }

constructor TTakeWhileIndexEnumerable<T>.Create(
  const collection: IEnumerable<T>;
  const predicate: TFunc<T, Integer, Boolean>);
begin
  inherited Create(collection);
  fPredicate := predicate;
end;

function TTakeWhileIndexEnumerable<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumerator.Create(Collection.GetEnumerator, fPredicate);
end;

{ TTakeWhileIndexEnumerable<T>.TEnumerator }

constructor TTakeWhileIndexEnumerable<T>.TEnumerator.Create(
  const enumerator: IEnumerator<T>;
  const predicate: TFunc<T, Integer, Boolean>);
begin
  inherited Create;
  fEnumerator := enumerator;
  fPredicate := predicate;
  fIndex := -1;
end;

function TTakeWhileIndexEnumerable<T>.TEnumerator.GetCurrent: T;
begin
  if fStopped then
    raise EInvalidOperation.Create('GetCurrent');
  Result := fEnumerator.Current;
end;

function TTakeWhileIndexEnumerable<T>.TEnumerator.MoveNext: Boolean;
begin
  Result := not fStopped;
  if Result then
  begin
    Inc(fIndex);
    fStopped := not fEnumerator.MoveNext or not fPredicate(fEnumerator.Current, fIndex);
    Result := not fStopped;
  end;
end;

end.
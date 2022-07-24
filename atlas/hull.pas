unit hull;


interface
uses
  Math;

type
   TPointEx = record
    X: Extended;
    Y: Extended;
  end;
  TPointArray = array of TPointEx;

function FindConvexHull(var APoints: TPointArray): Boolean;
procedure QuickSortAngle(var A: TPointArray; Angles: array of Real; iLo, iHi: Integer);

implementation

function FindConvexHull(var APoints: TPointArray): Boolean;
var
  LAngles: array of Real;
  Lindex,  LPivotIndex: Integer;
  LPivot: TPointEx;
  LBehind, LInfront: TPointEx;
  LRightTurn: Boolean;
  LVecPoint: TPointEx;
  LMinY, LMaxX:real;
begin
  Result := True;

  if Length(APoints) = 3 then Exit; // already a convex hull
  if Length(APoints) < 3 then
  begin // not enough points
    Result := False;
    Exit;
  end;

  // find pivot point, which is known to be on the hull
  // point with lowest y - if there are multiple, point with highest x
  LMinY := 10000;
  LMaxX := 10000;
  LPivotIndex := 0;
  for Lindex := 0 to High(APoints) do
  begin
    if APoints[Lindex].Y = LMinY then
    begin
      if APoints[Lindex].X > LMaxX then
      begin
        LMaxX := APoints[Lindex].X;
        LPivotIndex := Lindex;
      end;
    end
    else if APoints[Lindex].Y < LMinY then
    begin
      LMinY := APoints[Lindex].Y;
      LMaxX := APoints[Lindex].X;
      LPivotIndex := Lindex;
    end;
  end;
  // put pivot into seperate variable and remove from array
  LPivot := APoints[LPivotIndex];
  APoints[LPivotIndex] := APoints[High(APoints)];
  SetLength(APoints, High(APoints));

  // calculate angle to pivot for each point in the array
  // quicker to calculate dot product of point with a horizontal comparison vector
  SetLength(LAngles, Length(APoints));
  for Lindex := 0 to High(APoints) do
  begin
    LVecPoint.X := LPivot.X - APoints[Lindex].X; // point vector
    LVecPoint.Y := LPivot.Y - APoints[Lindex].Y;
    // reduce to a unit-vector - length 1
    LAngles[Lindex] := LVecPoint.X / (Hypot(LVecPoint.X, LVecPoint.Y)+0.0000001);
  end;

  // sort the points by angle
  QuickSortAngle(APoints, LAngles, 0, High(APoints));

  // step through array to remove points that are not part of the convex hull
  Lindex := 1;
  repeat
    // assign points behind and infront of current point
    if Lindex = 0 then LRightTurn := True
    else
    begin
      LBehind := APoints[Lindex - 1];
      if Lindex = High(APoints) then LInfront := LPivot
      else
        LInfront := APoints[Lindex + 1];

      // work out if we are making a right or left turn using vector product
      if ((LBehind.X - APoints[Lindex].X) * (LInfront.Y - APoints[Lindex].Y)) -
        ((LInfront.X - APoints[Lindex].X) * (LBehind.Y - APoints[Lindex].Y)) < 0 then
        LRightTurn := True
      else
        LRightTurn := False;
    end;

    if LRightTurn then
    begin // point is currently considered part of the hull
      Inc(Lindex); // go to next point
    end
    else
    begin // point is not part of the hull
      // remove point from convex hull
      if Lindex = High(APoints) then
      begin
        SetLength(APoints, High(APoints));
      end
      else
      begin
        Move(APoints[Lindex + 1], APoints[Lindex],
        (High(APoints) - Lindex) * SizeOf(TPointEx) + 1);
        SetLength(APoints, High(APoints));
      end;

      Dec(Lindex); // backtrack to previous point
    end;
  until Lindex = High(APoints);

  // add pivot back into points array
  SetLength(APoints, Length(APoints) + 1);
  APoints[High(APoints)] := LPivot;
end;

// sort an array of points by angle
procedure QuickSortAngle(var A: TPointArray; Angles: array of Real; iLo, iHi: Integer);
var
  Lo, Hi: Integer;
  Mid: Real;
  TempPoint: TPointEx;
  TempAngle: Real;
begin
  Lo  := iLo;
  Hi  := iHi;
  Mid := Angles[(Lo + Hi) div 2];
  repeat
    while Angles[Lo] < Mid do Inc(Lo);
    while Angles[Hi] > Mid do Dec(Hi);
    if Lo <= Hi then
    begin
      // swap points
      TempPoint := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := TempPoint;
      // swap angles
      TempAngle := Angles[Lo];
      Angles[Lo] := Angles[Hi];
      Angles[Hi] := TempAngle;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  // perform quicksorts on subsections
  if Hi > iLo then QuickSortAngle(A, Angles, iLo, Hi);
  if Lo < iHi then QuickSortAngle(A, Angles, Lo, iHi);
end;


end.

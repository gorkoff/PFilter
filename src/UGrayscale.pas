unit UGrayscale;

interface

uses
  VCL.Graphics, UPixelConvert;

type
  TCGrayscaleImage = class
  private
    Height, Width: word;

    procedure FreePixels;
    procedure InitPixels;
    function GetPixelValue(i, j: integer): double;
    constructor CreateCopy(From: TCGrayscaleImage);
  public
    Pixels: array of array of double;
    constructor Create;

    procedure SetHeight(newHeight: word);
    function GetHeight: word;
    procedure SetWidth(newWidth: word);
    function GetWidth: word;
    procedure Copy(From: TCGrayscaleImage);

    procedure AVGFilter(h, w: word);
    procedure WeightedAVGFilter(h, w: word);
    procedure GeometricMeanFilter(h, w: word);
    procedure MedianFilter(h, w: word);
    procedure MaxFilter(h, w: word);
    procedure MinFilter(h, w: word);
    procedure MiddlePointFilter(h, w: word);
    procedure TruncatedAVGFilter(h, w, d: word);
    // procedure LaplaceFilter(AddToOriginal: boolean);
    // procedure SobelFilter(AddToOriginal: boolean);
    // procedure PrevittFilter(AddToOriginal: boolean);
    // procedure SharrFilter(AddToOriginal: boolean);
    // procedure HistogramEqualization(var GSI: TGreyscaleImage);
    // function Histogram(var RGBI: TRGBImage; Channel: byte): TBitMap;

    procedure LinearTransform(k, b: double);
    procedure LogTransform(c: double);
    procedure GammaTransform(c, gamma: double);

    procedure LoadFromBitMap(BM: TBitMap);
    function SaveToBitMap: TBitMap;
  end;

implementation

uses Math;

constructor TCGrayscaleImage.Create;
begin
  inherited;
  self.Height := 0;
  self.Width := 0;
end;

constructor TCGrayscaleImage.CreateCopy(From: TCGrayscaleImage);
var
  i, j: word;
begin
  inherited;
  self.SetHeight(From.GetHeight);
  self.SetWidth(From.GetWidth);
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
      self.Pixels[i, j] := From.Pixels[i, j];
end;

procedure TCGrayscaleImage.FreePixels;
var
  i: word;
begin
  if (self.Height > 0) and (self.Width > 0) then
  begin
    for i := 0 to self.Height - 1 do
      self.Pixels[i] := nil;
    self.Pixels := nil;
  end;
end;

procedure TCGrayscaleImage.InitPixels;
var
  i, j: word;
begin
  if (self.Height > 0) and (self.Width > 0) then
  begin
    SetLength(self.Pixels, self.Height);
    for i := 0 to self.Height - 1 do
    begin
      SetLength(self.Pixels[i], self.Width);
      for j := 0 to self.Width - 1 do
        self.Pixels[i, j] := 0;
    end;
  end;
end;

procedure TCGrayscaleImage.SetHeight(newHeight: word);
begin
  FreePixels;
  self.Height := newHeight;
  self.InitPixels;
end;

function TCGrayscaleImage.GetHeight: word;
begin
  GetHeight := self.Height;
end;

procedure TCGrayscaleImage.SetWidth(newWidth: word);
begin
  FreePixels;
  self.Width := newWidth;
  self.InitPixels;
end;

function TCGrayscaleImage.GetWidth: word;
begin
  GetWidth := self.Width;
end;

function TCGrayscaleImage.GetPixelValue(i, j: integer): double;
begin
  if i < 0 then
    i := 0;
  if i >= self.Height then
    i := self.Height - 1;
  if j < 0 then
    j := 0;
  if j >= self.Width then
    j := self.Width - 1;
  GetPixelValue := self.Pixels[i, j];
end;

procedure TCGrayscaleImage.Copy(From: TCGrayscaleImage);
var
  i, j: word;
begin
  if (self.Height <> From.Height) or (self.Width <> From.Width) then
  begin
    self.SetHeight(From.Height);
    self.SetWidth(From.Width);
  end;
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
      self.Pixels[i, j] := From.Pixels[i, j];
end;

procedure TCGrayscaleImage.AVGFilter(h, w: word);
var
  i, j: word;
  fi, fj: integer;
  sum: double;
  GSIR: TCGrayscaleImage;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);

  for i := 1 to self.Height - 1 do
    for j := 1 to self.Width - 1 do
    begin
      sum := 0;
      for fi := -h to h do
        for fj := -w to w do
          sum := sum + self.GetPixelValue(i + fi, j + fj);
      sum := sum / ((2 * h + 1) * (2 * w + 1));
      GSIR.Pixels[i, j] := sum;
    end;
  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.WeightedAVGFilter(h, w: word);
var
  i, j: integer;
  fi, fj: integer;
  sum: double;
  GSIR: TCGrayscaleImage;
  Mask: array of array of double;
  maxDist, maskWeigth: double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(Mask, 2 * h + 2);
  for i := 1 to 2 * h + 1 do
    SetLength(Mask[i], 2 * w + 2);
  for i := -h to h do
    for j := -w to w do
      Mask[i + h + 1, j + w + 1] := sqrt(sqr(i) + sqr(j));
  maxDist := Mask[1, 1];
  maskWeigth := 0;
  for i := 1 to 2 * h + 1 do
    for j := 1 to 2 * w + 1 do
    begin
      Mask[i, j] := (maxDist - Mask[i, j]) / maxDist;
      maskWeigth := maskWeigth + Mask[i, j];
    end;

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      sum := 0;
      for fi := -h to h do
        for fj := -w to w do
          sum := sum + Mask[fi + h + 1, fj + w + 1] *
            self.GetPixelValue(i + fi, j + fj);
      GSIR.Pixels[i, j] := sum / maskWeigth;
    end;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.GeometricMeanFilter(h, w: word);
var
  i, j: word;
  fi, fj: integer;
  p: extended;
  GSIR: TCGrayscaleImage;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      p := 1;
      for fi := -h to h do
        for fj := -w to w do
          p := p * self.GetPixelValue(i + fi, j + fj);
      p := power(p, 1 / ((2 * h + 1) * (2 * w + 1)));
      GSIR.Pixels[i, j] := p;
    end;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.MedianFilter(h, w: word);
  function FindMedian(N: word; var Arr: array of double): double;
  var
    L, R, k, i, j: word;
    w, x: double;
  begin
    L := 1;
    R := N;
    k := (N div 2) + 1;
    while L < R - 1 do
    begin
      x := Arr[k];
      i := L;
      j := R;
      repeat
        while Arr[i] < x do
          i := i + 1;
        while x < Arr[j] do
          j := j - 1;
        if i <= j then
        begin
          w := Arr[i];
          Arr[i] := Arr[j];
          Arr[j] := w;
          i := i + 1;
          j := j - 1;
        end;
      until i > j;
      if j < k then
        L := i;
      if k < i then
        R := j;
    end;
    FindMedian := Arr[k];
  end;

var
  i, j: word;
  fi, fj: integer;
  GSIR: TCGrayscaleImage;
  k: word;
  tmp: array of double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(tmp, (2 * h + 1) * (2 * w + 1) + 1);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      k := 0;
      for fi := -h to h do
        for fj := -w to w do
        begin
          k := k + 1;
          tmp[k] := self.GetPixelValue(i + fi, j + fj);
        end;
      GSIR.Pixels[i, j] := FindMedian((2 * h + 1) * (2 * w + 1), tmp);
    end;
  tmp := nil;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.MaxFilter(h, w: word);
var
  i, j: word;
  fi, fj: integer;
  GSIR: TCGrayscaleImage;
  k: word;
  Max: double;
  tmp: array of double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(tmp, (2 * h + 1) * (2 * w + 1) + 1);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      k := 0;
      for fi := -h to h do
        for fj := -w to w do
        begin
          k := k + 1;
          tmp[k] := self.GetPixelValue(i + fi, j + fj);
        end;
      Max := tmp[1];
      for k := 1 to (2 * h + 1) * (2 * w + 1) do
        if tmp[k] > Max then
          Max := tmp[k];
      GSIR.Pixels[i, j] := Max;
    end;
  tmp := nil;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.MinFilter(h, w: word);
var
  i, j: word;
  fi, fj: integer;
  GSIR: TCGrayscaleImage;
  k: word;
  Min: double;
  tmp: array of double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(tmp, (2 * h + 1) * (2 * w + 1) + 1);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      k := 0;
      for fi := -h to h do
        for fj := -w to w do
        begin
          k := k + 1;
          tmp[k] := self.GetPixelValue(i + fi, j + fj);
        end;
      Min := tmp[1];
      for k := 1 to (2 * h + 1) * (2 * w + 1) do
        if tmp[k] < Min then
          Min := tmp[k];
      GSIR.Pixels[i, j] := Min;
    end;
  tmp := nil;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.MiddlePointFilter(h, w: word);
var
  i, j: word;
  fi, fj: integer;
  GSIR: TCGrayscaleImage;
  k: word;
  Min, Max: double;
  tmp: array of double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(tmp, (2 * h + 1) * (2 * w + 1) + 1);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      k := 0;
      for fi := -h to h do
        for fj := -w to w do
        begin
          k := k + 1;
          tmp[k] := self.GetPixelValue(i + fi, j + fj);
        end;
      Min := tmp[1];
      Max := tmp[1];
      for k := 1 to (2 * h + 1) * (2 * w + 1) do
      begin
        if tmp[k] < Min then
          Min := tmp[k];
        if tmp[k] > Max then
          Max := tmp[k];
      end;
      GSIR.Pixels[i, j] := (Max + Min) / 2;
    end;
  tmp := nil;

  self.Copy(GSIR);
  GSIR.Free;
end;

procedure TCGrayscaleImage.TruncatedAVGFilter(h, w, d: word);
var
  i, j: word;
  fi, fj: integer;
  GSIR: TCGrayscaleImage;
  k, L: word;
  val: double;
  tmp: array of double;
  sum: double;
begin
  GSIR := TCGrayscaleImage.CreateCopy(self);
  SetLength(tmp, (2 * h + 1) * (2 * w + 1) + 1);

  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      k := 0;
      for fi := -h to h do
        for fj := -w to w do
        begin
          k := k + 1;
          tmp[k] := self.GetPixelValue(i + fi, j + fj);
        end;
      for k := 1 to (2 * h + 1) * (2 * w + 1) - 1 do
        for L := k + 1 to (2 * h + 1) * (2 * w + 1) do
          if tmp[k] > tmp[L] then
          begin
            val := tmp[k];
            tmp[k] := tmp[L];
            tmp[L] := val;
          end;
      sum := 0;
      for k := d + 1 to (2 * h + 1) * (2 * w + 1) - d do
        sum := sum + tmp[k];
      GSIR.Pixels[i, j] := sum / ((2 * h + 1) * (2 * w + 1) - 2 * d);
    end;
  tmp := nil;

  self.Copy(GSIR);
  GSIR.Free;
end;

/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////

procedure TCGrayscaleImage.LinearTransform(k, b: double);
var
  i, j: word;
  val: double;
begin
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      val := k * self.Pixels[i, j] + b;
      if val > 1 then
        val := 1;
      if val < 0 then
        val := 0;
      self.Pixels[i, j] := val;
    end;
end;

procedure TCGrayscaleImage.LogTransform(c: double);
var
  i, j: word;
  val: double;
begin
  // TODO �������� ������ ������������� � ���������� �� 255
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      val := c * log2(self.Pixels[i, j] + 1);
      if val > 1 then
        val := 1;
      if val < 0 then
        val := 0;
      self.Pixels[i, j] := val;
    end;
end;

procedure TCGrayscaleImage.GammaTransform(c, gamma: double);
var
  i, j: word;
  val: double;
begin
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      val := c * power(self.Pixels[i, j], gamma);
      if val > 1 then
        val := 1;
      if val < 0 then
        val := 0;
      self.Pixels[i, j] := val;
    end;
end;

procedure TCGrayscaleImage.LoadFromBitMap(BM: TBitMap);
var
  i, j: word;
  p: TColorPixel;
begin
  p := TColorPixel.Create;
  self.Height := BM.Height;
  self.Width := BM.Width;
  self.InitPixels;
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      p.SetFullColor(BM.Canvas.Pixels[j, i]);
      self.Pixels[i, j] := p.GetColorChannel(ccY);
    end;
  p.Free;
end;

function TCGrayscaleImage.SaveToBitMap: TBitMap;
var
  i, j: word;
  BM: TBitMap;
  p: TColorPixel;
begin
  p := TColorPixel.Create;
  BM := TBitMap.Create;
  BM.Height := self.Height;
  BM.Width := self.Width;
  for i := 0 to self.Height - 1 do
    for j := 0 to self.Width - 1 do
    begin
      p.SetRGB(self.Pixels[i, j], self.Pixels[i, j], self.Pixels[i, j]);
      BM.Canvas.Pixels[j, i] := p.GetFullColor;
    end;
  SaveToBitMap := BM;
  p.Free;
end;

end.
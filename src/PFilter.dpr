program PFilter;

uses
  Forms,
  UFFilter in 'UFFilter.pas' {FFilter},
  UColorImages in '..\..\ImgSharedUnits\src\UColorImages.pas',
  UBitMapFunctions in '..\..\ImgSharedUnits\src\UBitMapFunctions.pas',
  UGrayscaleImages in '..\..\ImgSharedUnits\src\UGrayscaleImages.pas',
  UPixelConvert in '..\..\ImgSharedUnits\src\UPixelConvert.pas',
  UBinaryImages in '..\..\ImgSharedUnits\src\UBinaryImages.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFFilter, FFilter);
  Application.CreateForm(TFFilter, FFilter);
  Application.Run;

end.

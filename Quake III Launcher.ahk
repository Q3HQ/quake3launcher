#SingleInstance Force
#NoTrayIcon

IniRead, AutoUpdate, Extras\Q3HQ\Launcher\Settings.ini, AutoUpdate, AutoUpdate, weekly
IniRead, LastUpdate, Extras\Q3HQ\Launcher\Settings.ini, AutoUpdate, LastUpdate, 
UpDateDifference := A_Now - LastUpdate

if AutoUpdate=always
	AutoUpdate=0

if AutoUpdate=daily
	AutoUpdate=1000000

if AutoUpdate=weekly
	AutoUpdate=7000000

if AutoUpdate=monthly
	AutoUpdate=100000000

UrlDownloadToVar(url) {
	try {
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", url, false)
		whr.Send()
		whr.WaitForResponse()
		Return % whr.ResponseText
	} catch e {
		MsgBox, Download Error
		goSub, Run
	}
}

If !FileExist("Extras\Q3HQ\Launcher")
	FileCreateDir, %A_ScriptDir%\Extras\Q3HQ\Launcher

If ( !FileExist("Extras\Q3HQ\Launcher\Launcher") || ( (AutoUpdate != never) && (UpDateDifference > AutoUpdate) ) ) {
	LatestScript := UrlDownloadToVar("https://raw.githubusercontent.com/Q3HQ/quake3launcher/master/Extras/Q3HQ/Launcher/Launcher2")
	FileRead, LocalScript, "Extras\Q3HQ\Launcher\Launcher"
	if ( LocalScript != LatestScript ) {
		LocalScriptFile := FileOpen("Extras\Q3HQ\Launcher\Launcher", "w")
		LocalScriptFile.write(LatestScript)
		IniWrite, %A_Now%, Extras\Q3HQ\Launcher\Settings.ini, AutoUpdate, LastUpdate
		MsgBox, Update downloaded
	}
}

Run:
		MsgBox, %LocalScript%
		MsgBox, %LatestScript%
		MsgBox, %UpDateDifference% > %AutoUpdate%
SplitPath, A_ScriptFullPath, name, dir, ext, name_no_ext, drive ; for debugging
Run, %name_no_ext%.exe /script "Extras\Q3HQ\Launcher\Launcher"
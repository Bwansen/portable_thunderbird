#NoTrayIcon

#Region AutoIt3Wrapper Directives
#AutoIt3Wrapper_Icon=.\Thunderbird\chrome\icons\default\messengerWindow.ico
#AutoIt3Wrapper_Outfile=ThunderbirdGPGLoader.exe
#AutoIt3Wrapper_Res_Description=Loader for Portable Thunderbird with Enigmail and GnuPG
#AutoIt3Wrapper_Res_Fileversion=0.3.1
#AutoIt3Wrapper_Res_ProductVersion=0.3.1
#EndRegion AutoIt3Wrapper Directives

#Region Includes
#include <WinAPIProc.au3>
#EndRegion

$params = IniRead( "ThunderbirdGPGLoader.ini", "Thunderbird", "parameters", "" )
If $cmdline[0] Then $params = $params & " " & $cmdline[1]
$tb_path = @ScriptDir & "\" & IniRead( "ThunderbirdGPGLoader.ini", "Thunderbird", "exe_directory", "Thunderbird" )
$tb_profile = IniRead( "ThunderbirdGPGLoader.ini", "Thunderbird", "profile_directory", "Profilordner" )
$tb_cmdline = $tb_path & "\thunderbird.exe -profile " & $tb_profile & " " & $params
$gpg_path = @ScriptDir & "\" & IniRead( "ThunderbirdGPGLoader.ini", "GnuPG", "exe_directory", "GnuPG\bin" )
$pep_path = @ScriptDir & "\" & IniRead( "ThunderbirdGPGLoader.ini", "pEp", "exe_directory", "pEp\bin" )
$path = EnvGet("path")
EnvSet("path", $gpg_path & ";" & $pep_path & ";" & $path)
If ProcessExists("thunderbird.exe") Then
   $a_process_list = ProcessList("thunderbird.exe")
   For $i = 1 To $a_process_list[0][0]
	  $current_process = StringLower(_WinAPI_GetProcessFileName($a_process_list[$i][1]))
	  If $current_process <> StringLower($tb_path & "\thunderbird.exe") Then
		 $tb_cmdline = $tb_path & "\thunderbird.exe -no-remote -profile " & $tb_profile & " " & $params
	  EndIf
   Next
EndIf
Run($tb_cmdline)
ProcessWaitClose("thunderbird.exe")
Sleep(1000)
If ProcessExists("gpg.exe") Then
   $a_process_list = ProcessList("gpg.exe")
   For $i = 1 To $a_process_list[0][0]
	  $current_process = StringLower(_WinAPI_GetProcessFileName($a_process_list[$i][1]))
	  If $current_process = StringLower($gpg_path & "\gpg.exe") Then
		 ProcessClose($a_process_list[$i][1])
	  EndIf
   Next
EndIf
If ProcessExists("pep-json-server.exe") Then
   $a_process_list = ProcessList("pep-json-server.exe")
   For $i = 1 To $a_process_list[0][0]
	  $current_process = StringLower(_WinAPI_GetProcessFileName($a_process_list[$i][1]))
	  If $current_process = StringLower($pep_path & "\pep-json-server.exe") Then
		 ProcessClose($a_process_list[$i][1])
	  EndIf
   Next
EndIf

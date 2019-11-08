#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=StringSupport.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=String functions
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Bert Kerkhof 2019-11-07 Apache 2.0 license
#AutoIt3Wrapper_Res_SaveSource=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 3 -w 4 -w 5
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/reel /tc 2
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /sv /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; The latest version of this source is published at GitHub in
; the BertKerkhof repository "StringSupport".

#include-once
#include <EditConstants.au3>; Delivered With AutoIT
#include <GuiEdit.au3>; Delivered With AutoIT
#include <GUIConstantsEx.au3>; Delivered With AutoIT
#include <WindowsConstants.au3>; Delivered With AutoIT

; Author ....: Bert Kerkhof ( kerkhof.bert@gmail.com )
; Tested with: AutoIt version 3.3.14.5 and win10


; String support ====================================================

; #FUNCTION#
; Name ..........: cc
; Description ...: Display to the Scite console
; Syntax ........: cc(Const $sInput)
; Parameters ....: $sInput.... [const] content string to display
; Returns .......: None
; Author ........: Bert Kerkhof

Func cc(Const $sInput)
  ConsoleWrite($sInput & @CRLF)
EndFunc   ;==>cc

; #FUNCTION#
; Name ..........: sRep
; Description ...: Return string with the character repeated
; Syntax ........: sRep(Const $Char[, $nTimes = 10])
; Parameters ....: $Char ..... [const] character to display
;                  $nTimes ... [optional] number of times to
;                              repeat. Default is 10 times
; Returns .......: String
; Author ........: Bert Kerkhof

Func sRep(Const $Char, Const $nTimes = 10)
  Local $C = $Char, $N = $nTimes, $sResult = ""
  While $N > 1
    If BitAND($N, 1) Then $sResult &= $C
    $C &= $C
    $N = BitShift($N, 1)
  WEnd
  Return $N ? $C & $sResult : ""
EndFunc   ;==>sRep

; #FUNCTION#
; Name ..........: Spaces
; Description ...: Return a string of spaces
; Syntax ........: Spaces(Const $N)
; Parameters ....: $N ..... [const] number of spaces
; Returns .......: String
; Author ........: Bert Kerkhof

Func Spaces(Const $N)
  Return sRep(' ', $N)
EndFunc   ;==>Spaces

; #FUNCTION#
; Name ..........: sJustR
; Description ...: Add trailing spaces up to a specified length
; Syntax ........: sJustR($sString, $Len)
; Parameters ....: $sString .... String to add spaces
;                  $Len ........ Length of the resulting string
; Returns .......: String to display
; Author ........: Bert Kerkhof

Func sJustR($sString, $Len)
  Return StringRight(Spaces($Len) & $sString, $Len)
EndFunc   ;==>sJustR

; #FUNCTION#
; Name ..........: sJustL
; Description ...: Add leading spaces up to a specified length
; Syntax ........: sJustL($sString, $Len)
; Parameters ....: $sString ... String to add spaces to
;                  $Len ....... Length of the resulting string
; Returns .......: String to display
; Author ........: Bert Kerkhof

Func sJustL($sString, $Len)
  Return StringLeft($sString & Spaces($Len), $Len)
EndFunc   ;==>sJustL

; #FUNCTION#
; Name ..........: nString
; Description ...: Count number of substring occurrences
; Syntax ........: nString($sString, $sSearch[, $iStart = 1])
; Parameters ....: $sString ... String to search in
;                  $sSearch ... Substring to search
;                  $iStart .... [optional] index to sString
;                               where the search starts.
;                               Default is 1.
; Returns .......: Number of occurrences
; Author ........: Bert Kerkhof

Func nString($sString, $sSearch, $iStart = 1)
  For $I = 1 To 2147483647 ; Max 32 bit integer (2**31 - 1)
    $iStart = StringInStr($sString, $sSearch, 0, 1, $iStart) + 1
    If $iStart = 1 Then ExitLoop
  Next
  Return $I - 1
EndFunc   ;==>nString

; #FUNCTION#
; Name ..........: sReplace
; Description ...: Alternative to StringReplace(), operates as
;                  fast. This version has an $iStart param.
; Syntax ........: sReplace($sString, $sSource, $sTarget[, $iStart = 1])
; Parameters ....: $sString ... String to modify
;                  $sSource ... Substring to be replaced
;                  $sTarget ... Substring to replace with
;                  $iStart .... [optional] index to sString where the search
;                               starts. Default is 1.
; Returns .......: None
; Author ........: Bert Kerkhof

Func sReplace($sString, $sSource, $sTarget, $iStart = 1)
  Local $nTimes = 0
  While True
    Local $iFound = StringInStr($sString, $sSource, 0, 1, $iStart)
    If $iFound = 0 Then ExitLoop
    $nTimes += 1
    $sString = StringLeft($sString, $iFound - 1) & $sTarget & _
        StringMid($sString, $iFound + StringLen($sSource))
    $iStart = $iFound + StringLen($sTarget)
  WEnd
  SetExtended($nTimes)
  Return $sString
EndFunc   ;==>sReplace

; #FUNCTION#
; Name ..........: sWordCase
; Description ...: Modifies the first character of a word to upper case
; Syntax ........: sWordCase($sWord)
; Parameters ....: $sWord .... Word to modify
; Returns .......: Modified word
; Author ........: Bert Kerkhof

Func sWordCase($sWord)
  Return StringUpper(StringLeft($sWord, 1)) & StringMid($sWord, 2)
EndFunc   ;==>sWordCase

; #FUNCTION#
; Name ..........: StringTitleCase
; Description ...: Modifies the first character of the words in the string
; Syntax ........: StringTitleCase($sTitle)
; Parameters ....: $sTitle ..... String to modify
; Returns .......: Modified string
; Author ........: Bert Kerkhof

Func StringTitleCase($sTitle)
  $sTitle = StringStripWS($sTitle, 7)  ; Remove leading trailing / double spaces
  Local $sOut = '', $aWord = StringSplit($sTitle, ' ')
  For $I = 1 To $aWord[0]
    Local $sWord = $aWord[$I]
    $sOut &= sWordCase($sWord)
  Next
  Return $sOut
EndFunc   ;==>StringTitleCase

; Number support ====================================================

; #FUNCTION#
; Name ..........: StringFloat
; Description ...: Reformat floating number
; Syntax ........: StringFloat(Const $Number, Const $N)
; Parameters ....: $Number .. Number to reformat
;                  $N ....... # of digit after comma
; Returns .......: String to display
; Author ........: Bert Kerkhof

Func StringFloat(Const $Number, Const $N)
  ; ReFormat float : # digits after comma
  If $N = 0 Then Return Round($Number)
  Local $Sign = $Number < 0, $Whole = Floor(Abs($Number))
  Local $Fract = Round((Abs($Number) - $Whole) * 10 ^ $N)
  If $Fract = 10 ^ $N Then
    $Whole += 1
    $Fract = StringTrimLeft($Fract, 1)
  EndIf
  If $Sign Then $Whole = -1 * $Whole
  Return $Whole & '.' & StringLeft($Fract & sRep('0', $N), $N)
EndFunc   ;==>StringFloat

; End ===============================================================

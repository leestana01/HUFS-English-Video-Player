#SingleInstance force

;클라이언트 세팅 ---------------------
version = 1
실행한파일 =

;상태 체크 ------------------
urldownloadtofile, <<수정됨>> , %a_temp%\check%a%.txt
If ErrorLevel
	{
	msgbox,,네트워크 오류,네트워크 설정에 오류가 있습니다.`n네트워크 상태를 체크해주신 뒤 다시 시도해 주세요.
	FileDelete, %a_temp%\check%a%.txt
	exitapp
	}
fileread, 상태, %a_temp%\check%a%.txt
FileDelete, %a_temp%\check%a%.txt
Ifnotinstring, 상태, SERVon64512973
	{
	Ifinstring, 상태, SERVon
		{
		msgbox,,공지, 업데이트 버전이 존재합니다. `n`n다운로드 링크로 이동합니다.
		run <<수정됨>>
		exitapp
		}
	msgbox,,공지, 현재 사용이 불가능한 프로그램입니다. `n관리자에게 문의 바랍니다.
	exitapp
	}

;GUI 제작 -------------------
Gui, Add, GroupBox, x12 y9 w250 h120 , 영상 정보 입력

Gui, Add, Text, x22 y29 w90 h20, 챕터(숫자)
Gui, Add, Text, x22 y55 w230 h20 , ex) 챕터1의 3번째 동영상일 경우`, 1 입력
Gui, Add, DropDownList, x112 y29 w100 h80 v챕터, 

Gui, Add, Text, x22 y79 w90 h20, 영상 순서
Gui, Add, Text, x22 y105 w230 h20 , ex) 챕터1의 3번째 동영상일 경우`, 3 입력
Gui, Add, DropDownList, x112 y79 w100 h80 v순서, 1|2|3

Gui, Add, Button, x280 y19 w180 h110 g다운로드, 실 행
Gui, Add, Text, x12 y145 w400 h40 , *존재하지 않는 챕터나 영상 선택하면 무슨 일 생겨도 책임 안짐`n*이 프로그램 사용이 문제가 있다면 바로 내리겠습니다.
Gui, Add, StatusBar, w365 h20 v상태바, %상태바%
Gui, Show, x650 y404 h200 w479, 대학영어 영상 플레이어

;영상 추가
Ectrl(20200316, "1|2")
Ectrl(20200323, "3|4")
Ectrl(20200330, "5|6")
Ectrl(20200511, "7")
Ectrl(20200518, "8")
Ectrl(20200525, "9")
Ectrl(20200601, "10")
Ectrl(20200608, "11")
Ectrl(20200615, "12")
Ectrl(20200615, "13|14|15|16|17|18|19|20|21|22")

상태변경("챕터와 영상을 선택해주세요")
msgbox,64, ☆ 매우 중요한 프로그램공지 ☆, 이 프로그램은 '평화'반에 기초하여 만들어졌습니다.`n`n다른 강좌를 수강하는 분들게서는 유의해주시기 바랍니다.
Return

;다운로드 시작 ----------------
다운로드:
gui,submit,nohide
if (챕터="" or 순서="")
{
	msgbox,,입력 안됨, 빈 칸이 존재합니다.
	return
}
파일경로 = %A_Temp%\EP_%챕터%_0%순서%.wmv
링크 = <<수정됨>>
msgbox,, 실행할 준비가 됨, 잠시만 기다려 주세요`n`n로딩이 완료 된 후`, 곧 영상이 실행됩니다. ,3
상태변경("영상을 다운로드 중입니다. 잠시만 기다려 주세요.")
;msgbox,,다운로드 요청, EP_%챕터%_0%순서%.wmv `n파일을 다운로드 시작합니다.,2
UrlDownloadToFile, %링크%, %A_Temp%\EP_%챕터%_0%순서%.wmv
if errorlevel
	{
	 msgbox,, 이런!, 파일을 다운 받을 수가 없습니다.`n존재하지 않는 챕터이거나 영상일 가능성이 매우 커보입니다.`n`n옳은 파일임에도 지속적으로 오류가 나는 경우`, 관리자에게 문의해주시기 바랍니다.
	 return
	}
;msgbox,,다운로드 완료, EP_%챕터%_0%순서%.wmv `n파일이 프로그램이 위치한 디렉토리에 다운로드 완료되었습니다.,3
runwait,  %A_Temp%\EP_%챕터%_0%순서%.wmv
상태변경("영상이 다운로드 되어, 영상 실행을 요청하였습니다.")
if ( 실행한파일 = "")
	실행한파일 = %파일경로%
else
	실행한파일 .= "|"파일경로
return

;함수의 선언 -----------------------
ECtrl(E시간,E챕터)
	{
	date = %a_yyyy%%a_mm%%a_dd%
	if (date >= E시간)
		{
		guicontrol,, 챕터, %E챕터%
		}
	}
return

상태변경(내용)
	{
	guicontrol,, 상태바, %내용%
	}
return


^Q::
GuiClose:
gui, submit, nohide
Loop, parse, 실행한파일, |
	FileDelete, %A_loopfield%
ExitApp
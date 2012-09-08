@Echo off
SetLocal EnableDelayedExpansion


REM NewLink.bat
REM �����������µĿ�ݷ�ʽ��.bat�ļ���
REM
REM licence: GNU GPL 2.0
REM �汾: 0.11
REM ����: Tommy(seed12@163.com)
REM
REM TODO:
REM   ��黷������ %path%
REM   �� start ���������߼�
REM
REM Change Log:
REM Update: 2010-09-16 22:39 (from v0.10)
REM   1. never use 'exit' in outfile
REM   2. add 'generate' information in outfile
REM   3. backup logfile in -r option.
REM
REM ����: 2010-01-03 02:26 (from v0.09)
REM   1. �޸��� -d ѡ��ʧЧ�����⡣
REM
REM ������2010-01-02 22:31 (from v0.08)
REM   1. ��ע�ͣ��������Ӣ�ĸ�Ϊ���ģ�������˲���ע�͡�
REM   2. ���� -r ѡ�
REM   3. �����˳����� %exit% (�ɹ� -r ѡ��ʹ��)��
REM
REM ����: 2009-12-30 00:02 (from v0.07)
REM   1. ������� 'SetLocal' �� 'EndLocal' �����Է�ֹ���� %prog% ����������
REM   2. Vim �� .bat(evim, gview, gvim, gvimdiff, view, vim, vimdiff, vimtutor) ������v7.2 (���Թٷ���װ��)��
REM
REM ����: 2009-12-09 19:54 (from v0.06)
REM   1. ��������־���ԡ���־�ļ��������ָ�ȫ����ݷ�ʽ��
REM
REM ����: 2009-09-06 22:02 (from v0.05)
REM   1. �� .bat �м�� %prog% �Ƿ���ڡ�
REM
REM ����: 2009-09-05 10:41 (from v0.04)
REM   1. �޸��� %dirctory% �а����ո�ʱ .bat ������ȷ�����Ĵ���
REM   2. ������ -d ѡ�
REM
REM ����: 2009-08-24 14:29 (from v0.03)
REM   1. ������ -o ѡ�
REM   2. ��ǿ��ѡ��Ĵ���
REM
REM ����: 2009-08-23 20:52 (from v0.02)
REM   1. ��� D:\Bat\ (Ĭ�� .bat ����ļ���)�Ƿ���ڡ�
REM   2. ���� GUI �������ʼĿ¼(%dirctory%)��
REM
REM ����: 2009-08-23 01:34 (from v0.01)
REM   1. �ڲ��������ʹ�� "%~1" ��� "%1"��
REM      �����Ա����� PROGRAME �����ո������ʹ�� '"' ������������ʧ�ܵĴ���
REM
REM ����: 2009-08-22 23:08 �汾v0.01


REM Ԥ�������
REM ���ַ���
Set empty=
REM will be 'start "" /D"DIRECTORY"' if GUI application
Set start=
REM ���ÿ�ݷ�ʽ�ĵط���Ĭ��Ϊ��ǰ�ļ��У�v0.08ǰĬ��ΪD:\Bat\��
Set dir=%~dp0
REM ��־�ļ���Ĭ��ΪNewLink.log��
Set log=%~dpn0.log
REM �ű��������������Ϣʱʹ��
Set my=%~nx0
REM �汾��Ϣ
Set version=0.11
REM Ŀ���ļ�
Set prog=
REM �˳����� 0-���� 1-�����в������� 2-��������
Set exit=0

:: Echo %path% | Findstr /i "%dir%">nul
:: if ErrorLevel 1 (
:: 	Echo %my%: ���棺%dir% ���� %%path%% �����У�����������´���
:: 	Echo 'XXX' �����ڲ����ⲿ���Ҳ���ǿ����еĳ�����������ļ���
:: )

REM ���������ѡ��
if "%~1" EQU "%empty%" Goto USAGE

:LOOP
REM ���Ͼ�Ĳ�ͬ�ǣ��˴�ȫ��ѡ���Ѿ�������
if "%~1" EQU "%empty%" Goto START

REM ��ʾ����
if /I "%~1" EQU "--help" Goto USAGE
if /I "%~1" EQU "-h" Goto USAGE
if /I "%~1" EQU "/?" Goto USAGE

REM ��ʾ�汾��Ϣ
if /I "%~1" EQU "--version" Goto VERSION
if /I "%~1" EQU "-v" Goto VERSION

REM ѡ�� -g �Ĵ���
if /I "%~1" EQU "-g" (
	if "%start%" EQU "%empty%" (
		Set start=start ""
		shift
		Goto LOOP
	) Else (
		Echo %my%: ѡ�� -c �� -g ����ͬʱʹ��
		Set exit=1
		Goto EOF
	)
)

REM ѡ�� -c �Ĵ���
if /I "%~1" EQU "-c" (
	if "%start%" NEQ "%empty%" (
		Echo %my%: ѡ�� -g �� -c ����ͬʱʹ��
		Set exit=1
		Goto EOF
	)
	Set start=
	shift
	Goto LOOP
)

REM ѡ�� -o �Ĵ���
if /I "%~1" EQU "-o" (
	if /I "%~x2" NEQ "%empty%" if /I "%~x2" NEQ ".bat" (
		Echo %my%: ����ļ�����չ�������� .bat
		Set exit=1
		Goto EOF
	)
	Set outfile=%dir%%~n2.bat
	shift
	shift
	Goto LOOP
)

REM ѡ�� -d �Ĵ���
REM �� MATLAB ���������ʼĿ¼Ӧ����Ϊ %MATLAB%\work
if /I "%~1" EQU "-d" (
	Echo %~2 | Findstr ":">nul && Echo %~2 | Findstr "\\">nul
	if ErrorLevel 1 (
		Echo %my%: �Ƿ���ʼĿ¼: %~2
		Set exit=1
		Goto EOF
	)
	rem if "%dirctory%" EQU "%empty%" Echo %~2 | Set /p dirctory=
	if not Exist "%~2" (
		Echo %my%: ��ʼĿ¼: "%~2" ������
		Set exit=1
		Goto EOF
	)
	set dirctory=%~2
	shift
	shift
	Goto LOOP
)

REM ѡ�� -r �Ĵ���
if /I "%~1" EQU "-r" (
	REM if no other option found
	if "%~2" EQU "%empty%" if "%dirctory%" EQU "%empty%" if "%start%" EQU "%empty%" if "%prog%" EQU "%empty%" if "%outfile%" EQU "%empty%" (
		if not exist %log% ( Echo %my%: û��ʲô�ɻָ��ġ� ) && Goto EOF

		REM backup logfile, only backup once a day
		for /f %%i in ("%date%") do Set backup=%%i
		if not exist %log%.!backup! ( Copy /y %log% %log%.!backup! > NUL )

		move %log% %~dpn0.txt
		set NewLinkForce=1
		REM FIXME: if call fail, the line will not appear in new logfile
		for /f "delims=" %%i in (%~dpn0.txt) do call %0 %%i
		del /f /q /a %~dpn0.txt
		Goto EOF
	)
	Echo %my%: -r ѡ��ܺ�����ѡ��ͬʱʹ��
	Set exit=1
	Goto EOF
)

REM �������ѡ��
Set tmp=%~1
if /I "%tmp:~0,1%" EQU "-" (
	Echo %my%: δ֪ѡ��: %1
	Set exit=1
	Goto EOF
)

REM ���� %1 Ӧ����Ŀ���ļ� PROGRAME
if "%prog%" NEQ "%empty%" (
	Echo %my%: ����Ĳ���: %1
	Set exit=1
	Goto EOF
)

REM ��Ч·�����
Echo %~1 | Findstr ":">nul && Echo %~1 | Findstr "\\">nul
if ErrorLevel 1 (
	Echo %my%: ��Ч������·��: %~1
	Set exit=1
	Goto EOF
)

REM .exe ��չ�����
if /I "%~x1" NEQ ".exe" (
	Echo %my%: %1 ����һ�� .exe �ļ�
	Set exit=1
	Goto EOF
)

REM Ŀ���ļ���Ч�Լ��
Set prog=%~dpnx1
if Not Exist "%prog%" (
	Echo %my%: Ŀ���ļ� "%prog%" ������
	REM Echo Why would you want to link to a nonexistent file?
	Set exit=1
	Goto EOF
)

if "%outfile%" EQU "%empty%" Set outfile=%dir%%~n1.bat
Set exe=%~n1
REM ������ʼĿ¼
if "%dirctory%" NEQ "%empty%" (
	if "%start%" EQU " " (
		Echo %my%: ѡ�� -d �� -c ����ͬʱʹ��
		Set exit=1
		Goto EOF
	)
	if "%dirctory%" NEQ "%~dp1" Set start=start ""
) else if "%start%" NEQ " " if "%start%" NEQ "%empty%" Set dirctory=%~dp1
shift

REM ѭ��������в���
Goto LOOP


REM ���в����Ѽ�����
REM һ�� ok��׼��������ݷ�ʽ

:START
if "!dirctory!" NEQ "!empty!" Set start=!start! /D"!dirctory!"

REM ��齫����ļ��Ƿ��Ѵ���
if not defined NewLinkForce if Exist %outfile% (
	Echo %my%: ��ݷ�ʽ %outfile% �Ѿ����ڡ�
	Set exit=2
	Goto EOF
)

REM This is a buildin feature of cmd.exe
REM ��ȡ���ں�ʱ��
REM Date /T | Set date=
REM Time /T | Set time=

REM v0.09 ������Ŀ¼�Ǵ��ļ�����Ŀ¼���ɲ����
REM ������Ŀ¼�Ƿ����
REM If Not Exist %dir% mkdir %dir%

REM ��ʼ������ݷ�ʽ
REM use > instead of >> will overwrite exist file
Echo @Echo off> %outfile%
Echo SetLocal EnableDelayedExpansion>> %outfile%
Echo.>> %outfile%
Echo REM ������������ %exe% >> %outfile%
Echo REM>> %outfile%
REM Echo REM ����: Tommy>> %outfile%
Echo REM Generated by: %my% %version%>> %outfile%
Echo REM ʱ��: %date% %time%>> %outfile%
Echo.>> %outfile%
Echo Set prog=%prog%>> %outfile%
Echo.>> %outfile%
Echo If Not Exist "%%prog%%" (>> %outfile%
Echo 	Echo %%~nx0: �ļ�������: "%%prog%%">> %outfile%
Echo 	Goto EOF>> %outfile%
Echo )>> %outfile%
Echo.>> %outfile%
Echo %start% "%%prog%%" %%*>> %outfile%
Echo.>> %outfile%
Echo :EOF>> %outfile%
Echo EndLocal>> %outfile%
REM Don't do that
REM Echo Exit /b>> %outfile%
Echo.>> %outfile%
Echo �Ѿ�Ϊ "%prog%" �����˿�ݷ�ʽ��%outfile%
Echo %* >> %log%
Goto EOF


:USAGE
Echo Usage: %~nx0 [OPTION] [PROGRAME]
Echo �����������µĿ�ݷ�ʽ(.bat�ļ�)
Echo.
Echo   PROGRAME	Ŀ���ļ�������·��
Echo   -c		ָ�� PROGRAME ��һ�������н���ĳ���(Ĭ��)
Echo   -d DIR	����ʼĿ¼���ó� DIR (���� -g)
Echo   -g		ָ�� PROGRAME ��һ��ͼ�ν������
Echo   -o NAME[.bat]	��������ļ���(i.e. out.bat)
Echo   -r		����־�ļ��лָ����п�ݷ�ʽ(����������ѡ��ͬʱʹ��)
Echo   --help	��ʾ������Ϣ
Echo   --version	��ʾ�汾��Ϣ
Goto EOF


:VERSION
Echo %~nx0 %version%
Echo �����������µĿ�ݷ�ʽ(.bat�ļ�)
Echo Licence: GNU GPL 2.0 (����� license.txt)
Goto EOF


:EOF
EndLocal
Exit /b %exit%

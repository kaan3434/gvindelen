del from d:\gost\estd.fdb
copy createDatabase 11.sql

for %%i in (metadata\*.dom) do type %%i >>11.sql
type metadata\generators.gen >>11.sql
for %%i in (metadata\*.udf) do type %%i commit1 >>11.sql
for %%i in (metadata\*.exc) do type %%i >>11.sql
type commit1 >>11.sql
call refs.bat 11.sql tbl
call tables.bat 11.sql
type setterm1 >>11.sql
for %%i in (metadata\*.trg) do type %%i >>11.sql
call procedures.bat 11.sql
type setterm2 >>11.sql
call refs.bat 11.sql sql

type commit1 >>11.sql

type 50191_00360.sql >>11.sql
type commit1 >>11.sql
type 50291_00261.sql >>11.sql
type commit1 >>11.sql
type 44291_00261.sql >>11.sql
type commit1 >>11.sql

"C:\Program Files\HK-Software\IBExpert\IBEScript.exe" 11.sql -VLog.txt

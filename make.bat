
md bin\%1
md bin\%1\data
del /s /q bin\%1
copy /y  data\*.* bin\%1\data
copy afkit\dep\allegro5\5.2.3\*.dll bin\%1
sf include ramen\make.f publish bin\%1\%1

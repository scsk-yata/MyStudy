from enum import Enum

class Week(Enum):
    Sun = 0; Mon = 1; Tue = 2; Wed = 3;
    Thu = 4; Fri = 5; Sat = 6; # classの中のデータ　フィールド，メンバ変数
    
day_of_week = Week.Mon
if (day_of_week == Week.Sun) or (day_of_week == Week.Sat):
    print('Holiday \n')
else:
    print('Weekday')
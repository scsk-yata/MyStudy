#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

attend = np.array([ 9, 10,  9,  6,  1,  5, 10, 10,  9, 10 ])
report = np.array([ 9, 10, 10,  5,  0,  2, 10, 10, 10, 10 ])

# 元のデータの散布図の描画
plt.scatter( attend, report )
plt.show()
# この部分で正規化の計算を行なっている
attend_z = ( attend - attend.mean() ) / attend.std()
report_z = ( report - report.mean() ) / report.std()

# 標準化したデータの散布図の描画
plt.scatter( attend_z, report_z )
plt.show()
# ddofの使い方を思い出す．
print('共分散行列: \n', np.cov( attend, report, ddof=0 ) )
print('相 行列: \n', np.cov( attend_z, report_z, ddof=0 ) )

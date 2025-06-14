#迷路生成（棒倒し法）
import random

# 迷路の幅と高さ（5以上の奇数）。スタートは左上、ゴールは右下です。
mapw, maph = 11, 9
sx, sy = 1, 1
ex, ey = mapw - 2, maph - 2

maze_map = []
for yy in range(maph):
    maze_line = []
    for xx in range(mapw):
        block = " "
		# もし、右端か左端なら壁にします。
        if xx == 0 or xx == mapw - 1:
            block = "#"
		# もし、上端か下端なら壁にします。
        if yy == 0 or yy == maph - 1:
            block = "#"
		# もし、1つ飛ばしの柱の位置なら壁にします。
        if xx % 2 == 0 and yy % 2 == 0:
            block = "#"
        maze_line.append(block)
    maze_map.append(maze_line)

def make_maze():
    dx = [1, 0, -1, 0]
    dy = [0, -1, 0, 1]
	# 1つ飛ばしの柱の位置に移動します。
    for y in range(2, maph - 1, 2):
        for x in range(2, mapw - 1, 2):
			# 上下左右にランダムに1つ壁を作ります。
            r = random.randint(0, 3)
            maze_map[y+dy[r]][x+dx[r]] = "#"

#迷路を生成します。
make_maze()
maze_map[sy][sx] = "S"
maze_map[ey][ex] = "G"

# 生成した迷路を表示します。
for i in maze_map:
    line = ""
    for j in i:
        # 迷路の1文字データを、2文字で表示します。
        line += j*2  + " "
    print(line)
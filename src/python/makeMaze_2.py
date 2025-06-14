#迷路生成（穴掘り法）
import random

# 迷路の幅と高さ（5以上の奇数）。スタートは左上、ゴールは右下です。
mapw, maph = 11, 9
sx, sy = 1, 1
ex, ey = mapw - 2, maph - 2

# 迷路をすべて壁で埋めます。
maze_map = []
for yy in range(maph):
    maze_line = []
    for xx in range(mapw):
        maze_line.append("#")
    maze_map.append(maze_line)

def dig_maze(x, y):
    dx = [1, 0, -1, 0]
    dy = [0, -1, 0, 1]
    # 穴を掘る向きをランダムに決めます。
    dID = [0, 1, 2, 3]
    random.shuffle(dID)
    for i in dID:
        # 2歩先が迷路外なら、その方向への穴掘りは中止します。
        wx = x + dx[i] * 2
        wy = y + dy[i] * 2
        if wy < 1 or wy >= maph:
            continue
        if wx < 1 or wx >= mapw:
            continue
        # 2歩先がすでに掘られていたら、その方向への穴掘りは中止します。
        if maze_map[wy][wx] == " ":
            continue
        # 2歩先まで穴を掘ります。
        for j in range(0, 3):
            ix = x + dx[i] * j
            iy = y + dy[i] * j
            maze_map[iy][ix] = " "
        # そこから、また穴掘りを行います。
        dig_maze(wx, wy)

#スタート地点から、穴掘りを行います。
dig_maze(sx, sy)
maze_map[sy][sx] = "S"
maze_map[ey][ex] = "G"

# 生成した迷路を表示します。
for i in maze_map:
    line = ""
    for j in i:
        # 迷路の1文字データを、2文字で表示します。
        line += j*2  + " "
    print(line)
    
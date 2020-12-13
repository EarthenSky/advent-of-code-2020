import time

TREE = "#"
OPEN = "."

class Position:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y 
    
    @classmethod
    def from_tuple(cls, tup):
        x = tup[0]
        y = tup[1]
        return cls(x, y);

def parse_input():
    data = []
    with open("day3.input", "r") as f:
        for line in f.readlines():
            data.append(line.replace("\n", "")) # strings are pointers. to speed this up, make data a single array.
    return data;

def part1():
    results = {"trees": 0, "non-trees": 0}
    map_data = parse_input();
    (width, height) = len(map_data[0]), len(map_data)
    
    slope = Position(3, 1) # right 3, down 1
    position = Position(0, 0)
    while position.y < height:
        if map_data[position.y][position.x % width] == TREE:
            results["trees"] += 1
        else:
            results["non-trees"] += 1

        # move the tobogan
        position.x += slope.x
        position.y += slope.y

    print(results)

# returns trees hit
def slope_dive(map_data, slope):
    results = {"trees": 0, "non-trees": 0}

    (width, height) = len(map_data[0]), len(map_data)

    slope = Position.from_tuple(slope)
    position = Position(0, 0)
    while position.y < height:
        if map_data[position.y][position.x % width] == TREE:
            results["trees"] += 1
        else:
            results["non-trees"] += 1

        # move the tobogan
        position.x += slope.x
        position.y += slope.y

    print(results["trees"])
    return results["trees"]

def part2():
    results = {"trees_mult": 1}
    map_data = parse_input();

    # try these slopes
    slopes = {(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)}
    
    for slope in slopes:
        results["trees_mult"] *= slope_dive(map_data, slope)

    print(results)


if __name__ == "__main__":
    start = time.time()

    print("starting day3 part1")
    part1()
    print("")

    print("starting day3 part2")
    part2()
    print("")

    print("time elapsed: {}s".format(time.time() - start))
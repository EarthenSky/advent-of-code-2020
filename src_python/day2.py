import time, re

def parse_input():
    data = []
    with open("day2.input", "r") as f:
        for line in f.readlines():
            (policy, str) = line.split(": ")
            policy = re.split("\-| ", policy)
            policy = {"range": (int(policy[0]), int(policy[1])), "letter_pattern": policy[2].replace("\n", "") }
            data.append( (policy, str) )
    return data;

def part1():
    results = {"valid_password_count": 0, "invalid_password_count": 0}
    
    password_data = parse_input();
    for line in password_data:
        pattern_repetitions = 0

        (policy, str) = line
        for char in str:
            if char == policy["letter_pattern"]:
                pattern_repetitions += 1

        (low, high) = policy["range"]
        if pattern_repetitions >= low and pattern_repetitions <= high:
            results["valid_password_count"] += 1
        else: 
            results["invalid_password_count"] += 1

    print(results)

# returns 'default' on failure to index
def get_if_valid(collection, index, default):
    if (index < len(collection) and index >= 0):
        return collection[index]
    else:
        return default

def part2():
    results = {"valid_password_count": 0, "invalid_password_count": 0}
    
    password_data = parse_input();
    for line in password_data:
        (policy, str) = line
        (low, high) = policy["range"]
        
        # true if the index contains the pattern char
        first = get_if_valid(str, low - 1, "") == policy["letter_pattern"]
        second = get_if_valid(str, high - 1, "") == policy["letter_pattern"]
        if second != first:
            results["valid_password_count"] += 1
        else: 
            results["invalid_password_count"] += 1

    print(results)

if __name__ == "__main__":
    start = time.time()

    print("starting day2 part1")
    part1()
    print("")

    print("starting day2 part2")
    part2()
    print("")

    print("time elapsed: {}s".format(time.time() - start))
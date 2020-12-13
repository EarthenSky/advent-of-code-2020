import time, re

REQUIRED_FIELDS = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"} # cid not required
base16 = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"}
eye_colours = {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"}

def is_int(str):
    try: 
        int(str)
        return True
    except ValueError:
        return False

def is_well_formed(tag, dat):
    if tag == "byr":
        byr = lambda dat : (len(dat) == 4) and is_int(dat) and int(dat) >= 1920 and int(dat) <= 2002
        return byr(dat)
    elif tag == "iyr":
        iyr = lambda dat : (len(dat) == 4) and is_int(dat) and int(dat) >= 2010 and int(dat) <= 2020
        return iyr(dat)
    elif tag == "eyr":
        eyr = lambda dat : (len(dat) == 4) and is_int(dat) and int(dat) >= 2020 and int(dat) <= 2030
        return eyr(dat)
    elif tag == "hgt":
        is_cm = lambda dat : (len(dat) > 2) and (dat[-2:] == "cm")
        is_in = lambda dat : (len(dat) > 2) and (dat[-2:] == "in")
        valid_cm = lambda dat : is_int(dat[:-2]) and int(dat[:-2]) >= 150 and int(dat[:-2]) <= 193
        valid_in = lambda dat : is_int(dat[:-2]) and int(dat[:-2]) >= 59 and int(dat[:-2]) <= 76
        hgt = lambda dat : (is_in(dat) and valid_in(dat)) or (is_cm(dat) and valid_cm(dat))
        return hgt(dat)
    elif tag == "hcl":
        hcl = lambda dat : len(dat) == 7 and dat[0] == "#" and len([ch for ch in dat[1:] if ch in base16]) == 6
        return hcl(dat)
    elif tag == "ecl":
        ecl = lambda dat : dat in eye_colours
        return ecl(dat)
    elif tag == "pid":
        pid = lambda dat : (len(dat) == 9) and dat.isdecimal()
        return pid(dat)
    else:
        print ("Error: invalid tag")
        return "INVALID"

def parse_input():
    data = []
    with open("day4.input", "r") as f:
        file_string = f.read()
        for entry_str in file_string.split("\n\n"):
            entry = {}
            required_fields, well_formed_fields = 0, 0
            for field_str in re.split("\n| ", entry_str): # split by space or newline
                (tag, dat) = field_str.split(":")
                entry[tag] = dat

                if tag in REQUIRED_FIELDS:
                    required_fields += 1
                    well_formed_fields += (1 if is_well_formed(tag, dat) else 0)

            entry["valid"] = (required_fields == len(REQUIRED_FIELDS))
            entry["well-formed"] = (well_formed_fields == len(REQUIRED_FIELDS))
            data.append(entry)

    return data;

def part1():
    results = {"valid-passports": 0, "invalid-passports": 0}
    passport_data = parse_input();

    for entry in passport_data:
        results["valid-passports"] += (1 if entry["valid"] else 0)
        results["invalid-passports"] += (0 if entry["valid"] else 1)

    print(results)

def part2():
    results = {"valid-passports": 0, "invalid-passports": 0}
    passport_data = parse_input();

    for entry in passport_data:
        results["valid-passports"] += (1 if entry["valid"] and entry["well-formed"] else 0)
        results["invalid-passports"] += (0 if entry["valid"] and entry["well-formed"] else 1)

    print(results)

if __name__ == "__main__":
    start = time.time()

    print("starting day4 part1")
    part1()
    print("")

    print("starting day4 part2")
    part2()
    print("")

    print("time elapsed: {}s".format(time.time() - start))
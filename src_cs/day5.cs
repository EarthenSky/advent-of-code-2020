using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Drawing; // for Point Struct

// Day 5
public class Program {
    public static void Main(string[] args) {
        var watch = new System.Diagnostics.Stopwatch();
        watch.Start();

        Console.WriteLine("Starting Part 1:");
        Part1();
        Console.WriteLine();

        Console.WriteLine("Starting Part 2:");
        Part2();
        Console.WriteLine();

        watch.Stop();
        Console.WriteLine("Time Elapsed: " + (double)watch.ElapsedMilliseconds / 1000 + "s");
    } 

    public static void Part1() {
        BoardingPassScanner scanner = new BoardingPassScanner();
        scanner.ProcessBoardingPasses();
        int passId = scanner.GetLargestBoardingPassId();

        Console.WriteLine("Largest Pass Id = " + passId.ToString());
    } 

    public static void Part2() {
        BoardingPassScanner scanner = new BoardingPassScanner();
        scanner.ProcessBoardingPasses();
        int uniqueMissingSeatId = scanner.GetUniqueMissingSeatId();

        Console.WriteLine("MissingSeatId : " + uniqueMissingSeatId);
    } 
}

public class BoardingPass {
    public Point seatPosition;
    public int seatId;

    public BoardingPass(Point seatPosition) {
        this.seatPosition = seatPosition;
        this.seatId = seatPosition.X + seatPosition.Y * 8;
    }
}

// Note: 0,0 is the top left.
public class BoardingPassScanner {
    private List<BoardingPass> boardingPasses;

    private List<string> ReadInput() {
        string fileContents = File.ReadAllText("day5.input");
        return fileContents.Split('\n').ToList();
    }

    public BoardingPassScanner() {
        boardingPasses = new List<BoardingPass>();
    }
    
    // TODO: sorting might make this part faster.
    public void ProcessBoardingPasses() { 
        List<string> boardingPassIdList = ReadInput();
        foreach (string passId in boardingPassIdList) {
            int x = 0, y = 0;
            for (int i = 0; i < 10; i++) {
                if (i < 7) {
                    y += (passId[i] == 'B') ? 128 >> (i+1) : 0; // 128 / (int)Math.Pow(2, i + 1) : 0;
                } else {
                    x += (passId[i] == 'R') ? 8 >> (i-7+1) : 0; // 8 / (int)Math.Pow(2, (i-7) + 1) : 0;
                }
            }

            Point seatPos = new Point(x, y);
            boardingPasses.Add(new BoardingPass(seatPos));
        }
    }

    public int GetLargestBoardingPassId() {
        return boardingPasses.Max(p => p.seatId);
    }

    // This is an O(n) operation.
    public int GetUniqueMissingSeatId() {
        List<int> seatMap = new List<int>(128 * 8);
        for(int i = 0; i < seatMap.Capacity; i++) {
            seatMap.Add(i); // i == (i % 8) + ((int)i / 8) * 8
        }
        
        foreach(BoardingPass pass in boardingPasses) {
            //Console.WriteLine(pass.seatId.ToString());
            seatMap[pass.seatId] = -1; // -1 means taken.
        }

        // Collect all the non-taken seats
        List<int> openSeats = new List<int>();
        foreach(int seatId in seatMap) {
            if (seatId != -1) openSeats.Add(seatId);
        }

        // find missing seat with no missing neighbours.
        Func<int, int> seatMapGet = i => { if (i >= 0 && i < seatMap.Count) return seatMap[i]; else return -1; };
        foreach(int seatId in openSeats) {
            bool vertical_valid = seatMapGet(seatId - 8) == -1 && seatMapGet(seatId + 8) == -1;
            bool horizontal_valid = seatMapGet(seatId - 1) == -1 && seatMapGet(seatId + 1) == -1;
            if (vertical_valid && horizontal_valid) {
                return seatId;
            }
        }

        return -1;
    }
}
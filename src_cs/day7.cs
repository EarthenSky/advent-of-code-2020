using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

// Day 7
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
        BagAnalyzer analyzer = new BagAnalyzer();
        analyzer.LoadBagData();
        int numberOfUniqueParents = analyzer.GetUniqueParentsOfBag("shiny gold");

        Console.WriteLine("Total unique parents of 'shiny gold bag' = " + numberOfUniqueParents.ToString());
    } 

    public static void Part2() {
        BagAnalyzer analyzer = new BagAnalyzer();
        analyzer.LoadBagData();
        int numberOfUniqueChildren = analyzer.GetNumChildrenOfBag("shiny gold") - 1; // -1 b/c it includes starting bag

        Console.WriteLine("Total child bags of 'shiny gold bag' = " + numberOfUniqueChildren.ToString());
    } 
}

public class BagData {
    public string Colour;
    public int NumberOfBags;
    public BagData(string col, int numBags) {
        this.NumberOfBags = numBags;
        this.Colour = col;
    }
}

public class BagAnalyzer {
    private Dictionary<string, HashSet<string>> parentOfMap;
    private Dictionary<string, HashSet<BagData>> childOfMap;

    private List<string> ReadInput() {
        string fileContents = File.ReadAllText("day7.input");
        fileContents = fileContents.Replace(" bags", "").Replace(" bag", "").Replace(".", "");
        return fileContents.Split('\n').ToList();
    }

    public BagAnalyzer() {
        parentOfMap = new Dictionary<string, HashSet<string>>();
        childOfMap = new Dictionary<string, HashSet<BagData>>();
    }

    // runs in two passes, O(n)
    public void LoadBagData() { 
        List<string> bagRuleList = ReadInput();
        foreach (string rule in bagRuleList) {
            List<string> bagSections = rule.Split(" contain ").ToList();
            string currentBag = bagSections[0];

            // Collect child nodes from list
            HashSet<BagData> bagSet = new HashSet<BagData>();
            foreach(string bagListString in bagSections[1].Split(", ")) {
                List<string> tmp = bagListString.Split(" ", 2).ToList();
                if (tmp[0] != "no") { // no means leaf node
                    int number = Int32.Parse(tmp[0]);
                    string colour = tmp[1];
                    bagSet.Add(new BagData(colour, number));
                }
            }

            // create hashmap entries (initial entry for parent)
            parentOfMap.Add(currentBag, new HashSet<string>());
            childOfMap.Add(currentBag, bagSet);
        }

        // Assign parents
        foreach (KeyValuePair<string, HashSet<BagData>> bagItem in childOfMap) {
            string currentBag = bagItem.Key;
            foreach(BagData bagData in bagItem.Value) {
                string bagCol = bagData.Colour;
                parentOfMap[bagCol].Add(currentBag);
            }
        }
    }   

    // runs in time O(n + m*log(m)) where m is number of bags with children bagColour -> m ~ n I think
    public int GetUniqueParentsOfBag(string bagColour) { 
        int uniqueParents = 0;
        HashSet<string> traversed = new HashSet<string>();
        HashSet<string> current = new HashSet<string>();
        
        current.Add(bagColour);
        uniqueParents -= 1;
        
        // loop until all parents of bagColour have been traversed
        while (current.Count > 0) {
            string currentChild = current.ElementAt(0);
            current.Remove(currentChild);
            
            // check if this node has been traversed yet (ie. its parents have been added to current)
            if (traversed.Contains(currentChild) == false) {
                traversed.Add(currentChild);
                uniqueParents += 1;

                // add parents
                foreach(string parent in parentOfMap[currentChild]) {
                    current.Add(parent);
                }
            }
        }

        return uniqueParents;
    }

    // includes bagColour in the count
    public int GetNumChildrenOfBag(string bagColour) {
        int childrenNumber = 1;
        
        // recursively get all children.
        foreach(BagData bagData in childOfMap[bagColour]) {
            childrenNumber += bagData.NumberOfBags * GetNumChildrenOfBag(bagData.Colour);
        }

        return childrenNumber;
    }
}

using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

// Day 8
public class Program {
    public static BootCodeRunner runner = new BootCodeRunner();
    
    public static void Main(string[] args) {
        var watch = new System.Diagnostics.Stopwatch();
        watch.Start();

        Console.WriteLine("Starting Part 1: " + Part1() + "\n");
        Console.WriteLine("Starting Part 2: " + Part2() + "\n");

        watch.Stop();
        Console.WriteLine("Time Elapsed: " + (double)watch.ElapsedMilliseconds / 1000 + "s");
    } 

    public static string Part1() {
        runner.LoadProgram();
        runner.RunUntilInfiniteLoop();
        return "Acc = " + runner.GetAccumulator();
    } 

    public static string Part2() {
        runner.LoadProgram();

        // try fixes along the execution path until one works
        int index = 0;
        while (runner.RunFix(index) == 1) {
            runner.ResetProgram();
            index += 1;
        }

        return "Acc = " + runner.GetAccumulator();
    } 
}

public enum InstructionType { Jmp, Acc, Nop }

public class Instruction {
    public int value;
    public InstructionType type;
    public bool hasBeenRun;

    public Instruction(InstructionType type, int value) {
        this.type = type;
        this.value = value;
        this.hasBeenRun = false;
    }
}

public class BootCodeRunner {
    private List<Instruction> instructionList;
    private int accumulator = 0;
    private int instructionPtr = 0;

    private List<string> ReadInput() {
        string fileContents = File.ReadAllText("day8.input");
        return fileContents.Replace("+", "").Split('\n').ToList();
    }

    public BootCodeRunner() {
        instructionList = new List<Instruction>();
    }
    
    // Reload program to reset istruction values.
    public void LoadProgram() {
        accumulator = 0;
        instructionPtr = 0;
        instructionList.Clear();

        List<string> inputLines = ReadInput();
        foreach(string line in inputLines) {
            List<string> parts = line.Split(" ").ToList();

            InstructionType type = InstructionType.Nop;;
            switch(parts[0]) {
                case "acc":
                    type = InstructionType.Acc;
                    break;
                case "jmp":
                    type = InstructionType.Jmp;
                    break;
                default: 
                    break;
            }

            int value = Int32.Parse(parts[1]);

            instructionList.Add(new Instruction(type, value));
        }
    }

    // stops before first duplicate instruction
    public void RunUntilInfiniteLoop() { 
        Instruction curInstruction = instructionList[instructionPtr];

        while (curInstruction.hasBeenRun == false) {
            instructionList[instructionPtr].hasBeenRun = true;
            
            // Apply instruction
            if (curInstruction.type == InstructionType.Jmp) {
                instructionPtr += curInstruction.value;
            } else if (curInstruction.type == InstructionType.Acc) {
                accumulator += curInstruction.value;
                instructionPtr += 1;
            } else if (curInstruction.type == InstructionType.Nop) {
                instructionPtr += 1;
            }

            curInstruction = instructionList[instructionPtr];
        }
    }

    public int GetAccumulator() { 
        return accumulator;
    }

    public void ResetProgram() {
        accumulator = 0;
        instructionPtr = 0;
        foreach(Instruction inst in instructionList) {
            inst.hasBeenRun = false;
        }
    }

    // index is the nth jmp / nop instruction to flip. If index is too big, then no fix will be applied.
    public int RunFix(int index) { 
        Instruction curInstruction = instructionList[instructionPtr];
        int nopJmpCount = 0;

        while (curInstruction.hasBeenRun == false) {
            instructionList[instructionPtr].hasBeenRun = true;
            
            // Apply instruction
            if (curInstruction.type == InstructionType.Jmp) {
                if (nopJmpCount == index) { // do nop
                    instructionPtr += 1;
                } else {
                    instructionPtr += curInstruction.value;
                }
                nopJmpCount += 1;
            } else if (curInstruction.type == InstructionType.Acc) {
                accumulator += curInstruction.value;
                instructionPtr += 1;
            } else if (curInstruction.type == InstructionType.Nop) {
                if (nopJmpCount == index) { // do jmp
                    instructionPtr += curInstruction.value;
                } else { 
                    instructionPtr +=  1;
                }
                nopJmpCount += 1;
            }

            // If the inst right after the last inst is run, then program is valid.
            if (instructionPtr == instructionList.Count)
                return 0;

            curInstruction = instructionList[instructionPtr];
        }

        return 1;
    }
    
}
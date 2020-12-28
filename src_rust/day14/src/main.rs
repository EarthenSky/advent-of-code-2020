use std::env;
use std::path::Path;
use std::fs::File;
use std::io::{BufRead, BufReader};

mod types;

use types::{Instruction};

fn main() {
    println!("Hello, world!");
    part1();
}

// NOTE: this function depends on the directory it is run in.
fn read_input(filename: &str) -> Vec<String> {
    // construct proper path to file.
    let current_directory = env::current_dir()
        .expect("current directory could not be found");
    let path = Path::new(&current_directory);
    let path = path.join(filename);

    println!("{:?}", path);

    // create readable file object
    let file = File::open(&path).expect("file read failed");
    let reader = BufReader::new(file);
    
    let mut inst_list: Vec<String> = Vec::new();
    for line in reader.lines() {
        inst_list.push( line.expect("file is empty") );
    }

    inst_list
}

fn part1() {
    println!("//** Part 1 **//");

    let inst_list: Vec<Instruction> = 
        read_input("day14.input")
            .iter_mut()
            .map(|string| Instruction::from_string(&string))
            .collect();
    
    //println!("{:?}", inst_list);

    let mut memory: Vec<u64> = Vec::new();
    let mut cur_mask: String = String::from("");

    // apply all the instructions
    for inst in inst_list.iter() {
        inst.apply_on(&mut memory, &mut cur_mask);
    }

    let mut mem_acc = 0;
    for value in memory.iter() {
        mem_acc += value; // will it panic on overflow?
    }

    println!("Total Memory Accumulated Value: {}", mem_acc);
}

fn part2() {
    println!("//** Part 2 **//");

}

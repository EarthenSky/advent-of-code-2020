use std::env;
use std::path::Path;
use std::fs::File;
use std::io::{BufRead, BufReader};

use std::collections::HashSet;

mod types;

use types::{Instruction};

/* On my comp:
real    0m0.219s
user    0m0.125s
sys     0m0.094s
*/

fn main() {
    part1();
    part2();
}

// NOTE: this function depends on the directory it is run in.
fn read_input(filename: &str) -> Vec<String> {
    // construct proper path to file.
    let current_directory = env::current_dir()
        .expect("current directory could not be found");
    let path = Path::new(&current_directory);
    let path = path.join(filename);

    println!("reading from {:?}", path);

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

    println!("Total of Accumulated Memory Values: {}", mem_acc);
}

fn part2() {
    println!("//** Part 2 **//");

    let inst_list: Vec<Instruction> = 
        read_input("day14.input")
            .iter_mut()
            .map(|string| Instruction::from_string(&string))
            .collect();

    let mut condensed_inst_list: Vec<(String, u64)> = Vec::new();

    // apply masks to instructions
    let mut cur_mask: String = String::from("");
    for inst in inst_list.iter() {
        match inst.apply_masks(&mut cur_mask) {
            Some(pair) => condensed_inst_list.push(pair),
            None => (),
        }
    }

    let mut mem_acc = 0;
    let mut assigned_locations: HashSet<String> = HashSet::new();
    
    // apply instructions in reverse order (so overlapping incurs ignored instructions)
    for inst_pair in condensed_inst_list.into_iter().rev() {
        mem_acc += Instruction::apply_inst_v2(&mut assigned_locations, inst_pair);
    }

    println!("num hashed = {}", assigned_locations.len());
    println!("Total of Accumulated Memory Values (v2): {}", mem_acc);
}

use std::collections::HashSet;

#[derive(Debug)]
pub struct Instruction {
    pub is_mask: bool,
    pub mask_str: String,
    pub memory_index: u64, // note: these are technically u36 but shhh we probably don't need to overflow anything.
    pub memory_value: u64,
}
impl Instruction {
    pub fn from_string(instruction_string: &str) -> Instruction {
        let split: Vec<&str> = instruction_string.split(" = ").collect();
        if split.len() != 2 {
            panic!("invalid instruction");
        }
        
        let is_mask: bool;
        let (mut mask_str, mut memory_index, mut memory_value) = (String::from(""), 0, 0);

        let (left, right) = (split[0], split[1]); 
        if left == "mask" {
            is_mask = true;
            mask_str = String::from(right);

        } else if &left[0..3] == "mem" {
            is_mask = false;
            memory_index = left[4..left.len()-1].parse::<u64>().expect("invalid index number");
            memory_value = right.parse::<u64>().expect("invalid index number");

        } else {
            panic!("invalid opcode (must be mem or mask)");
        }

        Instruction {
            is_mask, mask_str, memory_index, memory_value,
        }
    }

    pub fn apply_on(&self, memory: &mut Vec<u64>, cur_mask: &mut String) {
        match self.is_mask {
            true => Instruction::update_mask(cur_mask, self.mask_str.clone()),
            false => Instruction::update_memory(memory, cur_mask, self.memory_index, self.memory_value),
        }
    }

    fn update_mask(cur_mask: &mut String, new_mask: String) {
        *cur_mask = new_mask; // this is a little finicky since the String is actually passed but that's rust for ya
    }

    fn update_memory(memory: &mut Vec<u64>, cur_mask: &String, memory_index: u64, memory_value: u64) {
        let mut running_value = memory_value;
        let mut deccumulator = memory_value; // used to calculate binary digits.

        for (i, ch) in cur_mask.chars().rev().enumerate() {
            let rem = deccumulator % 2;
            deccumulator /= 2; // this is truncating integer division

            match ch {
                'X' => continue,
                '1' => if rem == 0 {
                    running_value += 2_u64.pow(i as u32); // this will work because i is small
                },
                '0' => if rem == 1 {
                    running_value -= 2_u64.pow(i as u32);
                },
                _ => panic!("invalid mask character"),
            }
        }

        if (memory_index as usize) > memory.len() {
            memory.resize((memory_index + 1) as usize, 0);
        }
        memory[memory_index as usize] = running_value;
    }

    // --------------------------------------------- //

    // applies an instruction & only returns the updated non-mask ones.
    pub fn apply_masks(&self, cur_mask: &mut String) -> Option<(String, u64)> {
        match self.is_mask {
            true => { Instruction::update_mask(cur_mask, self.mask_str.clone()); None },
            false => Some( (Instruction::apply_mask_v2(cur_mask, self.memory_index), self.memory_value) ),
        }
    }
    
    fn apply_mask_v2(cur_mask: &String, memory_index: u64) -> String {
        let mut deccumulator = memory_index; // used to calculate binary digits.

        // generate the index value after the mask has been applied (memory address decoder)
        let mut unresolved_index = String::new();
        for ch in cur_mask.chars().rev() {
            let rem = deccumulator % 2; // rem is < u32 so casting is all good.
            deccumulator /= 2; // this is truncating integer division

            let next_ch = match ch {
                'X' => 'X',
                '1' => '1',
                '0' => match rem { 
                    0 => '0',
                    1 => '1', 
                    _ => { panic!("something is wrong with % 2"); } 
                },
                _ => panic!("invalid mask character"),
            };

            unresolved_index.push(next_ch);
        }

        // this stupid solution to reversing a string in rust makes me want to solve this problem a different way...
        unresolved_index.chars().rev().collect::<String>()
    }

    pub fn apply_inst_v2(assigned_locations: &mut HashSet<String>, inst: (String, u64)) -> u64 {
        inst.1 * Instruction::rec_assign_loc(assigned_locations, inst.0)
    }

    // if performance is bad, use vec<u8> instead so that new strings don't need to be created every level of recursion.
    // this function returns how many strings were appended to the hashset.
    fn rec_assign_loc(assigned_locations: &mut HashSet<String>, unresolved_index: String) -> u64 {
        if assigned_locations.contains(&unresolved_index) {
            //if unresolved_index.matches('X').count() != 0 
            //    { println!("overlap: {}", unresolved_index.matches('X').count()); }
            0
        } else {
            assigned_locations.insert(unresolved_index.clone());
            match unresolved_index.find('X') {
                Some(_) => {
                    let mut ret = 0;
                    let mut working_string: String;

                    working_string = unresolved_index.replacen('X', "0", 1);
                    ret += Instruction::rec_assign_loc(assigned_locations, working_string);
                    
                    working_string = unresolved_index.replacen('X', "1", 1);
                    ret += Instruction::rec_assign_loc(assigned_locations, working_string);
                    ret
                },
                None => 1, // base case: no 'X's
            }
        }
    }

}
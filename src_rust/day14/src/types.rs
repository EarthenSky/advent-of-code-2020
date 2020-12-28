
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

    // --------------------------------------------- //

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
}
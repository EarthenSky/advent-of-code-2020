// Instructions: copy puzzle input ( https://adventofcode dot com/2020/day/6/input or day6 dot input) into input box 
// NOTE: webpage may lag a bit when copying numbers in
// Assumptions: EOF will not follow a newline & completed pivots will NEVER be zero // groups will answer yes a min of 1 
//              There will never be 3 newlines in a row (10s) // Group size is less than 256

// ****************************************************************************************************************** //

- > // store a 255 at position zero so that the backtracking knows when to end

// first read input into each slot starting with 2 as the pivot
// an array is "created" from pivot to 27 spaces after the pivot
, 
[ // Loop will exit on EOF
    // handle single 10 
    ---- ---- --
    [ // enters loop if pivot is NOT 10
        ++++ ++++ ++

        // removes 96 = 8 * 12 from pivot using tmp // Now a is 1 and z is 26
        > ++++ ++++ [ < ---- ---- ---- > - ] <  

        // move the number to the spill pivot // pivot becomes zero
        [ >> + << - ]

        > + > // set tmp to be 1 (loop end) // and move to start of spill

        // spill the number out over the next 27 chars
        - 
        [
            [ > + < - ] // copy self to right and make current 0
            >  // go right once to the copy
            -  // end loop if self sub 1 is zero (self will be 1 if end)
        ]
        // spill is zeroed out now by converting cur from 1 to 0

        // Jump to corresponding space in dat section and add 1
        >>>> >>>> >>>> >>>> >>>> >>>> >>> + <<<< <<<< <<<< <<<< <<<< <<<< <<<

        < - [ + < - ] + <  // return to pivot by moving left until seeing 1 (loop end)
        // NOTE: tmp is already 1 so it skips the 10 handling code
    ]

    > [ - < + > ] < // move tmp to pivot // state: tmp is 0 // pivot is 1

    - // case handling a 10
    [
        + [-] , // zero then get input
        ---- ---- --
        [ // case: not a 10
            [ - > + < ] // copy pivot to tmp
            > ++++ ++++ ++ < // go to tmp and preserve input value

            >>
            >>>> >>>> >>>> >>>> >>>> >>>> >>> // 27 right
            >>>> >>>> >>>> >>>> >>>> >>>> >>>
            + // Now at the total counter & adding 1 (since 1 more person)
            <<<< <<<< <<<< <<<< <<<< <<<< <<<
            <<<< <<<< <<<< <<<< <<<< <<<< <<<
            <<

            // NOTE: spill is currently zeroed so it's all good
            >> + << // set spill index 1 (being treated as tmp2) to 1
        ]
        
        >> [ - << + >> ] << // move spill index 1 (being treated as tmp2) to pivot
        - 
        [ //case: is a 10
            // when a double newline is read from input the dat section will be read
            // effect: this will create a line of memory spaces where each space represents the number of unique letters
            //         in that group

            + [-] // zero pivot
            > [-] // zero tmp

            // NOTE: spill is already zeroed
            >>>> >>>> >>>> >>>> >>>> >>>> >>> // move 27 right

            - // mark end of dat section 0 sub 1 = 255

            // sum dat & assign it to pivot
            >>>> >>>> >>>> >>>> >>>> >>>> >>> // move 27 right
            
            > + < // add last person to total counter

            + 
            [ // count the number of numbers equal to total counter in dat section
                - 
                > [ - < - >>> + << ] < // copy total counter to tmp & sub cur cell by total counter
                
                >>> [ - << + >> ] <<< // copy tmp to total counter

                [ [-] >> - << ] >> + << // add 1 to total if cell is 0 (ie equal to total counter)
                
                > [ - < + > ] < // copy total counter to cell
                >> [ - < + > ] << // copy total to total counter

                < + 
            ] 
            - 
            + // remove end of dat section mark

            > [-] < // zero total counter

            // copy number of answers that all people in a group answered to the pivot
            >> [ - << <<<< <<<< <<<< <<<< <<<< <<<< <<< < + >> >>>> >>>> >>>> >>>> >>>> >>>> >>> > ] <<
            <<<< <<<< <<<< <<<< <<<< <<<< <<<< // goto pivot

            > // push pivot to stack & start a new life
            > [-] , < // zero new tmp & give it input
        ]
        +

        [-] // zero pivot

        // NOTE: tmp here should be a non 10 value read from input

        >> + << // set spill index 1 (being treated as tmp2) to 1
    ]

    >> [ - << + >> ] << // move spill index 1 (being treated as tmp2) to pivot // spill is zeroed again

    - // case: done normal 
    [
        [-] // zero pivot
        > [-] , < // set tmp to output of loop (read char) 
    ]
    > [ - < + > ] < // move tmp to pivot
]

// clean up last dat section
+ [-] // zero pivot
> [-] // zero tmp 

// NOTE: spill is already zeroed
>>>> >>>> >>>> >>>> >>>> >>>> >>> // move 27 right

- // mark end of dat section

// sum dat & assign it to pivot
>>>> >>>> >>>> >>>> >>>> >>>> >>> // move 27 right

> + < // add last person to total counter
            
+ 
[ // count the number of numbers equal to total counter in dat section
    - 
    > [ - < - >>> + << ] < // copy total counter to tmp & sub cur cell by total counter
    
    >>> [ - << + >> ] <<< // copy tmp to total counter

    [ [-] >> - << ] >> + << // add 1 to total if cell is 0 (ie equal to total counter)
    
    > [ - < + > ] < // copy total counter to cell
    >> [ - < + > ] << // copy total to total counter

    < + 
] 
- 
+ // remove end of dat section mark

> [-] < // zero total counter

// copy number of answers that all people in a group answered to the pivot
>> [ - << <<<< <<<< <<<< <<<< <<<< <<<< <<< < + >> >>>> >>>> >>>> >>>> >>>> >>>> >>> > ] <<
<<<< <<<< <<<< <<<< <<<< <<<< <<<< // goto pivot

// ****************************************************************************************************************** //
 
// finally when EOF is recieved the program will backtrack and add up all numbers to the two cells at the top of the 
// stack make up a 16 bit number

// NOTE: no pivots should be higher than 26

+ 
[
    -
    // Add pivot to the 16 bit running total to the right
    [
        - >> +

        // *copy* second byte to cell after
        [- > + > + <<] // move second byte to two cells after 16 bit running total
        >> [- << + >>] << // move second cell after second byte to second byte

        > [ [-] << - >> ] < // if the cell after is not zero then remove one from the first byte
        < + > // add one to the first byte no matter what // result: if zero then add one to first byte
        <<
    ]

    // move 16 bit number left 1
    > [ - < + > ] < 
    >> [ - < + > ] << 
    
    < +
]

// do last push
> [ - < + > ] < 
>> [ - < + > ] << 

// ****************************************************************************************************************** //

// first byte
[
    > // second byte
    [ 
        - >>>> >> +

        // 1s place
        ---- ---- --
        [ [ - > + < ] > ++++ ++++ ++ < < - > ] < + > // add 1 to left cell & give tmp 10 plus cur cell value if cur cell is not zero
        > [ - < + > ] < // copy tmp to cur cell

        < // 10s place
        ---- ---- --
        [ [ - >> + << ] >> ++++ ++++ ++ << < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
        >> [ - << + >> ] << // copy tmp to cur cell

        < // 100s place
        ---- ---- --
        [ [ - >>> + <<< ] >>> ++++ ++++ ++ <<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
        >>> [ - <<< + >>> ] <<< // copy tmp to cur cell

        < //1k place
        ---- ---- --
        [ [ - >>>> + <<<< ] >>>> ++++ ++++ ++ <<<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
        >>>> [ - <<<< + >>>> ] <<<< // copy tmp to cur cell

        < //10k place
        ---- ---- --
        [ [ - >>>> > + <<<< < ] >>>> > ++++ ++++ ++ <<<< < < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
        >>>> > [ - <<<< < + >>>> > ] <<<< < // copy tmp to cur cell

        << // return to second byte
    ]
    <

    // adds 1 extra to the 6 digits & does a check
    >
    >>>> >> +

    // 1s place
    ---- ---- --
    [ [ - > + < ] > ++++ ++++ ++ < < - > ] < + > // add 1 to left cell & give tmp 10 plus cur cell value if cur cell is not zero
    > [ - < + > ] < // copy tmp to cur cell

    < // 10s place
    ---- ---- --
    [ [ - >> + << ] >> ++++ ++++ ++ << < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >> [ - << + >> ] << // copy tmp to cur cell

    < // 100s place
    ---- ---- --
    [ [ - >>> + <<< ] >>> ++++ ++++ ++ <<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>> [ - <<< + >>> ] <<< // copy tmp to cur cell

    < //1k place
    ---- ---- --
    [ [ - >>>> + <<<< ] >>>> ++++ ++++ ++ <<<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>>> [ - <<<< + >>>> ] <<<< // copy tmp to cur cell

    < //10k place
    ---- ---- --
    [ [ - >>>> > + <<<< < ] >>>> > ++++ ++++ ++ <<<< < < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>>> > [ - <<<< < + >>>> > ] <<<< < // copy tmp to cur cell

    << // return to second byte
    <

    - > - < // 0 sub 1 should overflow to 255 (plus 1 from before)
]

> // do the final transfer for the second byte
[ 
    - >>>> >> +

    // 1s place
    ---- ---- --
    [ [ - > + < ] > ++++ ++++ ++ < < - > ] < + > // add 1 to left cell & give tmp 10 plus cur cell value if cur cell is not zero
    > [ - < + > ] < // copy tmp to cur cell

    < // 10s place
    ---- ---- --
    [ [ - >> + << ] >> ++++ ++++ ++ << < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >> [ - << + >> ] << // copy tmp to cur cell

    < // 100s place
    ---- ---- --
    [ [ - >>> + <<< ] >>> ++++ ++++ ++ <<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>> [ - <<< + >>> ] <<< // copy tmp to cur cell

    < //1k place
    ---- ---- --
    [ [ - >>>> + <<<< ] >>>> ++++ ++++ ++ <<<< < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>>> [ - <<<< + >>>> ] <<<< // copy tmp to cur cell

    < //10k place
    ---- ---- --
    [ [ - >>>> > + <<<< < ] >>>> > ++++ ++++ ++ <<<< < < - > ] < + > // add 1 to left cell & give tmp 10 if cur cell is not zero
    >>>> > [ - <<<< < + >>>> > ] <<<< < // copy tmp to cur cell

    << // return to second byte
]

// ****************************************************************************************************************** //
// output digits 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

> 
>>>> >> ++++ [- <<<< << ++++ ++++ ++++ >>>> >>] <<<< << // add 48 to digit before outputting // using a tmp
. 

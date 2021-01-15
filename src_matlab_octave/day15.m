%% test

disp("starting test 1 -------------");

file = fopen("day15.input", 'r');
fscanf(file, ['%d' ','])


%% part 1

disp("starting part 1 -------------");

file = fopen("day15.input", 'r');
[numbers, count] = fscanf(file, ['%lu' ',']);

% this map contains the last index each number was spoken at
index_map = containers.Map('KeyType','uint64','ValueType','uint64');
first_spoken_map = containers.Map('KeyType','uint64','ValueType','logical');

last_number = 0;

% speak initial numbers
for i = 1:count
    spoken_number = numbers(i);
    
    index_map(last_number) = i; % NOTE: update the number's index after it has been passed.
    first_spoken_map(spoken_number) = true;
    
    last_number = spoken_number;
end

% TODO: make code clear

target = 2020;
for i = (count+1):target
    spoken_number = 0;
    
    %txt3 = sprintf("%d - last - %d", [i, last_number]);
    %disp(txt3);
    
    if ~first_spoken_map.isKey(last_number) || first_spoken_map(last_number) == false
        %txt2 = sprintf("index_map(last_number) %d", index_map(last_number));
        %disp(txt2);
        
        spoken_number = i - index_map(last_number);
    end
    
    txt = sprintf("%d - spoken - %d", [i, spoken_number]);
    disp(txt);
    
    index_map(last_number) = i;
    if first_spoken_map.isKey(spoken_number)
        first_spoken_map(spoken_number) = false;
    else
        first_spoken_map(spoken_number) = true;
    end
    
    last_number = spoken_number;
end

result = sprintf("2020th number is %d", last_number);
disp(result);


%% part 2

% NOTE: this should get solution in 3000s or so
 
disp("starting part 2 -------------");

file = fopen("day15.input", 'r');
[numbers, count] = fscanf(file, ['%lu' ',']);

% this map contains the last index each number was spoken at
index_map = containers.Map('KeyType','uint64','ValueType','uint64');
last_number = 0;

% speak initial numbers
for i = 1:count
    spoken_number = numbers(i);
    
    index_map(last_number) = i; % NOTE: update the number's index after it has been passed.
    first_spoken_map(spoken_number) = true;
    
    last_number = spoken_number;
end

target = 2020;
for i = (count+1):target
    spoken_number = 0;
    
    if index_map.isKey(last_number)
        spoken_number = i - index_map(last_number);
    end
    
    %txt3 = sprintf("%d - last - %d", [i, last_number]);
    %disp(txt3);
   
    %txt = sprintf("%d", last_number);
    %disp(txt);
    
    index_map(last_number) = i;
    last_number = spoken_number;
end

result = sprintf("%dth number is %d", target, last_number);
disp(result);
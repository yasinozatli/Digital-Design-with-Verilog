
clc; clear;

% Input example values in floatingpoint
tempvalues = [-32.75, 15.125, 8.5, 45.875, -10.5, 20.625, 3.75];

tempvalues_scaled = tempvalues* 2^3;


disp("tempvalues");
disp(tempvalues);

disp("tempvalues_scaled");
disp(tempvalues_scaled);
disp(dec2bin(tempvalues_scaled));


Ra = 0; Rb = 0; Rc = 0; Rd = 0; % recent values


avg_results = zeros(1, length(tempvalues));

for i = 1:length(tempvalues)
  
    Rd = Rc;
    Rc = Rb;
    Rb = Ra;
    Ra = tempvalues_scaled(i);  % shift register

  
    sum_val = Ra + Rb + Rc + Rd;
    avg = sum_val/4;
   
    avg_results(i) = avg;

end

disp("avg results:")
disp(avg_results);

avg_scaled = avg_results / 2^3;

% Display results
disp('avg_scaled:');
disp(avg_scaled);

disp('avg_scaled_bin:');
disp(dec2bin(avg_scaled));


% Random Silent Period Algorithm - Multi-Vehicle Simulation with Overhead Estimation
% Author: Abdulhameed Idris
% Date: [Insert Date]

% -------- Input Parameters --------
num_vehicles = 5;   % Number of vehicles
T_min = 5;          % Min silent period (sec)
T_max = 15;         % Max silent period (sec)
T_total = 60;       % Total simulation time (sec)
T_sys = 0;          % System time

% Communication overhead estimates (in bytes)
IT_request_size = 100;
IT_response_size = 120;
blockchain_entry_size = 80;
overhead = 0;       % Total communication overhead

% Initialize vehicle states
silent_mode = true(num_vehicles, 1);
T_silent = zeros(num_vehicles, 1);
T_end_silent = zeros(num_vehicles, 1);

% Assign random silent periods
for i = 1:num_vehicles
    R_f = rand();
    T_silent(i) = T_min + R_f * (T_max - T_min);
    T_end_silent(i) = T_sys + T_silent(i);
end

% -------- Simulation Loop --------
disp('Simulation Start');
while T_sys <= T_total
    for i = 1:num_vehicles
        if silent_mode(i) && T_sys >= T_end_silent(i)
            fprintf('\n[%.2f sec] Vehicle %d: Silent period over (%.2f sec) — requesting IT from blockchain.\n', T_sys, i, T_silent(i));
            silent_mode(i) = false;
            
            % Simulate blockchain communication
            fprintf('[%.2f sec] Vehicle %d: IT request sent, waiting for ZKP validation...\n', T_sys, i);
            pause(0.5);
            fprintf('[%.2f sec] Vehicle %d: Blockchain validated identity, communication resumed.\n', T_sys, i);

            % Count communication overhead
            overhead = overhead + IT_request_size + IT_response_size + blockchain_entry_size;
            
            % Reassign new silent period
            R_f = rand();
            T_silent(i) = T_min + R_f * (T_max - T_min);
            T_end_silent(i) = T_sys + T_silent(i);
            silent_mode(i) = true;
        end
    end
    T_sys = T_sys + 1;
    pause(0.1); % Simulate real-time step
end

% -------- Final Output --------
disp('Simulation End');
fprintf('\nEstimated total communication overhead: %d bytes\n', overhead);

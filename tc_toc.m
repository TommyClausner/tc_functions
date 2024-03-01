function [time_left, running_avg] = tc_toc(running_avg, steps, tic_obj)
    running_avg = cat(1, running_avg, toc(tic_obj));

    avg_step_time = mean(running_avg);
    overall_time = steps*mean(running_avg);
    time_passed = sum(running_avg);
    time_left = overall_time - time_passed;
    
    fprintf([ ...
        '\noverall time: %s\n' ...
        'avg time per iteration: %s\n' ...
        'time passed: %s\n' ...
        'time remaining: %s\n'], ...
        sec2time(overall_time), ...
        sec2time(avg_step_time), ...
        sec2time(time_passed), ...
        sec2time(time_left))
    fprintf(wait_bar(time_passed, overall_time))
end

function time_str = sec2time(sec)
    h = floor(sec / 3600);
    m = floor((sec - h * 3600) / 60);
    s = floor(sec - h * 3600 - m * 60);
    time_str = sprintf("%02d:%02d:%02d", h, m, s);
end

function wait_str = wait_bar(passed_t, overall_t)
    prop = floor(passed_t / overall_t * 20);
    wait_str = repmat('-', 1, prop);
    wait_str = ['I' wait_str repmat(' ', 1, 20 - length(wait_str)) 'I\n'];
end
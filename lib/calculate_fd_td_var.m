function [nf, df, nt, dt, t] = calculate_fd_td_var(f)
    nf = length(f);
    df = f(2) - f(1);
    nt = nf;
    dt = 1/(f(end) - f(1));
    t = (0:(nt-1))*dt;
end
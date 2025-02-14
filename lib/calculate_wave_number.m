function k = calculate_wave_number(f, fidx)
    fi = f(fidx);
    %lambda = physconst("LightSpeed")/fi;   %comment out because phyconst
    %is from phsed array system toolbox
    lambda = 299792458/fi;
    k = 2*pi/lambda;
end
function [out] = myRandom(low,high)
%MYRANDOM Summary of this function goes here
%   Detailed explanation goes here

                    a = low;
                    b = high;
           
                    r = (b-a).*rand(1) + a;
                    out = int8(r);
end


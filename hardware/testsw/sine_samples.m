size = 2^12;

x = 0:((2*pi)/size):((2*pi)-((2*pi)/size));

y = sin(x);

y = (int16(round(y .* ((2^13) - 1))));

fid = fopen('sine_samples.txt', 'w');

for i=0:(size/8 - 1),
    fprintf(fid, '%6d, %6d, %6d, %6d, %6d, %6d, %6d, %6d,\n', y(i*8+1), y((i*8)+2), y((i*8)+3), y((i*8)+4), y((i*8)+5), y((i*8)+6), y((i*8)+7), y((i*8)+8));
end

fclose(fid);
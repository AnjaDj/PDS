arr = 0:1:255;
div = zeros(256,256);
rem = zeros(256,256);
for i = 1:256
    for j = 1:256
        div(i,j) = floor(arr(i) / arr(j));
        rem(i,j) = mod(arr(i), arr(j));
    end;
end;
buffer = fopen('data.csv', 'w');
for i = 1:256
    for j = 1:256
      if arr(j) == 0
          res_div = '11111111';
          res_rem = '11111111';
      else
          res_div = dec2bin(div(i,j),8);
          res_rem = dec2bin(rem(i,j),8);
      end;
      fprintf(buffer, '%s,%s,%s,%s\n', dec2bin(arr(i),8), dec2bin(arr(j),8), res_div, res_rem);  
    end;
end;
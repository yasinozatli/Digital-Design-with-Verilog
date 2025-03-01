clear, clc
file_id=fopen("C:\Users\yasin\Desktop\sonuc32matl.txt", "w");
x =zeros(32,32);
feedback =zeros(32,1);
for i=1:32
    x(i,:) = (de2bi(12345*i,32));
end
flip(x)
for i= 1:200
        for j= 1:32
          feedback(j) = xor(xor( xor(x(j, 1), x(j, 12)), x(j, 31)), x(j, 32));
        end
    x = [ x(:,2:32), feedback];
   
    output = x(:,1);

    length(output)
        for j=length(output):-1:1
            fprintf(file_id,strcat(num2str((output(j)))));
        end
fprintf(file_id,'\r\n');

end
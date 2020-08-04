filepath='/pub/work/huoyf/FY/';
x1=load('/pub/work/huoyf/FY/FY201901.mat');
f=fieldnames(x1.FY);%结构体名
num1=[1:18,23:25];
num2=[19:22];
for j=2:12
    file=dir([filepath,'FY2019',num2str(j,'%.2d'),'.mat']);
    filename=[filepath,file.name];
    x2=load(filename);
for i =1:size(num1,2)
    x1.FY.(f{num1(i)})=cat(1,x1.FY.(f{num1(i)}),x2.FY.(f{num1(i)}));
end

for i =1:size(num2,2)
    x1.FY.(f{num2(i)})=cat(2,x1.FY.(f{num2(i)}),x2.FY.(f{num2(i)}));
end
end

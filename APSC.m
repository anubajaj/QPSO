function [Per_APFD_Score]= APSC(Prioritized_Order,Test_Statement_Matrix)
[Number_TestCases,Number_Statements]=size(Test_Statement_Matrix);

Statement_Positions=(1:Number_Statements)';
Test_Covering_Statement=zeros(1,Number_Statements);
[~,index]=find(Test_Statement_Matrix(Prioritized_Order(1),:)==1);
Test_Covering_Statement(index)=1;
for i=1:Number_TestCases
    for j=1:Number_Statements
        if (Test_Statement_Matrix(Prioritized_Order(i),Statement_Positions(j))==1)&& Test_Covering_Statement(j)==0
            Test_Covering_Statement(j)=i;
        end
    end
end
APFD=sum(Test_Covering_Statement);
v1=(APFD)/(Number_TestCases*Number_Statements);
v2=1/(2*Number_TestCases);
Per_APFD_Score=(1-v1+v2)*100;

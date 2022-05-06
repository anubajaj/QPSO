%method it finds the duplicate indices and fill them
function [Updated_Pop]=Fix_Up(Particles_Pop,Updated_Pop)
[Pop_Size,Particles_Size]=size(Particles_Pop);
Updated_Pop((Updated_Pop(:)>Particles_Size)|(Updated_Pop(:)<1))=1;
Updated_Pop(isnan(Updated_Pop))=Particles_Size;
%Xnew(Xnew(:)>N)=N; Xnew(Xnew(:)<1)=1;
for i=1:Pop_Size
    [unique_elements, unique_indices] = unique( Updated_Pop(i,:), 'stable' );
    duplicate_indices = setdiff( 1:numel(Updated_Pop(i,:)), unique_indices );
    Remaining_Elements=setdiff(Particles_Pop(i,:),unique_elements,'stable');
    Updated_Pop(i,duplicate_indices)=Remaining_Elements;
end
end
unit MultiStartClass;

interface

uses tipos, ConstructivoClas, TabuClas;



Procedure MultiStart(alfax : Double; tenurex, maxitertabux, maxiterMSx : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);



implementation



Procedure MultiStart(alfax : Double; tenurex, maxitertabux, maxiterMSx : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);

var
   S_best : VectorEntero;
   Val_best : Double;
   pbest : Integer;

   iterbest, iter : Integer;



Procedure Actualizar_Best;

begin
   S_best:=Copy(Sx,0,px);
   pbest:=px;
   Val_best:=Valorx;

   iterbest:=iter
end;



Procedure Recuperar_Best;

begin
   px:=pbest;
   Sx:=Copy(S_best,0,px);
   Valorx:=Val_best
end;




begin

   iter:=0;
   Val_best:=-infDouble;

   Repeat

      iter:=iter+1;
      Constructivo(alfax,Sx,px,Valorx);
      BTabu(tenurex,maxitertabux,Sx,px,Valorx);

      if Valorx > Val_best then Actualizar_Best

   Until iter > iterbest+maxiterMSx;

   Recuperar_Best

end;




end.

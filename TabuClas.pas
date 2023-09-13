unit TabuClas;

interface

uses FuncionesClas, tipos;




Procedure BTabu(tenurex, maxitertabux : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);




implementation




Procedure BTabu(tenurex, maxitertabux : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);


var
   S_best : VectorEntero;
   Val_best : Double;
   pbest : Integer;

   TabuListaIn, TabuListaOut : VectorEntero;

   ListaOut : VectorEntero;

   iter, iterbest : Integer;

   rm, r1m, jm, j1m : Integer;
   Valorm : Real;
   tipm : Integer;



Procedure Iniciar_Auxliares;

var
   i, cnt : Integer;
   SBol : VectorBoolean;

begin
   SetLength(SBol,n);
   for i:=0 to n-1 do SBol[i]:=FALSE;
   for i:=0 to px-1 do SBol[Sx[i]]:=TRUE;

   SetLength(ListaOut,n-px);
   cnt:=0;
   for i:=0 to n-1 do
      if not SBol[i] then
         begin
         ListaOut[cnt]:=i;
         cnt:=cnt+1
         end;
end;


Procedure Iniciar_Listas_Tabu;

var
   i : Integer;

begin
   SetLength(TabuListaIn,n);
   SetLength(TabuListaOut,n);
   for i:=0 to n-1 do TabuListaIn[i]:=-tenurex;
   for i:=0 to n-1 do TabuListaOut[i]:=-tenurex
end;



Procedure Actualizar_Best;

begin
   S_best:=Copy(Sx,0,px);
   pbest:=px;
   Val_best:=Valorx;

   iterbest:=iter
end;



Function TabuIn(j1x : Integer) : Boolean;

begin
   Result:= iter <= TabuListaOut[j1x]+tenurex
end;



Function TabuOut(jx : Integer) : Boolean;

begin
   Result:= iter <= TabuListaIn[jx]+tenurex
end;



Procedure ExplorarInter;

var
   r, j, r1, j1 : Integer;
   SAux : VectorEntero;
   Valor : Double;

begin
   if px = n then Exit;

   for r:=0 to px-1 do
      begin
      j:=Sx[r];
      SAux:=Copy(Sx,0,px);
      for r1:=0 to n-px-1 do
         begin
         j1:=ListaOut[r1];
         SAux[r]:=ListaOut[r1];

         Valor:=FObjetivo(px,SAux);

         if (Valor > Val_best) or ((not TabuIn(j1)) and (not TabuOut(j))) then
            if (Valor > Valorm) then
               begin
               tipm:=1;
               Valorm:=Valor;
               rm:=r; r1m:=r1
               end
         end
      end
end;



Procedure QuitarElemento(rx : Integer; Var Sx : VectorEntero);

var
   r : Integer;

begin
   for r:=rx to px-2 do Sx[r]:=Sx[r+1];
   SetLength(Sx,px-1)
end;



Procedure ExplorarQuitar;

var
   r, j : Integer;
   SAux : VectorEntero;
   Valor : Double;

begin
   if px = 1 then Exit;

   for r:=0 to px-1 do
      begin
      j:=Sx[r];
      SAux:=Copy(Sx,0,px);
      QuitarElemento(r,SAux);

      Valor:=FObjetivo(px-1,SAux);

      if (Valor > Val_best) or (not TabuOut(j)) then
         if (Valor > Valorm) then
            begin
            tipm:=2;
            Valorm:=Valor;
            rm:=r
            end
      end
end;



Procedure AnadirElemento(jx : Integer; Var Sx : VectorEntero);

begin
   SetLength(Sx,px+1);
   Sx[px]:=jx
end;



Procedure ExplorarAnadir;

var
   j1, r1 : Integer;
   SAux : VectorEntero;
   Valor : Real;

begin
   if px = n then Exit;

   for r1:=0 to n-px-1 do
      begin
      SAux:=Copy(Sx,0,px);
      j1:=ListaOut[r1];

      AnadirElemento(j1,SAux);

      Valor:=FObjetivo(px+1,SAux);

      if (Valor > Val_best) or (not TabuIn(j1)) then
         if (Valor > Valorm) then
            begin
            tipm:=3;
            Valorm:=Valor;
            r1m:=r1
            end
      end
end;



Procedure ActualizarInter;

begin
   jm:=Sx[rm];
   j1m:=ListaOut[r1m];
   Sx[rm]:=j1m;
   ListaOut[r1m]:=jm;

   Valorx:=Valorm
end;



Procedure ActualizarQuitar;

begin
   jm:=Sx[rm];
   QuitarElemento(rm,Sx);
   px:=px-1;

   SetLength(ListaOut,n-px);
   ListaOut[n-px-1]:=jm;

   Valorx:=Valorm
end;



Procedure ActualizarAnadir;

var
   r : Integer;

begin
   j1m:=ListaOut[r1m];
   AnadirElemento(j1m,Sx);
   px:=px+1;
   for r:=r1m to n-px-1 do ListaOut[r]:=ListaOut[r+1];
   SetLength(ListaOut,n-px);

   Valorx:=Valorm
end;



Procedure Actualizar;

begin
   case tipm of
   1 : ActualizarInter;
   2 : ActualizarQuitar;
   3 : ActualizarAnadir
   end
end;


Procedure Actualizar_Listas_Tabu;

begin
   if (tipm = 1) or (tipm = 2) then TabuListaOut[jm]:=iter;
   if (tipm = 1) or (tipm = 3) then TabuListaIn[j1m]:=iter
end;


Procedure Recuperar_Best;

begin
   px:=pbest;
   Sx:=Copy(S_best,0,px);
   Valorx:=Val_best
end;



begin     { BTabu }

   Iniciar_Auxliares;
   Iniciar_Listas_Tabu;


   iter:=0;
   Actualizar_Best;

   Repeat

      iter:=iter+1;

      tipm:=0;
      Valorm:=-InfDouble;

      ExplorarInter;
      ExplorarQuitar;
      ExplorarAnadir;

      if tipm > 0 then
         begin
         Actualizar;
         Actualizar_Listas_Tabu
         end;

      if (Valorx > Val_best) then Actualizar_Best;

   Until iter > iterbest+maxitertabux;

   Recuperar_Best

end;      { BTabu }




end.

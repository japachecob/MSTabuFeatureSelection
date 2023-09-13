unit ConstructivoClas;

interface


uses FuncionesClas, tipos;



Procedure Constructivo(alfax : Double; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);




implementation



uses math;




Procedure Constructivo(alfax : Double; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);


var
   L, L1 : VectorEntero;
   nl, nl1 : Integer;
   g : VectorDouble;
   gmin, gmax : Double;
   S1 : VectorEntero;
   ibest : Integer;
   Sel : VectorBoolean;



Procedure IniciarSolucion;

begin
   SetLength(Sx,n);
   px:=0;
   Valorx:=0
end;



Procedure IniciarDimensionAux;

begin
   SetLength(L,n);
   SetLength(L1,n);
   SetLength(g,n);
   SetLength(S1,n);
   SetLength(Sel,n)
end;



Procedure IniciarSel;

var
   i : Integer;

begin
   for i:=0 to n-1 do Sel[i]:=FALSE
end;



Procedure Determinar_Valores_g;

var
   Valg : Double;
   i : Integer;

begin
   for i:=0 to n-1 do
      if (not Sel[i]) then
         begin
         S1[px]:=i;

         Valg:=FObjetivo(px+1,S1);

         g[i]:=Valg
         end
end;



Procedure Formar_L_Inicial;

var
   i, cnt : Integer;

begin
   cnt:=0;
   for i:=0 to n-1 do
      if (not Sel[i]) and (g[i] > Valorx-cotaerror) then
         begin
         L[cnt]:=i;
         cnt:=cnt+1
         end;
   nl:=cnt
end;



Procedure DeterminarExtremos;

var
   ll, i : Integer;

begin
   gmin:=infDouble;
   gmax:=-infDouble;
   for ll:=0 to nl-1 do
      begin
      i:=L[ll];
      gmin:=min(gmin,g[i]);
      gmax:=max(gmax,g[i])
      end
end;



Procedure Formar_L1;

var
   ll, i, cnt : Integer;

begin
   cnt:=0;

   for ll:=0 to nl-1 do
      begin
      i:=L[ll];

      if g[i] > alfax*gmax+(1-alfax)*gmin-cotaerror then
         begin
         L1[cnt]:=i;
         cnt:=cnt+1
         end
      end;

   nl1:=cnt
end;



Procedure ElegirAleatoriamente;

var
   pos : Integer;

begin
   pos:=Random(nl1);
   ibest:=L1[pos]
end;



Procedure Ejecutar;

begin
   Sx[px]:=ibest;
   px:=px+1;
   Valorx:=g[ibest];
   Sel[ibest]:=TRUE
end;




begin       { Constructivo }

   IniciarSolucion;
   IniciarDimensionAux;
   IniciarSel;


   Repeat
      Determinar_Valores_g;
      Formar_L_Inicial;
      if nl > 0 then
         begin
         DeterminarExtremos;
         Formar_L1;
         ElegirAleatoriamente;
         Ejecutar
         end
   Until nl = 0;

   SetLength(Sx,px)

end;        { Constructivo }



end.

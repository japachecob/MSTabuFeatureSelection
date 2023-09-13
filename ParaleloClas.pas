unit ParaleloClas;

interface

uses FuncionesClas, tipos;



var
   alfaP : Double;
   tenureP, maxitertabuP : Integer;



Procedure VersionParalela(alfax : Double; tenurex, maxitertabux, maxiterMSx : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);




implementation


uses math, System.Threading;



var
   VectSol : Matriz2Entero;
   VectTam : VectorEntero;
   VectVal : VectorDouble;



Procedure BloqueP(var Sx : VectorEntero; var px : Integer; Var Valorx : Double);


var
   L, L1 : VectorEntero;
   nl, nl1 : Integer;
   g : VectorDouble;
   gmin, gmax : Double;
   S1 : VectorEntero;
   ibest : Integer;
   Sel : VectorBoolean;

   S_best : VectorEntero;
   Val_best : Double;
   pbest : Integer;

   TabuListaIn, TabuListaOut : VectorEntero;

   ListaOut : VectorEntero;

   iter, iterbest : Integer;

   rm, r1m, jm, j1m : Integer;
   Valorm : Real;
   tipm : Integer;

   SBol : VectorBoolean;
   SAux : VectorEntero;

   Amp : MatrizDouble;
   Aux : VectorDouble;
   Inv : MatrizDouble;

   Inversib : Boolean;

   Cov : MatrizDouble;
   coef : VectorDouble;




Procedure IniciarDimensionVectores;

begin
   SetLength(Sx,n);

   SetLength(L,n);
   SetLength(L1,n);
   SetLength(g,n);
   SetLength(S1,n);
   SetLength(Sel,n);

   SetLength(SBol,n);
   SetLength(ListaOut,n-px);

   SetLength(TabuListaIn,n);
   SetLength(TabuListaOut,n);

   SetLength(S_best,n);
   SetLength(SAux,n);

   SetLength(Amp,n,2*n);
   SetLength(Aux,2*n);
   SetLength(Inv,n,n);
   SetLength(Cov,n,n);
   SetLength(Coef,n+1);
end;





(* *************************************************** Análisis Discriminante *********************************************************************** *)



Procedure Matriz_InversaP(dimx : Integer; Ax : MatrizDouble);

var
   i, i1, j : Integer;
   Aux0 : Double;

begin

   for i:=0 to dimx-1 do
      begin
      for j:=0 to dimx-1 do Amp[i,j]:=Ax[i,j];
      for j:=dimx to dimx+i-1 do Amp[i,j]:=0;
      Amp[i,dimx+i]:=1;
      for j:=dimx+i+1 to 2*dimx-1 do AmP[i,j]:=0;
      end;

   for i:=0 to dimx-1 do

      begin
      i1:=i;
      While (i1 < dimx) and (Abs(Amp[i1,i]) < cotaerror) do i1:=i1+1;
      if i1 = dimx then
         begin
         Inversib:=FALSE;  Exit
         end;
      if i1 > i then
         begin
         for j:=i to 2*dimx-1 do Aux[j]:=Amp[i1,j];
         for j:=i to 2*dimx-1 do Amp[i1,j]:=Amp[i,j];
         for j:=i to 2*dimx-1 do Amp[i,j]:=Aux[j];
         end;
      Aux0:=Amp[i,i];
      for j:=i to 2*dimx-1 do Amp[i,j]:=Amp[i,j]/Aux0;
      for i1:=i+1 to dimx-1 do
         begin
         Aux0:=Amp[i1,i];
         for j:=i to 2*dimx-1 do Amp[i1,j]:=Amp[i1,j]-Aux0*Amp[i,j]
         end
      end;

   for i:=dimx-1 downto 1 do
      for i1:=i-1 downto 0 do
         begin
         Aux0:=Amp[i1,i];
         Amp[i1,i]:=0;
         for j:=dimx to 2*dimx-1 do Amp[i1,j]:=Amp[i1,j]-Aux0*Amp[i,j]
         end;

   for i:=0 to dimx-1 do
      for j:=0 to dimx-1 do Inv[i,j]:=Amp[i,dimx+j];
   Inversib:=TRUE
end;




Procedure ObtenerCof_ADP(px : Integer; Sx : VectorEntero);

var
   j, j1 : Integer;

begin

   for j:=0 to px-1 do for j1:=j to px-1 do Cov[j,j1]:=VarC[Sx[j],Sx[j1]];
   Matriz_InversaP(px,Cov);

   for j:=0 to px-1 do
      begin
      coef[j+1]:=0;
      for j1:=0 to j do coef[j+1]:=coef[j+1]+DifC[0,Sx[j1]]*Inv[j1,j];
      for j1:=j+1 to px-1 do coef[j+1]:=coef[j+1]+DifC[0,Sx[j1]]*Inv[j,j1];
      end;

   coef[0]:=0; for j:=0 to px-1 do coef[0]:=coef[0]+coef[j+1]*MediasCC[0,Sx[j]];
   coef[0]:=-coef[0]
end;




Function NumAciertosP(px : Integer; Sx : VectorEntero) : Integer;

var
   Aciertos : Integer;
   Sum : Real;
   Pred : Integer;
   i, j : Integer;

begin
   Aciertos:=0;
   for i:=0 to mtt-1 do
      begin
      Sum:=Coef[0];
      for j:=1 to px do Sum:=Sum+XTT[i,Sx[j-1]]*Coef[j];
      Pred:=ord(Sum > 0);
      Aciertos:=Aciertos+ord(Pred = CLCTT[i])
      end;

   Result:=Aciertos
end;



Function FObjetivoP(px : Integer; Sx : VectorEntero) : Double;

var
   nac : Integer;

begin
   ObtenerCof_ADP(px,Sx);

   nac:=NumAciertosP(px,Sx);

   Result:=beta*(nac/mtt)+(1-beta)*(1-(px/n))
end;






(* *************************************************** Análisis Discriminante *********************************************************************** *)






Procedure ConstructivoP;



Procedure IniciarSolucion;

begin
   px:=0;
   Valorx:=0
end;



Procedure IniciarDimensionAux;

begin
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

         Valg:=FObjetivoP(px+1,S1);

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

      if g[i] > alfaP*gmax+(1-alfaP)*gmin-cotaerror then
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




begin       { ConstructivoP }

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

   //SetLength(Sx,px)

end;        { ConstructivoP }





Procedure BTabuP;



Procedure Iniciar_Auxliares;

var
   i, cnt : Integer;

begin
   for i:=0 to n-1 do SBol[i]:=FALSE;
   for i:=0 to px-1 do SBol[Sx[i]]:=TRUE;

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
   for i:=0 to n-1 do TabuListaIn[i]:=-tenureP;
   for i:=0 to n-1 do TabuListaOut[i]:=-tenureP
end;



Procedure CopiarVector(Sxx : VectorEntero; pxx : Integer; var Syy : VectorEntero);

var
   i : Integer;

begin
   for i:=0 to pxx-1 do Syy[i]:=Sxx[i]
end;



Procedure Actualizar_Best;

begin
   //S_best:=Copy(Sx,0,px);
   CopiarVector(Sx,px,S_best);

   pbest:=px;
   Val_best:=Valorx;

   iterbest:=iter
end;



Function TabuIn(j1x : Integer) : Boolean;

begin
   Result:= iter <= TabuListaOut[j1x]+tenureP
end;



Function TabuOut(jx : Integer) : Boolean;

begin
   Result:= iter <= TabuListaIn[jx]+tenureP
end;



Procedure ExplorarInter;

var
   r, j, r1, j1 : Integer;
   //SAux : VectorEntero;
   Valor : Double;

begin
   if px = n then Exit;

   for r:=0 to px-1 do
      begin
      j:=Sx[r];
      //SAux:=Copy(Sx,0,px);
      CopiarVector(Sx,px,SAux);

      for r1:=0 to n-px-1 do
         begin
         j1:=ListaOut[r1];
         SAux[r]:=ListaOut[r1];

         Valor:=FObjetivoP(px,SAux);

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



Procedure QuitarElemento(rx : Integer; Var Sxx : VectorEntero);

var
   r : Integer;

begin
   for r:=rx to px-2 do Sxx[r]:=Sxx[r+1];
   //SetLength(Sx,px-1)
end;



Procedure ExplorarQuitar;

var
   r, j : Integer;
   //SAux : VectorEntero;
   Valor : Double;

begin
   if px = 1 then Exit;

   for r:=0 to px-1 do
      begin
      j:=Sx[r];
      //SAux:=Copy(Sx,0,px);
      CopiarVector(Sx,px,SAux);
      QuitarElemento(r,SAux);

      Valor:=FObjetivoP(px-1,SAux);

      if (Valor > Val_best) or (not TabuOut(j)) then
         if (Valor > Valorm) then
            begin
            tipm:=2;
            Valorm:=Valor;
            rm:=r
            end
      end
end;



Procedure AnadirElemento(jx : Integer; Var Sxx : VectorEntero);

begin
   //SetLength(Sx,px+1);
   Sxx[px]:=jx
end;



Procedure ExplorarAnadir;

var
   j1, r1 : Integer;
   //SAux : VectorEntero;
   Valor : Real;

begin
   if px = n then Exit;

   for r1:=0 to n-px-1 do
      begin
      //SAux:=Copy(Sx,0,px);
      CopiarVector(Sx,px,SAux);
      j1:=ListaOut[r1];

      //AnadirElemento(j1,SAux);
      SAux[px]:=j1;

      Valor:=FObjetivoP(px+1,SAux);

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

   //SetLength(ListaOut,n-px);
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
   //SetLength(ListaOut,n-px);

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
   //Sx:=Copy(S_best,0,px);
   CopiarVector(S_best,px,Sx);

   Valorx:=Val_best
end;



begin     { BTabuP }

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

   Until iter > iterbest+maxitertabuP;

   Recuperar_Best

end;      { BTabuP }



begin

   IniciarDimensionVectores;

   ConstructivoP;
   BTabuP;

end;



Procedure GenerarSol(rx : Integer);

begin
   BloqueP(VectSol[rx],VectTam[rx],VectVal[rx])
end;




Procedure VersionParalela(alfax : Double; tenurex, maxitertabux, maxiterMSx : Integer; var Sx : VectorEntero; var px : Integer; Var Valorx : Double);

var
   rbest : Integer;




Procedure FijarParametros;

begin
   alfaP:=alfax;
   tenureP:=tenurex;
   maxitertabuP:=maxitertabux
end;



procedure IniciarDimensionesSoluciones;

begin
   SetLength(VectSol,maxiterMSx);
   SetLength(VectTam,maxiterMSx);
   SetLength(VectVal,maxiterMSx)
end;



Procedure DeterminarMejor;

var
   rr : Integer;

begin
   rbest:=0;

   for rr:=1 to maxiterMSx-1 do
      if VectVal[rr] > VectVal[rbest] then rbest:=rr;

   px:=VectTam[rbest];
   Valorx:=VectVal[rbest];
   Sx:=Copy(VectSol[rbest],0,px)
end;




begin       { VersionParalela }

   FijarParametros;
   IniciarDimensionesSoluciones;

   TParallel.for(0, maxiterMSx-1, procedure(r: Integer)
       begin
       GenerarSol(r)
       end);


   DeterminarMejor;

end;        { VersionParalela }










end.

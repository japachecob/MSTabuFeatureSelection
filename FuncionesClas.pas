unit FuncionesClas;

interface

uses tipos;



Procedure LeerFicheroCompleto1(cadenaIn : String);




Procedure PrepararDatos;




Function FObjetivo(px : Integer; Sx : VectorEntero) : Double;




implementation


uses math;


Procedure LeerFicheroCompleto1(cadenaIn : String);


var
   cnt, j, k, Aux : Integer;
   Fichero : Text;

begin
   Assignfile(Fichero,cadenaIn);
   Reset(Fichero);


   SetLength(XTT,1);
   k:=0;
   while not eoln(Fichero) do
      begin
      SetLength(XTT[0],k+1);
      Read(fichero,XTT[0][k]);
      k:=k+1
      end;
   Aux:=Round(XTT[0][k-1]);
   n:=k-1;
   SetLength(XTT[0],n);

   SetLength(ClCTT,1);
   ClCTT[0]:=Aux;
   ncl:=Aux;

   Readln(fichero);
   cnt:=1;

   While not eof(Fichero) do
      begin
                                   //cnt0:=cnt;
      SetLength(XTT,cnt+1);
      SetLength(XTT[cnt],n);
      for j:=0 to n-1 do Read(fichero,XTT[cnt][j]);

      SetLength(ClCTT,cnt+1);
      Read(fichero,Aux);
      ClCTT[cnt]:=Aux;
      ncl:=max(ncl,Aux);


      Readln(fichero);
      cnt:=cnt+1
      end;

   mtt:=cnt;
   ncl:=ncl+1;

   Closefile(fichero)
end;



Procedure DeterminarNoConstantes(mx, nx : Integer; Xx : Matriz2Double; var nfx : Integer; var SFx : VectorEntero);

var
   j, cnt, i : Integer;
   mn, maxx : Double;

begin
   SetLength(SFx,nx);

   cnt:=0;
   for j:=0 to nx-1 do
      begin
      mn:=Xx[0,j];
      maxx:=Xx[0,j];
      for i:=1 to mx-1 do
         begin
         mn:=min(mn,Xx[i,j]);
         maxx:=max(maxx,Xx[i,j])
         end;
      if abs(maxx-mn) > cotaerror then
         begin
         SFx[cnt]:=j; cnt:=cnt+1
         end;
      end;
   nfx:=cnt;


   SetLength(SFx,nfx);
end;



Procedure FiltrarNoConstantes(mx, nfx : Integer; SFx : VectorEntero; var Xx : Matriz2Double);

var
   i, j : Integer;

begin
   for j:=0 to nfx-1 do
      for i:=0 to mx-1 do Xx[i,j]:=Xx[i,SFx[j]];
   SetLength(Xx,mx,nfx)
end;



Procedure EliminarConstantes;

begin
   DeterminarNoConstantes(mtt,n,XTT,nf,SF);
   FiltrarNoConstantes(mtt,nf,SF,XTT);
   nfaux:=n;
   n:=nf
end;



Procedure Desfiltrar(px : Integer; var Sx : VectorEntero);

var
   j : Integer;

begin
   for j:=0 to px-1 do Sx[j]:=SF[Sx[j]]
end;



Procedure MaximosMinimos(jx : Integer);

var
   i : Integer;

begin
   Maximos[jx]:=-infReal;
   Minimos[jx]:=infReal;

   for i:=0 to mtt-1 do
      begin
      Maximos[jx]:=max(Maximos[jx],XTT[i,jx]);
      Minimos[jx]:=min(Minimos[jx],XTT[i,jx])
      end;
end;



Procedure MaximosMinimosTodas;

var
   j : Integer;

begin
   SetLength(Maximos,n);
   SetLength(Minimos,n);

   for j:=0 to n-1 do MaximosMinimos(j)
end;



Procedure Normalizar;

var
   i, j : Integer;

begin
   for i:=0 to mtt-1 do
      for j:=0 to n-1 do XTT[i,j]:=(XTT[i,j]-Minimos[j])/(Maximos[j]-Minimos[j])
end;



Procedure IniciarY_Y1;

var
   i : Integer;

begin
   SetLength(Y1,mtt);
   for i:=0 to mtt-1 do Y1[i]:=2*ClCTT[i]-1;

   SetLength(Y,mtt);
   for i:= 0 to mtt-1 do Y[i]:=ClCTT[i]
end;



Procedure Casosporgupo_C;

var
   g, i : Integer;

begin
   SetLength(mm,ncl);
   for g:=0 to ncl-1 do mm[g]:=0;

   for i:=0 to mtt-1 do mm[ClCTT[i]]:=mm[ClCTT[i]]+1
end;



Procedure MediasVariableC(jx : Integer);

var
   g, i : Integer;
   SumT : Double;
   Sum : VectorDouble;

begin
   SetLength(Sum,ncl);

   SumT:=0;
   for g:=0 to ncl-1 do Sum[g]:=0;

   for i:=0 to mtt-1 do
      begin
      SumT:=SumT+XTT[i,jx];
      Sum[ClCTT[i]]:=Sum[ClCTT[i]]+XTT[i,jx]
      end;

   Medias[jx]:=SumT/mtt;
   for g:=0 to ncl-1 do MediasG[g,jx]:=Sum[g]/mm[g];

   for g:=0 to ncl-2 do
      begin
      MediasCC[g,jx]:=(MediasG[g+1,jx]+MediasG[0,jx])/2;
      DifC[g,jx]:=MediasG[g+1,jx]-MediasG[0,jx]
      end
end;



Procedure Todas_mediasC;

var
   j : Integer;

begin
   SetLength(Medias,n);
   SetLength(MediasG,ncl,n);
   SetLength(MediasCC,ncl-1,n);
   SetLength(DifC,ncl-1,n);

   for j:=0 to n-1 do
      MediasVariableC(j)
end;



function Covarianza(jx, j1x : Integer) : Real;

var
   Sum, Aux : Real;
   i : Integer;

begin
   Sum:=0;
   for i:=0 to mtt-1 do Sum:=Sum+XTT[i,jx]*XTT[i,j1x];
   Aux:=Sum/mtt-Medias[jx]*Medias[j1x];
   Result:=Aux
end;



Procedure Covarianza_Todas;

var
   j, j1 : Integer;

begin
   SetLength(VarC,n,n);

   for j:=0 to n-1 do
      for j1:=j to n-1 do
         begin
         VarC[j,j1]:=Covarianza(j,j1);
         if j1 > j then VarC[j1,j]:=VarC[j,j1]
         end
end;



Procedure PrepararDatos;

begin
   EliminarConstantes;
   MaximosMinimosTodas;
   Normalizar;

   if ncl = 2 then IniciarY_Y1;

   Casosporgupo_C;
   Todas_mediasC;
   Covarianza_Todas;
end;



(* *************************************************** Análisis Discriminante *********************************************************************** *)



Procedure Matriz_InversaP(dimx : Integer; Ax : MatrizDouble; var Inversibx : Boolean; var Invx : MatrizDouble);

var
   i, i1, j : Integer;
   Aux0 : Real;
   Ampx : MatrizDouble;
   Auxx : VectorDouble;

begin
   SetLength(Ampx,dimx,2*dimx);
   SetLength(Auxx,2*dimx);
   SetLength(Invx,dimx,dimx);


   for i:=0 to dimx-1 do
      begin
      for j:=0 to dimx-1 do Ampx[i,j]:=Ax[i,j];
      for j:=dimx to dimx+i-1 do Ampx[i,j]:=0;
      Ampx[i,dimx+i]:=1;
      for j:=dimx+i+1 to 2*dimx-1 do Ampx[i,j]:=0;
      end;

   for i:=0 to dimx-1 do

      begin
      i1:=i;
      While (i1 < dimx) and (Abs(Ampx[i1,i]) < cotaerror) do i1:=i1+1;
      if i1 = dimx then
         begin
         Inversibx:=FALSE;  Exit
         end;
      if i1 > i then
         begin
         for j:=i to 2*dimx-1 do Auxx[j]:=Ampx[i1,j];
         for j:=i to 2*dimx-1 do Ampx[i1,j]:=Ampx[i,j];
         for j:=i to 2*dimx-1 do Ampx[i,j]:=Auxx[j];
         end;
      Aux0:=Ampx[i,i];
      for j:=i to 2*dimx-1 do Ampx[i,j]:=Ampx[i,j]/Aux0;
      for i1:=i+1 to dimx-1 do
         begin
         Aux0:=Ampx[i1,i];
         for j:=i to 2*dimx-1 do Ampx[i1,j]:=Ampx[i1,j]-Aux0*Ampx[i,j]
         end
      end;

   for i:=dimx-1 downto 1 do
      for i1:=i-1 downto 0 do
         begin
         Aux0:=Ampx[i1,i];
         Ampx[i1,i]:=0;
         for j:=dimx to 2*dimx-1 do Ampx[i1,j]:=Ampx[i1,j]-Aux0*Ampx[i,j]
         end;

   for i:=0 to dimx-1 do
      for j:=0 to dimx-1 do Invx[i,j]:=Ampx[i,dimx+j];
   Inversibx:=TRUE
end;




Procedure ObtenerCof_AD(px : Integer; Sx : VectorEntero; var coefx : VectorDouble);

var
   Cov, Inv : MatrizDouble;
   Inversib : Boolean;
   j, j1 : Integer;

begin
   SetLength(Cov,px,px);

   for j:=0 to px-1 do for j1:=j to px-1 do Cov[j,j1]:=VarC[Sx[j],Sx[j1]];
   Matriz_InversaP(px,Cov,Inversib,Inv);


   SetLength(Coefx,px+1);

   for j:=0 to px-1 do
      begin
      coefx[j+1]:=0;
      for j1:=0 to j do coefx[j+1]:=coefx[j+1]+DifC[0,Sx[j1]]*Inv[j1,j];
      for j1:=j+1 to px-1 do coefx[j+1]:=coefx[j+1]+DifC[0,Sx[j1]]*Inv[j,j1];
      end;

   coefx[0]:=0; for j:=0 to px-1 do coefx[0]:=coefx[0]+coefx[j+1]*MediasCC[0,Sx[j]];
   coefx[0]:=-coefx[0]
end;


(* *************************************************** Análisis Discriminante *********************************************************************** *)




Procedure ObtenerCof(px : Integer; Sx : VectorEntero; var coefx : VectorDouble);

begin

  ObtenerCof_AD(px,Sx,coefx);

end;




Function NumAciertos(px : Integer; Sx : VectorEntero; coefx : VectorDouble) : Integer;

var
   Aciertos : Integer;
   Sum : Real;
   Pred : Integer;
   i, j : Integer;

begin
   Aciertos:=0;
   for i:=0 to mtt-1 do
      begin
      Sum:=Coefx[0];
      for j:=1 to px do Sum:=Sum+XTT[i,Sx[j-1]]*Coefx[j];
      Pred:=ord(Sum > 0);
      Aciertos:=Aciertos+ord(Pred = CLCTT[i])
      end;

   Result:=Aciertos
end;



Function FObjetivo(px : Integer; Sx : VectorEntero) : Double;

var
   coef : VectorDouble;
   nac : Integer;

begin
   ObtenerCof(px,Sx,coef);

   nac:=NumAciertos(px,Sx,coef);

   Result:=beta*(nac/mtt)+(1-beta)*(1-(px/n))
end;





end.

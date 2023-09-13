unit tipos;

interface



const
   inf : Integer = 999999999;
   infReal : Real = 999999999999;
   infDouble : Double = 1e+15;

   cotaerror : Double = 0.000001;

   RatioLRR : Double = 0.1;
   delta0 : Double = 0.1;              //GRPROP
   deltamin : Double = 0; //1e-6; //0 ;
   deltamax : Double = 50;  //50;

   nu_men : Double = 0.5;
   nu_mas : Double = 1.2;


   TolR : Double = 1e-10;

   Tol : Real = +1e-4;

   beta : Double = 0.99;





type
   VectorEntero = Array of Integer;
   MatrizEntero = Array of Array of Integer;
   Matriz2Entero = Array of VectorEntero;


   VectorBoolean = Array of Boolean;


   VectorDouble = Array of Double;
   MatrizDouble = Array of Array of Double;
   Matriz2Double = Array of VectorDouble;


var
   n, ncl : Integer;

   mtt : Integer;
   XTT : Matriz2Double;
   //ClTT : VectorBoolean;
   ClCTT : VectorEntero;


   nfaux, nf : Integer;
   SF : VectorEntero;
   Maximos, Minimos : VectorDouble;


   mm : VectorEntero;
   Medias, MediasC : VectorDouble;
   MediasG : Matriz2Double;
   Dif : VectorDouble;
   MediasCC, DifC : Matriz2Double;
   VarC : Matriz2Double;


   Y, Y1 : VectorEntero;


   //tipoMet : Integer;





implementation

end.

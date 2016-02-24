function H = homographieNico(X,Y)
    PointsNumberX = size(X,2); 
    PointsNumberY = size(Y,2); 


    if ~(PointsNumberX == 4)
        disp('[ERROR]   There is not 4 coordinates in the plane.');
        stop();
    end; 

    if ~(PointsNumberY == 4)
        disp('[ERROR]   There is not 4 coordinates in the image.');
        stop();
    end; 


    %disp( strcat( "X:\n",num2str(X) ) );
    %disp('')
    %disp( strcat( "Y:\n",num2str(Y) ) );
    %disp('')

    Ytrans = [ 	Y(:,1)' zeros(1,9) ;
                zeros(1,3) Y(:,1)' zeros(1,6) ;
                zeros(1,6) Y(:,1)' zeros(1,3) ; 

                Y(:,2)' zeros(1,9) ;
                zeros(1,3) Y(:,2)' zeros(1,6) ;
                zeros(1,6) Y(:,2)' zeros(1,3) ; 

                Y(:,3)' zeros(1,9) ;
                zeros(1,3) Y(:,3)' zeros(1,6) ;
                zeros(1,6) Y(:,3)' zeros(1,3) ; 

                Y(:,4)' zeros(1,9) ;
                zeros(1,3) Y(:,4)' zeros(1,6) ;
                zeros(1,6) Y(:,4)' zeros(1,3) ; 

             ];

    Xtrans = reshape(X, 1,12)';

    %disp( strcat( "Xtrans:\n",num2str(Xtrans) ) );
    %disp('')
    %disp( strcat( "Ytrans:\n",num2str(Ytrans) ) );
    %disp('')

    Htrans =  Ytrans \ Xtrans; 

    H = [Htrans(1) Htrans(2) Htrans(3) ; Htrans(4) Htrans(5) Htrans(6) ; Htrans(9) Htrans(8) Htrans(7) ];

    %disp( strcat( "Htrans:\n",num2str(Htrans) ) );
end
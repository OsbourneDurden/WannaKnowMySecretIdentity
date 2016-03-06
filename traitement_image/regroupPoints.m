function out = regroupPoints(points, distMax)
% prend une matrice de coordonn�es, et retourne une matrice ayant regroup�
% les points �tant s�par� par une distance inf�rieur � distMax.

% recherche des coins proches entre eux
    [Nm, ~] = size(points);
    out = [];
    for i=1:Nm
        alias = [];

        for j=1:Nm
            dist = distance( points(i,2), points(i,1), points(j,2), points(j,1) );

            if (dist < distMax) & (dist > 0)
                if isempty( find( alias == j ) ) 

                    alias = [alias ; j];

                end
            end
        end
        
        % Pour un groupe de coins proches, ?tablir un point m?dian
        if isempty(alias) == 0
            posMoy = mean([points(i,:) ; points(alias,:)]);
            if isempty(out)
                out = [out ; posMoy];             
            elseif isempty( find( out(:,1) == posMoy(1) ) ) &  isempty( find( out(:,2) == posMoy(2) ) )                   
                out = [out ; posMoy];             
            end
        else
        % Si coins isol?, ne rien faire 
            out = [out ; points(i,:)];             
        end
    end
    
end
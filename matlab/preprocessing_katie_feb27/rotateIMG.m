function [rotatedIMG] = rotateIMG(origIMG, angle)

origIMG = double(origIMG);

[height width] = size(origIMG);
theta = ((360-angle)/180)*pi;

RotationMatrix = [cos(theta) sin(theta); -sin(theta) cos(theta)];
rotatedIMG = zeros(height, width);
for i=1:height
    for j=1:width
        rotatedIMG(i,j) = 255;

        oldPts = RotationMatrix*[i-height/2;j-width/2];
        
        xpoint = width/2 + oldPts(2);
        ypoint = height/2 + oldPts(1);
        
        biLinear(1,:) = [floor(ypoint)  floor(xpoint)];
        biLinear(2,:) = [floor(ypoint)  ceil(xpoint)];
        biLinear(3,:) = [ceil(ypoint)   ceil(xpoint)];
        biLinear(4,:) = [ceil(ypoint)   floor(xpoint)];
        
        if (ceil(ypoint)<=height && ceil(xpoint)<=width && floor(ypoint)>0 && floor(xpoint)>0)
            
%             origIMG(biLinear(1,1),biLinear(1,2))
%             origIMG(biLinear(2,1),biLinear(2,2))
%             origIMG(biLinear(3,1),biLinear(3,2))
%             origIMG(biLinear(4,1),biLinear(4,2))
          
            
            R1 = ((biLinear(3,2)-xpoint)./(biLinear(3,2)-biLinear(4,2))).*origIMG(biLinear(4,1),biLinear(4,2)) + ...
                ((xpoint-biLinear(4,2))./(biLinear(3,2)-biLinear(4,2))).*origIMG(biLinear(3,1), biLinear(3,2));
            
            R2 = ((biLinear(2,2)-xpoint)./(biLinear(2,2)-biLinear(1,2))).*origIMG(biLinear(1,1),biLinear(1,2)) + ...
                ((xpoint-biLinear(1,2))./(biLinear(2,2)-biLinear(1,2))).*origIMG(biLinear(2,1),biLinear(2,2));
            
            
%             ((biLinear(4,1)-ypoint)./(biLinear(4,1)-biLinear(1,1))).*R1 + ...
%                 ((ypoint-biLinear(1,1))./(biLinear(4,1)-biLinear(1,1))).*R2
            
            rotatedIMG(i,j) = round(((biLinear(4,1)-ypoint)./(biLinear(4,1)-biLinear(1,1))).*R2 + ...
                ((ypoint-biLinear(1,1))./(biLinear(4,1)-biLinear(1,1))).*R1);
            
        end
    end
end

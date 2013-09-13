function [measure_lines measure_bounds] = measure_segment( img )
%measure_segment Used to segment a staff of music into individual measures
%   measure_lines[] : the location in the staff of the measure markers
%   measure_bounds[i,j] : the bounds for each measure,
%       i is the measure number
%       j notes the either beginning bound or ending bound, j=1 is the
%       beginning, j=2 is the end
%   img: this is a matrix of BW image data created from the data
%   given by staff_segment

%--Mike Hand--add in check for index 2 and n-1
% projection on to horizontal axis:
proj_onto_x = sum(img , 1);
%proj_onto_x=proj_onto_x-mean(proj_onto_x);
% calculate threshold:
thrsh = 0.82 * max(proj_onto_x);%maybe fine tune
low_thrsh=mean(proj_onto_x);
measure_lines = [];
crude_lines=[];
in_note=0;
%checks first entry separately, if above threshold and the next one doesn't
%indicate something else then it's a measure line
if(proj_onto_x(1)>thrsh)
    if((proj_onto_x(3)>thrsh)||(proj_onto_x(3)<low_thrsh))
       crude_lines=1;
    end
end
%checks most lines if above threshold and each side is either above
%threshold or well below threshold then measure line
for msl=3:(size(proj_onto_x,2)-1)
    if(~in_note)
         if(proj_onto_x(msl)>thrsh)
             
             if((proj_onto_x(msl-1)>thrsh)||(proj_onto_x(msl-2)<low_thrsh))
                 if((proj_onto_x(msl+1)>thrsh)||(proj_onto_x(msl+2)<low_thrsh))
                     
                     crude_lines=[crude_lines msl];
                     continue;
                 end
             end
             %will only hit if above threshold, and fails not note checks
             in_note=1;
         end
    else
        if(proj_onto_x(msl)<thrsh)
            in_note=0;
        end
    end
end
%checks last entry separately, if above threshold and the previous one doesn't
%indicate something else then it's a measure line
if(proj_onto_x(size(proj_onto_x,2))>thrsh)
    if((proj_onto_x(size(proj_onto_x,2)-1)>thrsh)||(proj_onto_x(size(proj_onto_x,2)-2)<low_thrsh))
       crude_lines=[crude_lines size(proj_onto_x,2)];
    end
end
figure
plot(proj_onto_x)

% create array holding y values of all measure lines:
l = length(crude_lines);
msl = 1;
projLen=length(proj_onto_x);
keyboard
while (msl < l)
    s_begin = crude_lines(msl);
    
    % next measure line must be at least four pixels away: (probably want a
    % few more as well)
    while ( (msl+1)<=l) && ((crude_lines(msl)+1)==crude_lines(msl+1)||((crude_lines(msl)+2)==crude_lines(msl+1))||((crude_lines(msl)+3)==crude_lines(msl+1))||((crude_lines(msl)+4)==crude_lines(msl+1)))
        msl = msl + 1;
    end
    s_end = crude_lines(msl);
    if (s_end+2>projLen)
        measure_lines = [measure_lines round((s_begin + s_end)/2)];
    else if(proj_onto_x(s_end+2)<low_thrsh)
        % add meaure line to array:
        measure_lines = [measure_lines round((s_begin + s_end)/2)];
        end
    end
    msl = msl + 1;
end
measure_bounds=[];
mbStart=1;
if(measure_lines(1)>.05*projLen)
    measure_bounds=[1 measure_lines(1)];
end
%keyboard
%unlike with staff lines, can cut at measure lines
mbEnd=size(measure_lines,2)-1;
for msl=mbStart:mbEnd
    measure_bounds=[measure_bounds measure_lines(msl) measure_lines(msl+1)];
end
if(measure_lines(mbEnd)<.95*projLen)
    measure_bounds=[measure_bounds measure_bounds(end) projLen];
end
mbEnd=length(measure_bounds);
measure_bounds = (reshape(measure_bounds,2, mbEnd/2))';
end


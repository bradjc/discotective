%NEURAL NET CODE
%EECS 452
%%%%%%%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%
%number of final classes - in our case this would be the number of possible
%types of notes etc
numClasses = 2;

%set this to a small value
stepSize = .01;

%set this to a large value so that we converge
numIterations = 10000;


%set the number of units in each hidden layer
HIDDEN = [2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%DATA%%%%%%%%%%%%%%%%%%%%%%%%

%FOR US WE WOULD HAVE THE INPUT BE SOMETHING LIKE A FEATURE VECTOR OR JUST
%ALL THE PIXELS CONCATINATED AND LINED UP IN A ROW. THE OUTPUT CLASS WOULD
%BE THE NUMBER CORRESPONDING TO ITS NOTE TYPE (A 1/2 NOTE W/ A LINE
%UP WOULD BE DIFFRENT THAN A 1/2 NOTE WITH A LINE DOWN ETC). 

%read data from file (can replace Hw2data1a with Hw2data1b)
f2 = fopen('lines_circles.txt');
DATA = fscanf(f2, '%f %f %f %f %f %f %f %f %f %f', [10, inf]);
fclose(f2);
DATA = DATA';

%define numObser as the number of samples
numObser = size(DATA,1);
Yin = DATA(:,size(DATA,2)); %joe edit

%assign inputs, X, as the first 9 columns 
X = DATA(:,1:9);    %joe edit

%create Y: if an observation is in class n, there should be a 1 in 
%Y(observation, n) and 0 everywhere else in the row
Y = zeros(numObser,numClasses);
for i=1:numObser
    if(Yin(i)==1)
        Y(i,1)=1;
    else
        Y(i,2)=1;
    end
end
% Y(i,Yin(i)) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%INITILIZE%%%%%%%%%%%%%%%%%%%%%%%%


numUnits = [size(X,2) HIDDEN numClasses];
numUnits = numUnits + ones(1,length(numUnits));
numLayers = length(numUnits);
W = NaN(numLayers-1,max(numUnits),max(numUnits));

%initilize weights to values between -.01 and .01
for layer=1:numLayers-1
    for currUnit=1:numUnits(layer)
        for futUnit=2:numUnits(layer+1)
            W(layer,currUnit,futUnit) = (rand-0.5)/50;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%BACKPROP%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iteration=1:numIterations
    %for each observation
    for observation=1:numObser
        
        %initlize currentVal Matrix
        currUnitVal = NaN(numLayers,max(numUnits));
        %this 1 is not refrenced in the text I sent you, but should be
        %there. It is necessary so that our equations do not need to pass
        %through the orgin
        currUnitVal(:,1,1) = 1;
        currUnitVal(1,2:size(X,2)+1,1) = X(observation,:);

        %for each unit caluclate its value to determien the output of the
        %neural net
        for layer=1:numLayers-1
            for futUnit=2:numUnits(layer+1)
                sumUnit = 0;
                for currUnit=1:numUnits(layer)
                    sumUnit = sumUnit + W(layer,currUnit,futUnit)*currUnitVal(layer, currUnit);
                end
                currUnitVal(layer+1,futUnit) = 1/(1+exp(-sumUnit));
            end
        end

        
        %calculate error
        deltaError = NaN(numLayers,max(numUnits));
        deltaError(numLayers,2:numUnits(numLayers)) = (Y(observation,:) - currUnitVal(numLayers,2:numUnits(numLayers))).* ...
            (ones(1,numClasses) - currUnitVal(numLayers,2:numUnits(numLayers))).*...
            currUnitVal(numLayers,2:numUnits(numLayers));


        %calculte backprop error
        for layer=numLayers-1:-1:2
            for currUnit=1:numUnits(layer)
                errorSumUnit = 0;
                for futUnit=2:numUnits(layer+1)
                    errorSumUnit = errorSumUnit + W(layer,currUnit,futUnit)*deltaError(layer+1, futUnit);
                end
                deltaError(layer,currUnit) = currUnitVal(layer,currUnit).*(1-currUnitVal(layer,currUnit)).*errorSumUnit;
            end
        end


        %modify weights based upon calculated error
        for layer=1:numLayers-1
            for currUnit=1:numUnits(layer)
                for futUnit=2:numUnits(layer+1)
                    W(layer,currUnit,futUnit) = W(layer,currUnit,futUnit)+ ...
                        stepSize.*deltaError(layer+1,futUnit).*currUnitVal(layer,currUnit);
                end
            end
        end
        %outputNeural(observation,:) = [currUnitVal(numLayers,2) currUnitVal(numLayers,3)];
    end
end


%calculate the response -- this should not be on our training data but oh
%well
for observation=1:numObser
    currUnitVal = NaN(numLayers,max(numUnits));
    currUnitVal(:,1,1) = 1;
    currUnitVal(1,2:size(X,2)+1,1) = X(observation,:);

    for layer=1:numLayers-1
        for futUnit=2:numUnits(layer+1)
            sumUnit = 0;
            for currUnit=1:numUnits(layer)
                sumUnit = sumUnit + W(layer,currUnit,futUnit)*currUnitVal(layer, currUnit);
            end
            currUnitVal(layer+1,futUnit) = 1/(1+exp(-sumUnit));
        end
    end
    
    %figure out which output is closer to 1 and set that as the classified
    %class
    outputNeural(observation,:) = [currUnitVal(numLayers,2) currUnitVal(numLayers,3)];
    if(currUnitVal(numLayers,2)>currUnitVal(numLayers,3))
        approxClass(observation) = 1;
    else
        approxClass(observation) = -1;
    end
end
approxClass = approxClass';

%calculate miscalculation
misclass = 0;
for observation=1:numObser
    if(Yin(observation) ~= approxClass(observation))
        misclass = misclass+1;
    end
end
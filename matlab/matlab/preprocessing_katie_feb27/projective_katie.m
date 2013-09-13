function t = projective_katie(U, X)

% Build a projective TFORM struct.
A = construct_matrix( U, X); 


N = size(A,2) - 1;
tdata.T    = A;
tdata.Tinv = inv(A);

t = assigntform(N, N, @fwd_projective, @inv_projective, tdata);
%--------------------------------------------------------------------------

function t = assigntform(ndims_in, ndims_out, forward_fcn, inverse_fcn, tdata)

% Use this function to ensure consistency in the way we assign
% the fields of each TFORM struct.

t.ndims_in    = ndims_in;
t.ndims_out   = ndims_out;
t.forward_fcn = forward_fcn;
t.inverse_fcn = inverse_fcn;
t.tdata       = tdata;

%--------------------------------------------------------------------------

function U = inv_projective( X, t )

% INVERSE projective transformation 
%
% T is an projective transformation structure. X is the row vector to
% be transformed, or a matrix with a vector in each row.

U = trans_projective(X, t, 'inverse');

%--------------------------------------------------------------------------

function X = fwd_projective( U, t)

% FORWARD projective transformation 
%
% T is an projective transformation structure. U is the row vector to
% be transformed, or a matrix with a vector in each row.

X = trans_projective(U, t, 'forward');

%--------------------------------------------------------------------------

function U = trans_projective( X, t, direction )

% Forward/inverse projective transformation method
%
% T is an projective transformation structure. X is the row vector to
% be transformed, or a matrix with a vector in each row.
% DIRECTION is either 'forward' or 'inverse'.

if strcmp(direction,'forward')
    M = t.tdata.T;
elseif strcmp(direction,'inverse')
    M = t.tdata.Tinv;
else
    eid = sprintf('Images:%s:invalidDirection',mfilename);
    msg = 'DIRECTION must be either ''forward'' or ''inverse''.';
    error(eid,'%s',msg);
end

N  = t.ndims_in;
X1 = [X ones(size(X,1),1)];   % Convert X to homogeneous coordinates
U1 = X1 * M;                  % Transform in homogeneous coordinates
UN = repmat(U1(:,end),[1 N]); % Replicate the last column of U
U  = U1(:,1:end-1) ./ UN;     % Convert homogeneous coordinates to U


%---------------------------------------------------------------

function A = construct_matrix( U, X )

% Construct a 3-by-3 2-D transformation matrix A
% that maps the points in U to the points in X.

Au = UnitToQuadrilateral(U);
Ax = UnitToQuadrilateral(X);
A = Au \ Ax;
A = A / A(end,end);

%---------------------------------------------------------------

function A = UnitToQuadrilateral( X )

% Computes the 3-by-3 two-dimensional projective transformation
% matrix A that maps the unit square ([0 0], [1 0], [1 1], [0 1])
% to a quadrilateral corners (X(1,:), X(2,:), X(3,:), X(4,:)).
% X must be 4-by-2, real-valued, and contain four distinct
% and non-collinear points.  A is a 3-by-3, real-valued matrix.
% If the four points happen to form a parallelogram, then
% A(1,3) = A(2,3) = 0 and the mapping is affine.
%
% The formulas below are derived in
%   Wolberg, George. "Digital Image Warping," IEEE Computer
%   Society Press, Los Alamitos, CA, 1990, pp. 54-56,
% and are based on the derivation in
%   Heckbert, Paul S., "Fundamentals of Texture Mapping and
%   Image Warping," Master's Thesis, Department of Electrical
%   Engineering and Computer Science, University of California,
%   Berkeley, June 17, 1989, pp. 19-21.

x = X(:,1);
y = X(:,2);

dx1 = x(2) - x(3);
dx2 = x(4) - x(3);
dx3 = x(1) - x(2) + x(3) - x(4);

dy1 = y(2) - y(3);
dy2 = y(4) - y(3);
dy3 = y(1) - y(2) + y(3) - y(4);

if dx3 == 0 && dy3 == 0
    % Parallelogram: Affine map
    A = [ x(2) - x(1)    y(2) - y(1)   0 ; ...
          x(3) - x(2)    y(3) - y(2)   0 ; ...
          x(1)           y(1)          1 ];
else
    % General quadrilateral: Projective map
    a13 = (dx3 * dy2 - dx2 * dy3) / (dx1 * dy2 - dx2 * dy1);
    a23 = (dx1 * dy3 - dx3 * dy1) / (dx1 * dy2 - dx2 * dy1);
    
    A = [x(2) - x(1) + a13 * x(2)   y(2) - y(1) + a13 * y(2)   a13 ;...
         x(4) - x(1) + a23 * x(4)   y(4) - y(1) + a23 * y(4)   a23 ;...
         x(1)                       y(1)                       1   ];
end

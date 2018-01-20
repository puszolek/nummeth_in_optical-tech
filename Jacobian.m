function J = Jacobian(res,P)
denom = sqrt( (res(1) - P(:,1)).^2 + (res(2) - P(:,2)).^2 );
J = [(res(1) - P(:,1))./denom, (res(2) - P(:,2))./denom, -ones(size(P, 1), 1)];
end


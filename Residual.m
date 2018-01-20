function R = Residual(res,P); 
R = sqrt( (res(1) - P(:,1)).^2 + (res(2) - P(:,2)).^2) - res(3);
end


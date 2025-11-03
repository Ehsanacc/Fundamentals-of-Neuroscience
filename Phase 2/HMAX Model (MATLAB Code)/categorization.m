function [XTrainC, ytrainC, XTestH, ytestH, XTestN, ytestN, XTestM, ytestM, XTestF, ytestF] = categorization(XTrain, ytrain, XTest, ytest)
    % Create an array of numbers from 1 to 600
    numbers = 1:600;
    
    % Find the indices of the numbers that have a remainder of 2 when divided by 4
    indicesC = numbers(mod(numbers, 4) == 2);
    
    % Define the indices for the different sets of test data
    head = cat(2,[151:225],[451:525]);
    near = cat(2,[1:75],[301:375]);
    middle = cat(2,[226:300],[526:600]);
    far = cat(2,[76:150],[376:450]);
    
    % Extract the columns of XTrain and ytrain corresponding to the indices with a remainder of 2
    XTrainC = XTrain(:, indicesC);
    ytrainC = ytrain(indicesC, :);
    
    % Extract the columns of XTest and ytest corresponding to the different sets of test data
    XTestH = XTest(:, head);
    ytestH = ytest(head, :);
    
    XTestN = XTest(:, near);
    ytestN = ytest(near, :);
    
    XTestM = XTest(:, middle);
    ytestM = ytest(middle, :);
    
    XTestF = XTest(:, far);
    ytestF = ytest(far, :);
end
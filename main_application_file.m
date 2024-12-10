load SVMKernelModelClassifier.mat

%this will be detected from phone

%did not have time to build the mobile app

%the model was trained on processed data to lower the dimension
vec = [1,1,1,1,1,1,1,1,1,1];
trainedModel.predictFcn(vec)
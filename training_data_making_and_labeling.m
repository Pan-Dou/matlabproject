clear;

% p:pocket u:using x:not-on-person
files={
    {'ondesk.mat','x','idle    '},
    {'usitting.mat','u','sitting '},
    {'psitting.mat','p','sitting '},
    {'ustanding.mat','u','standing'},
    {'pstanding.mat','p','standing'},
    {'uwalking.mat','u','walking '},
    {'pwalking.mat','p','walking '},
    {'running.mat','p','running '}
    };

finalOutput=[];
finalOutputLabels=[];

for i=1:size(files,1)
    load(files{i}{1});
    
    ax = Acceleration.X;
    ay = Acceleration.Y;
    az = Acceleration.Z;
    ts = Acceleration.Timestamp;
    am = sqrt(ax.^2+ay.^2+az.^2); %acceleration
    p = Orientation.X; %pitch
    t = arrayfun(@(x) seconds(x-ts(1)), ts);
    tend = t(end);
    freq = 10; %20Hz sampling
    tsize = 5; %5 second samples
    sidx = freq*tsize;
    nsamples = floor(tend/tsize);

    numberofpeaks = 4;

    Const=zeros(nsamples,1);
    Ampl=zeros(nsamples,numberofpeaks);
    Freq=zeros(nsamples,numberofpeaks);
    Pitch=zeros(nsamples,1);
    
    act = [];
    for j=1:nsamples
        afftmirrored = abs(fft(am((sidx*(j-1)+1):(sidx*j))));
        afft=afftmirrored(2:(end/2));
        %plot(afft);
        [tempAmpl,tempFreq] = findpeaks(afft, 'SortStr', 'descend', 'NPeaks', numberofpeaks);
        [tempFreq,I] = sort(tempFreq);
        
        Const(j)=afft(1);
        Ampl(j,:)=(tempAmpl(I))';
        Freq(j,:)=tempFreq';
        Pitch(j)=mean(p((sidx*(j-1)+1):(sidx*j)));
        act = [act; files{i}{2}, files{i}{3}];
    end

    finalOutput=[finalOutput; Pitch Const Ampl Freq];
    
    finalOutputLabels=[finalOutputLabels; act];
end

save labelledDataOutput.mat finalOutput finalOutputLabels;
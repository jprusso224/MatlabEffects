% read and store data from audio file
[data,fs,bits] = wavread('twoguitar.wav');
guitar = data(:,1);
len = length(guitar);

% Audio clipping algorithm
temp = abs(guitar);
meanVolume = mean(temp);
over = find(guitar>meanVolume);
guitar(over,1) = meanVolume;
under = find(guitar<-meanVolume);
guitar(under,1) = -meanVolume;
guitar = guitar*2;
% play clipped audio
%sound(guitar,fs);

% Perfrom FFT on guitar data
NFFT= 2^(nextpow2(length(guitar))); 
FFTX = fft(guitar,NFFT);
NumUniquePts = ceil((NFFT+1)/2); 
FFTX = FFTX(1:NumUniquePts);
MX = abs(FFTX); 
MX = MX/length(guitar); 
MX = MX.^2; 
MX = MX*2; 
MX(1) = MX(1)/2; 
if ~rem(NFFT,2) 
   % Here NFFT is even; therefore,Nyquist point is included. 
   MX(end) = MX(end)/2; 
end 
f = (0:NumUniquePts-1)*fs/NFFT; 

% Create a low pass filter to remove high frequencies caused by audio
% clipping
lpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
         'StopbandFrequency',0.75,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
fvtool(lpFilt);
y = filter(lpFilt,guitar); % Apply filter
sound(y,fs);

% Plot filter
figure(1)
plot(f,10*log10(MX))


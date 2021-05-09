% Select files in directory
file = dir('your files directory'); 
s= size(file,1);

for i= 1:s
    % convert xlxs to CSV
    cd 'directory with xlxs'
    Data = xlsread(file(i).name);
    filename=file(i).name;
    filename= filename(1:end-5); % to remove extension from filename
    cd 'directory for csv'
    csvwrite([filename '.csv'], Data);
    Sinal = readtable([filename '.csv']); 
    Sinal = Sinal{:,:};
    
%     I = (Sinal(:,[1]))*0.025;
%     II  = (Sinal(:,[2])*0.025);
%     III  = (Sinal(:,[3]))*0.025;
%     aVR = (Sinal(:,[4]))*0.025;
%     aVL  = (Sinal(:,[5])*0.025);
%     aVF  = (Sinal(:,[6]))*0.025;
    V1 = (Sinal(:,[7]))*0.025;
%     V2  = (Sinal(:,[8])*0.025);
%     V3  = (Sinal(:,[9]))*0.025;
%     V4 = (Sinal(:,[10]))*0.025;
%     V5  = (Sinal(:,[11])*0.025);
%     V6  = (Sinal(:,[12]))*0.025;
       
%     QRS_I = I(210:280);
%     QRSIfilt = sgolayfilt(QRS_I, 5, 37);
%     QRS_II = II(210:280);
%     QRSIIfilt = sgolayfilt(QRS_II, 5, 37);
%     QRS_III = III(210:280);
%     QRSIIIfilt = sgolayfilt(QRS_III, 5, 37);
%     QRS_aVR = aVR(210:280);
%     QRSaVRfilt = sgolayfilt(QRS_aVR, 5, 37);
%     QRS_aVL = aVL(210:280);
%     QRSaVLfilt = sgolayfilt(QRS_aVL, 5, 37);
%     QRS_aVF = aVF(210:280);
%     QRSaVFfilt = sgolayfilt(QRS_aVF, 5, 37);
    QRS_V1 = V1(210:280);
    QRSV1filt = sgolayfilt(QRS_V1, 5, 37);
%     QRS_V2 = V2(210:280);
%     QRSV2filt = sgolayfilt(QRS_V2, 3, 45);
%     QRS_V3 = V3(210:280);
%     QRSV3filt = sgolayfilt(QRS_V3, 3, 45);
%     QRS_V4 = V4(210:280);
%     QRSV4filt = sgolayfilt(QRS_V4, 3, 45);
%     QRS_V5 = V5(210:280);
%     QRSV5filt = sgolayfilt(QRS_V5, 3, 27);
%     QRS_V6 = V6(210:280);
%     QRSV6filt = sgolayfilt(QRS_V6, 3, 27);
        
% DERIVAÇÃO V1 ------------------------------------------------------------
    ondaR_V1 = V1(210:250)
    [AmpR_V1, loc_AmpR_V1] = findpeaks(ondaR_V1, 'MinPeakHeight',0.5,'NPeaks',1);
    if isempty(AmpR_V1)
        loc_AmpR_V1 = 0;
        AmpR_V1 = 0;
        auxOndaQfim = 280;
    else
        auxOndaQfim = 210 + loc_AmpR_V1;
    end
    QR_V1 = V1(210:auxOndaQfim);
    [AmpQ_V1, loc_AmpQ_V1] = findpeaks(-QR_V1, 'MinPeakHeight',0.5,'NPeaks',1);
    AmpQ_V1 = 0 - AmpQ_V1;
    RS_V1 = V1(210+loc_AmpR_V1:280);
    [AmpS_V1, loc_AmpS_V1] = findpeaks(-RS_V1, 'MinPeakHeight',0.5,'NPeaks',1);
    AmpS_V1 = 0 - AmpS_V1;
    loc_AmpS_V1 = loc_AmpS_V1 + loc_AmpR_V1;
    
    derivada_QRS_V1 = diff(QRSV1filt);

% INICIO V1 ---------------------------------------------------------------
    if isempty(AmpQ_V1)
        for x = 1:length(derivada_QRS_V1)
            if x < (loc_AmpR_V1-5)
                zero_sub = derivada_QRS_V1(x) * derivada_QRS_V1(x+1);
                if zero_sub < 0
                    inicio_QRS_V1 = x;
                end
            end
        end
    elseif isempty(AmpR_V1)
           for x = 1:length(derivada_QRS_V1)
               if x < (loc_AmpS_V1 - 5)
                    zero_sub = derivada_QRS_V1(x) * derivada_QRS_V1(x+1);
                    if zero_sub < 0
                        inicio_QRS_V1 = x;
                    end
               end
           end
    else
        for x = 1:length(derivada_QRS_V1)
            if x < (loc_AmpQ_V1-5)
                zero_sub = derivada_QRS_V1(x) * derivada_QRS_V1(x+1);
                if zero_sub < 0
                    inicio_QRS_V1 = x;
                end
            end
        end
    end
% FINAL V1 ----------------------------------------------------------------    
    if isempty(AmpS_V1)
        for x = 1:length(derivada_QRS_V1)
            if (x < length(derivada_QRS_V1)) && (x > loc_AmpR_V1+5)
                zero_sub = derivada_QRS_V1(x) * derivada_QRS_V1(x+1);
                if zero_sub < 0
                    final_QRS_V1 = x;
                    break
                end
            end
        end
    else
        for x = 1:length(derivada_QRS_V1)
            if (x < length(derivada_QRS_V1)) && (x > loc_AmpS_V1+5)
                zero_sub = derivada_QRS_V1(x) * derivada_QRS_V1(x+1);
                if zero_sub < 0
                    final_QRS_V1 = x;
                    break
                end
            end
        end
    end
% QRS DURAÇÃO EM V1 -------------------------------------------------------
    tempo_QRS_V1 = (((final_QRS_V1 - inicio_QRS_V1) * 0.002) * 1000)
    
% Onda R
    R_V1 = AmpR_V1;   
end
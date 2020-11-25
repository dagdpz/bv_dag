function ne_do_tc_stats(in,prefix)
prefix = prefix(1:3);

switch prefix
        case 'GU_'
                % n1 = 127; n2 = 144;     % Gutalin mem memsac-dirsac
                n1 = 127+144; n2 = 168+143;       % Gutalin mem_c dir_c

        case 'RE_'
                % n1 = 174; n2 = 198;     % Redrik mem memsac-dirsac
                n1 = 174+198; n2 = 263+234;       % Redrik mem_c dir_c
                
        case 'FL_'
                % disp('Florian');
                % n1 = 387; n2 = 167;             % choice_r choice_l after inj
                n1 = 379; n2 = 358;               % choice_r choice_l baseline
end
%n1 = 565; n2 = 180; n1=n1+n2; n2=n1; % Gutalin SFN07 poster
%n1 = 597; n2 = 479; n1=n1+n2; n2=n1; % Redrik SFN07 poster

% n1=n1+n2; n2=n1; % for mem_c vs mem_i


%c1 = 1; c2 = 2; % for mem/mem2de
% c1 = 3; c2 = 4; % for 4 curves memsac/dirsac, mem_c vs mem_i
% c1 = 3; c2 = 1; % for 4 curves memsac/dirsac, mem_c vs dir_c
% c1 = c(k,2); c2 = c(k,4);
c1 = 1; c2 = 2; % for choice r/l

data1 = in.data1;
data2 = in.data2;
timeaxis = in.timeaxis;
TimeCourseColorR = in.TimeCourseColorR;
TimeCourseColorG = in.TimeCourseColorG;
TimeCourseColorB = in.TimeCourseColorB;
TimeCourseThick  = in.TimeCourseThick;

for s_k = 1:size(data1,1),
        [H(s_k),p(s_k)] = testt_norawdata(data1(s_k,c1),data1(s_k,c2),data2(s_k,c1)*sqrt(n1),data2(s_k,c2)*sqrt(n2),n1,n2,0,0.05,1,0);
end
%s_k = 7;
%data1(s_k,c1),data1(s_k,c2),data2(s_k,c1)*sqrt(n1),data2(s_k,c2)*sqrt(n2)
%p(s_k)
i_stat = find(H>0);
hold on; plot(timeaxis(i_stat),data1(i_stat,c1),'o','MarkerSize',5,'MarkerFaceColor',[TimeCourseColorR(c1) TimeCourseColorG(c1) TimeCourseColorB(c1)]/255,'MarkerEdgeColor',[1 0 0],'LineWidth',TimeCourseThick(c1)/1.5);

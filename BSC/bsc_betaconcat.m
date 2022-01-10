%project specific; gets data into the format needed for corrmats.m
% BA
% bs0202 = z_score(betaseries_20170202);
% bs0203 = z_score(betaseries_20170203);
% bs0208 = z_score(betaseries_20170208);
% bs0209 = z_score(betaseries_20170209);
% bs0210 = z_score(betaseries_20170210);
% bs0216 = z_score(betaseries_20170216);
% bs0222 = z_score(betaseries_20170222);
% bs0223 = z_score(betaseries_20170223);
% bs0224 = z_score(betaseries_20170224);
% bs0301 = z_score(betaseries_20170301);
% bs0302 = z_score(betaseries_20170302);
% bs0303 = z_score(betaseries_20170303);
% bs0317 = z_score(betaseries_20170317);
% bs0324 = z_score(betaseries_20170324);
% bs0329 = z_score(betaseries_20170329);
% bs0405 = z_score(betaseries_20170405);
% bs0406 = z_score(betaseries_20170406);
% bs0407 = z_score(betaseries_20170407);
% bs0412 = z_score(betaseries_20170412);
% bs0413 = z_score(betaseries_20170413);
% bs0426 = z_score(betaseries_20170426);
% bs0427 = z_score(betaseries_20170427);
% bs0428 = z_score(betaseries_20170428);
% bs0503 = z_score(betaseries_20170503);
% bs0504 = z_score(betaseries_20170504);
% bs0505 = z_score(betaseries_20170505);
% bs0511 = z_score(betaseries_20170511);
% bs0517 = z_score(betaseries_20170517);
% bs0518 = z_score(betaseries_20170518);
% bs0601 = z_score(betaseries_20170601);
% bs0602 = z_score(betaseries_20170602);
% bs0607 = z_score(betaseries_20170607);
% bs0608 = z_score(betaseries_20170608);
% bs0609 = z_score(betaseries_20170609);
% bs0614 = z_score(betaseries_20170614);
% bs0615 = z_score(betaseries_20170615);
% bs0616 = z_score(betaseries_20170616);
% bs0622 = z_score(betaseries_20170622);
% bs0623 = z_score(betaseries_20170623);

% bs0202 = z_score(fullbrain_betaseries_20170202);
% bs0203 = z_score(fullbrain_betaseries_20170203);
% bs0208 = z_score(fullbrain_betaseries_20170208);
% bs0209 = z_score(fullbrain_betaseries_20170209);
% bs0210 = z_score(fullbrain_betaseries_20170210);
% bs0216 = z_score(fullbrain_betaseries_20170216);
% bs0222 = z_score(fullbrain_betaseries_20170222);
% bs0223 = z_score(fullbrain_betaseries_20170223);
% bs0224 = z_score(fullbrain_betaseries_20170224);
% bs0301 = z_score(fullbrain_betaseries_20170301);
% bs0302 = z_score(fullbrain_betaseries_20170302);
% bs0303 = z_score(fullbrain_betaseries_20170303);
% bs0317 = z_score(fullbrain_betaseries_20170317);
% bs0324 = z_score(fullbrain_betaseries_20170324);
% bs0329 = z_score(fullbrain_betaseries_20170329);
% bs0405 = z_score(fullbrain_betaseries_20170405);
% bs0406 = z_score(fullbrain_betaseries_20170406);
% bs0407 = z_score(fullbrain_betaseries_20170407);
% bs0412 = z_score(fullbrain_betaseries_20170412);
% bs0413 = z_score(fullbrain_betaseries_20170413);
% bs0426 = z_score(fullbrain_betaseries_20170426);
% bs0427 = z_score(fullbrain_betaseries_20170427);
% bs0428 = z_score(fullbrain_betaseries_20170428);
% bs0503 = z_score(fullbrain_betaseries_20170503);
% bs0504 = z_score(fullbrain_betaseries_20170504);
% bs0505 = z_score(fullbrain_betaseries_20170505);
% bs0511 = z_score(fullbrain_betaseries_20170511);
% bs0517 = z_score(fullbrain_betaseries_20170517);
% bs0518 = z_score(fullbrain_betaseries_20170518);
% bs0601 = z_score(fullbrain_betaseries_20170601);
% bs0602 = z_score(fullbrain_betaseries_20170602);
% bs0607 = z_score(fullbrain_betaseries_20170607);
% bs0608 = z_score(fullbrain_betaseries_20170608);
% bs0609 = z_score(fullbrain_betaseries_20170609);
% bs0614 = z_score(fullbrain_betaseries_20170614);
% bs0615 = z_score(fullbrain_betaseries_20170615);
% bs0616 = z_score(fullbrain_betaseries_20170616);
% bs0622 = z_score(fullbrain_betaseries_20170622);
% bs0623 = z_score(fullbrain_betaseries_20170623);
% 
% fixpul = vertcat(bs0202{1}, bs0203{1},bs0208{1},bs0209{1},bs0210{1},bs0216{1},bs0222{1},bs0223{1},bs0224{1},...
%     bs0301{1},bs0302{1},bs0303{1},bs0317{1},bs0324{1},bs0329{1},bs0405{1},bs0406{1},bs0407{1});
% 
% fixlip = vertcat(bs0412{1},bs0413{1},bs0426{1},bs0427{1},bs0428{1},bs0503{1},...
%     bs0504{1},bs0505{1},bs0511{1},bs0517{1},bs0518{1},bs0601{1},bs0602{1},bs0607{1},bs0608{1},bs0609{1}, ...
%     bs0614{1},bs0615{1},bs0616{1},bs0622{1},bs0623{1});
% 
% fixmspul = vertcat(bs0202{2}, bs0203{2},bs0208{2},bs0209{2},bs0210{2},bs0216{2},bs0222{2},bs0223{2},bs0224{2},...
%     bs0301{2},bs0302{2},bs0303{2},bs0317{2},bs0324{2},bs0329{2},bs0405{2},bs0406{2},bs0407{2});
% 
% fixmslip = vertcat(bs0412{2},bs0413{2},bs0426{2},bs0427{2},bs0428{2},bs0503{2},...
%     bs0504{2},bs0505{2},bs0511{2},bs0517{2},bs0518{2},bs0601{2},bs0602{2},bs0607{2},bs0608{2},bs0609{2}, ...
%     bs0614{2},bs0615{2},bs0616{2},bs0622{2},bs0623{2});
% 
% memlpul = vertcat(bs0202{3}, bs0203{3},bs0208{3},bs0209{3},bs0210{3},bs0216{3},bs0222{3},bs0223{3},bs0224{3},...
%     bs0301{3},bs0302{3},bs0303{3},bs0317{3},bs0324{3},bs0329{3},bs0405{3},bs0406{3},bs0407{3});
% 
% memllip = vertcat(bs0412{3},bs0413{3},bs0426{3},bs0427{3},bs0428{3},bs0503{3},...
%     bs0504{3},bs0505{3},bs0511{3},bs0517{3},bs0518{3},bs0601{3},bs0602{3},bs0607{3},bs0608{3},bs0609{3}, ...
%     bs0614{3},bs0615{3},bs0616{3},bs0622{3},bs0623{3});
% 
% memrpul = vertcat(bs0202{4}, bs0203{4},bs0208{4},bs0209{4},bs0210{4},bs0216{4},bs0222{4},bs0223{4},bs0224{4},...
%     bs0301{4},bs0302{4},bs0303{4},bs0317{4},bs0324{4},bs0329{4},bs0405{4},bs0406{4},bs0407{4});
% 
% memrlip = vertcat(bs0412{4},bs0413{4},bs0426{4},bs0427{4},bs0428{4},bs0503{4},...
%     bs0504{4},bs0505{4},bs0511{4},bs0517{4},bs0518{4},bs0601{4},bs0602{4},bs0607{4},bs0608{4},bs0609{4}, ...
%     bs0614{4},bs0615{4},bs0616{4},bs0622{4},bs0623{4});
% 
% memlmspul = vertcat(bs0202{5}, bs0203{5},bs0208{5},bs0209{5},bs0210{5},bs0216{5},bs0222{5},bs0223{5},bs0224{5},...
%     bs0301{5},bs0302{5},bs0303{5},bs0317{5},bs0324{5},bs0329{5},bs0405{5},bs0406{5},bs0407{5});
% 
% memlmslip = vertcat(bs0412{5},bs0413{5},bs0426{5},bs0427{5},bs0428{5},bs0503{5},...
%     bs0504{5},bs0505{5},bs0511{5},bs0517{5},bs0518{5},bs0601{5},bs0602{5},bs0607{5},bs0608{5},bs0609{5}, ...
%     bs0614{5},bs0615{5},bs0616{5},bs0622{5},bs0623{5});
% 
% memrmspul = vertcat(bs0202{6}, bs0203{6},bs0208{6},bs0209{6},bs0210{6},bs0216{6},bs0222{6},bs0223{6},bs0224{6},...
%     bs0301{6},bs0302{6},bs0303{6},bs0317{6},bs0324{6},bs0329{6},bs0405{6},bs0406{6},bs0407{6});
% 
% memrmslip = vertcat(bs0412{6},bs0413{6},bs0426{6},bs0427{6},bs0428{6},bs0503{6},...
%     bs0504{6},bs0505{6},bs0511{6},bs0517{6},bs0518{6},bs0601{6},bs0602{6},bs0607{6},bs0608{6},bs0609{6}, ...
%     bs0614{6},bs0615{6},bs0616{6},bs0622{6},bs0623{6});
% 
% pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
% lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};

% % %CU
bs1129 = z_score(fullbrain_betaseries_20131129);
bs1204 = z_score(fullbrain_betaseries_20131204);
bs1211 = z_score(fullbrain_betaseries_20131211);
bs1213 = z_score(fullbrain_betaseries_20131213);
bs1218 = z_score(fullbrain_betaseries_20131218);
bs0122 = z_score(fullbrain_betaseries_20140122);
bs0124 = z_score(fullbrain_betaseries_20140124);
bs0129 = z_score(fullbrain_betaseries_20140129);
bs0131 = z_score(fullbrain_betaseries_20140131);
bs0204 = z_score(fullbrain_betaseries_20140204);
bs0214 = z_score(fullbrain_betaseries_20140214);
bs0226 = z_score(fullbrain_betaseries_20140226);
bs0303 = z_score(fullbrain_betaseries_20150303);
bs0311 = z_score(fullbrain_betaseries_20150311);
bs0422 = z_score(fullbrain_betaseries_20150422);
bs0423 = z_score(fullbrain_betaseries_20150423);
bs0429 = z_score(fullbrain_betaseries_20150429);
bs0430 = z_score(fullbrain_betaseries_20150430);
bs0506 = z_score(fullbrain_betaseries_20150506);
bs0507 = z_score(fullbrain_betaseries_20150507);

% bs1129 = z_score(betaseries_20131129);
% bs1204 = z_score(betaseries_20131204);
% bs1211 = z_score(betaseries_20131211);
% bs1213 = z_score(betaseries_20131213);
% bs1218 = z_score(betaseries_20131218);
% bs0122 = z_score(betaseries_20140122);
% bs0124 = z_score(betaseries_20140124);
% bs0129 = z_score(betaseries_20140129);
% bs0131 = z_score(betaseries_20140131);
% bs0204 = z_score(betaseries_20140204);
% bs0214 = z_score(betaseries_20140214);
% bs0226 = z_score(betaseries_20140226);
% bs0303 = z_score(betaseries_20150303);
% bs0311 = z_score(betaseries_20150311);
% bs0422 = z_score(betaseries_20150422);
% bs0423 = z_score(betaseries_20150423);
% bs0429 = z_score(betaseries_20150429);
% bs0430 = z_score(betaseries_20150430);
% bs0506 = z_score(betaseries_20150506);
% bs0507 = z_score(betaseries_20150507);

% % 
fixpul = vertcat(bs1129{1}, bs1204{1}, bs1211{1}, bs1213{1}, bs1218{1}, bs0122{1}, bs0124{1},bs0129{1},...
    bs0131{1}, bs0204{1}, bs0214{1}, bs0226{1});
fixlip = vertcat(bs0303{1}, bs0311{1},bs0422{1}, bs0423{1}, bs0429{1}, bs0430{1}, bs0506{1}, bs0507{1});

fixmspul = vertcat(bs1129{2}, bs1204{2}, bs1211{2}, bs1213{2}, bs1218{2}, bs0122{2}, bs0124{2},bs0129{2},...
    bs0131{2}, bs0204{2}, bs0214{2}, bs0226{2});
fixmslip = vertcat(bs0303{2}, bs0311{2},bs0422{2}, bs0423{2}, bs0429{2}, bs0430{2}, bs0506{2}, bs0507{2});

memlpul = vertcat(bs1129{3}, bs1204{3}, bs1211{3}, bs1213{3}, bs1218{3}, bs0122{3}, bs0124{3},bs0129{3},...
    bs0131{3}, bs0204{3}, bs0214{3}, bs0226{3});
memllip = vertcat(bs0303{3}, bs0311{3},bs0422{3}, bs0423{3}, bs0429{3}, bs0430{3}, bs0506{3}, bs0507{3});

memrpul = vertcat(bs1129{4}, bs1204{4}, bs1211{4}, bs1213{4}, bs1218{4}, bs0122{4}, bs0124{4},bs0129{4},...
    bs0131{4}, bs0204{4}, bs0214{4}, bs0226{4});
memrlip = vertcat(bs0303{4}, bs0311{4},bs0422{4}, bs0423{4}, bs0429{4}, bs0430{4}, bs0506{4}, bs0507{4});

memlmspul = vertcat(bs1129{5}, bs1204{5}, bs1211{5}, bs1213{5}, bs1218{5}, bs0122{5}, bs0124{5},bs0129{5},...
    bs0131{5}, bs0204{5}, bs0214{5}, bs0226{5});
memlmslip = vertcat(bs0303{5}, bs0311{5},bs0422{5}, bs0423{5}, bs0429{5}, bs0430{5}, bs0506{5}, bs0507{5});

memrmspul = vertcat(bs1129{6}, bs1204{6}, bs1211{6}, bs1213{6}, bs1218{6}, bs0122{6}, bs0124{6},bs0129{6},...
    bs0131{6}, bs0204{6}, bs0214{6}, bs0226{6});
memrmslip = vertcat(bs0303{6}, bs0311{6},bs0422{6}, bs0423{6}, bs0429{6}, bs0430{6}, bs0506{6}, bs0507{6});

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};
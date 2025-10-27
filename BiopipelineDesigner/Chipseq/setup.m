function setup()

% TO DO:
% this currently does not work because matlab.addons.install installs
% Add-Ons without installing dependent, 3rd party software

s = dir("mltbx/*mltbx");
toolboxFile = string({s.name});
agreeToLicense = true;
for currenttbx = toolboxFile
    matlab.addons.install(currenttbx,agreeToLicense);
end

end
